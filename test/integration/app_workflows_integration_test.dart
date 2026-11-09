import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/core/constants/app_constants.dart';
import 'package:servis/core/services/attachment_storage_service.dart';
import 'package:servis/core/services/notification_service.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/maintenance/data/maintenance_repository.dart';
import 'package:servis/features/maintenance/domain/maintenance_calculator.dart';
import 'package:servis/features/maintenance/domain/maintenance_schedule.dart';
import 'package:servis/features/motorcycles/data/motorcycle_repository.dart';
import 'package:servis/features/odometer/data/odometer_repository.dart';
import 'package:servis/features/reports/data/report_repository.dart';
import 'package:servis/features/reports/domain/expense_summary.dart';
import 'package:servis/features/service_records/data/service_record_repository.dart';
import 'package:servis/features/settings/data/settings_repository.dart';

void main() {
  late AppDatabase db;
  late MotorcycleRepository motorcycleRepo;
  late OdometerRepository odoRepo;
  late MaintenanceRepository maintenanceRepo;
  late ServiceRecordRepository serviceRepo;
  late ReportRepository reportRepo;
  late SettingsRepository settingsRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    motorcycleRepo = MotorcycleRepository(db);
    odoRepo = OdometerRepository(db);
    maintenanceRepo = MaintenanceRepository(db);
    serviceRepo = ServiceRecordRepository(
      db: db,
      attachmentService: AttachmentStorageService(),
      maintenanceRepository: maintenanceRepo,
    );
    reportRepo = ReportRepository(db: db, serviceRecordRepository: serviceRepo);
    settingsRepo = SettingsRepository(
      db: db,
      notificationService: NotificationService(),
      attachmentService: AttachmentStorageService(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Full End-to-End Application Integration Workflows', () {
    test('Complete motorcycle lifecycle: CRUD, Odometer, Schedules, Service, Recalculation, Reports, and Cascade Delete', () async {
      // 1. Add first motorcycle (Vario 160)
      final varioId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario Harian',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        propulsionType: AppConstants.propulsionGasoline,
        manufactureYear: 2023,
        licensePlate: 'B 1234 ABC',
        initialOdometerKm: 5000,
      );

      var vario = await motorcycleRepo.getById(varioId);
      expect(vario, isNotNull);
      expect(vario?.nickname, 'Vario Harian');
      expect(vario?.currentOdometerKm, 5000);

      // Verify active motorcycle setting is automatically set to first motorcycle
      final activeSetting = await settingsRepo.getActiveMotorcycleId();
      expect(activeSetting, varioId);

      // 2. Add second motorcycle (Aerox) and switch active motorcycle
      final aeroxId = await motorcycleRepo.createMotorcycle(
        nickname: 'Aerox Touring',
        brand: 'Yamaha',
        model: 'Aerox 155',
        motorcycleType: AppConstants.typeMatic,
        propulsionType: AppConstants.propulsionGasoline,
        initialOdometerKm: 12000,
      );

      final allMotorcycles = await motorcycleRepo.getAll();
      expect(allMotorcycles.length, 2);

      await settingsRepo.setActiveMotorcycleId(aeroxId);
      final newActiveSetting = await settingsRepo.getActiveMotorcycleId();
      expect(newActiveSetting, aeroxId);

      // Switch back to Vario for maintenance workflow
      await settingsRepo.setActiveMotorcycleId(varioId);

      // 3. Update Vario odometer
      await odoRepo.addReading(
        motorcycleId: varioId,
        odometerKm: 5400,
        readingDate: DateTime.now(),
        notes: 'Perjalanan kantor',
      );

      vario = await motorcycleRepo.getById(varioId);
      expect(vario?.currentOdometerKm, 5400);

      // 4. Create maintenance schedule for Vario (Oli Mesin)
      final scheduleId = await maintenanceRepo.createSchedule(
        motorcycleId: varioId,
        name: 'Oli Mesin',
        category: 'Pelumasan',
        intervalKm: 2000,
        intervalMonths: 3,
        lastDoneKm: 5000,
        lastDoneDate: DateTime.now().subtract(const Duration(days: 30)),
        reminderLeadKm: 300,
        reminderLeadDays: 7,
      );

      var schedule = await maintenanceRepo.getById(scheduleId);
      expect(schedule, isNotNull);

      // Calculate schedule status at 5400 km
      // Due km is 5000 + 2000 = 7000 km. Remaining: 1600 km. -> Aman
      var calc = MaintenanceCalculator.calculate(
        schedule: schedule!,
        currentOdometerKm: 5400,
      );
      expect(calc.status, MaintenanceStatus.aman);
      expect(calc.remainingKm, 1600);

      // 5. Update odometer to 6800 km (Remaining: 200 km <= reminderLeadKm 300) -> Segera
      await odoRepo.addReading(
        motorcycleId: varioId,
        odometerKm: 6800,
        readingDate: DateTime.now(),
      );

      calc = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 6800,
      );
      expect(calc.status, MaintenanceStatus.segera);
      expect(calc.remainingKm, 200);

      // 6. Record a service visit with multiple items linking to this schedule
      final today = DateTime.now();
      final createResult = await serviceRepo.createRecord(
        motorcycleId: varioId,
        serviceDate: today,
        odometerKm: 7000,
        workshopName: 'AHASS Mitra Prima',
        additionalCost: 15000,
        items: [
          {
            'itemName': 'Oli Mesin MPX2',
            'category': 'Pelumasan',
            'itemCost': 65000,
            'maintenanceScheduleId': scheduleId,
          },
          {
            'itemName': 'Busi U27EPR9',
            'category': 'Pengapian',
            'itemCost': 25000,
            'maintenanceScheduleId': null,
          },
        ],
      );
      final recordId = createResult.recordId;

      // Verify service record
      final record = await serviceRepo.getById(recordId);
      expect(record, isNotNull);
      expect(record?.items.length, 2);
      expect(record?.itemsTotalCost, 90000); // 65000 + 25000
      expect(record?.additionalCost, 15000);
      expect(record?.totalCost, 105000); // 90000 + 15000

      // 7. Verify schedule baseline updated to 7000 km & today
      schedule = await maintenanceRepo.getById(scheduleId);
      expect(schedule?.lastDoneKm, 7000);
      expect(
        schedule?.manualLastDoneKm,
        5000,
      ); // manual baseline safely preserved!

      // Re-evaluate schedule: due km is now 7000 + 2000 = 9000 km!
      // Current odometer is 7000. Remaining: 2000 km -> Aman!
      calc = MaintenanceCalculator.calculate(
        schedule: schedule!,
        currentOdometerKm: 7000,
      );
      expect(calc.status, MaintenanceStatus.aman);
      expect(calc.dueKm, 9000);
      expect(calc.remainingKm, 2000);

      // 8. Verify expense reports show exact transaction
      final reportSummary = await reportRepo.getReportSummary(
        motorcycleId: varioId,
        period: ReportPeriod.thisMonth,
      );
      expect(reportSummary.totalCost, 105000);
      expect(reportSummary.serviceCount, 1);

      // 9. Delete service record and verify schedule restores manual baseline (5000 km)
      await serviceRepo.deleteRecord(recordId);

      schedule = await maintenanceRepo.getById(scheduleId);
      expect(schedule?.lastDoneKm, 5000); // reverted to manual baseline

      // Reports after service deletion immediately reflect Rp0
      final reportAfterDelete = await reportRepo.getReportSummary(
        motorcycleId: varioId,
        period: ReportPeriod.thisMonth,
      );
      expect(reportAfterDelete.totalCost, 0);
      expect(reportAfterDelete.serviceCount, 0);

      // 10. Delete motorcycle and verify cascade cleanup
      await motorcycleRepo.deleteMotorcycle(varioId);

      final varioAfterDelete = await motorcycleRepo.getById(varioId);
      expect(varioAfterDelete, isNull);

      final schedulesAfterDelete = await maintenanceRepo.getSchedules(varioId);
      expect(schedulesAfterDelete.isEmpty, isTrue);

      final readingsAfterDelete = await odoRepo.getReadings(varioId);
      expect(readingsAfterDelete.isEmpty, isTrue);

      // Active motorcycle should automatically fall back to Aerox
      final activeAfterVarioDelete = await settingsRepo.getActiveMotorcycleId();
      expect(activeAfterVarioDelete, aeroxId);
    });
  });
}
