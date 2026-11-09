import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/app/providers/app_providers.dart';
import 'package:servis/core/constants/app_constants.dart';
import 'package:servis/core/services/attachment_storage_service.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/maintenance/data/maintenance_repository.dart';
import 'package:servis/features/maintenance/domain/maintenance_calculator.dart';
import 'package:servis/features/maintenance/domain/maintenance_schedule.dart';
import 'package:servis/features/motorcycles/data/motorcycle_repository.dart';
import 'package:servis/features/odometer/data/odometer_repository.dart';
import 'package:servis/features/reports/data/report_repository.dart';
import 'package:servis/features/service_records/data/service_record_repository.dart';

void main() {
  late AppDatabase db;
  late MotorcycleRepository motorcycleRepo;
  late OdometerRepository odoRepo;
  late MaintenanceRepository maintenanceRepo;
  late ServiceRecordRepository serviceRepo;
  late ReportRepository reportRepo;

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
  });

  tearDown(() async {
    await db.close();
  });

  group('Dashboard Reactivity & Priority Sorting Tests', () {
    test('watchAll reactively emits updated current odometer when new odometer reading is added', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      final stream = motorcycleRepo.watchAll();
      final history = <int>[];

      final subscription = stream.listen((list) {
        if (list.isNotEmpty) {
          history.add(list.first.currentOdometerKm);
        }
      });

      // Allow initial emission
      await Future.delayed(const Duration(milliseconds: 50));
      expect(history.last, 1000);

      // Add new odometer reading
      await odoRepo.addReading(
        motorcycleId: motorId,
        odometerKm: 1800,
        readingDate: DateTime.now(),
      );

      await Future.delayed(const Duration(milliseconds: 50));
      expect(history.last, 1800);

      await subscription.cancel();
    });

    test('Strict dashboard priority sorting orders Terlambat > Segera > Aman > Belum diatur', () {
      final now = DateTime.now();
      final schedTerlambat = MaintenanceSchedule(
        id: '1',
        motorcycleId: 'm1',
        name: 'Oli Mesin',
        intervalKm: 2000,
        lastDoneKm: 1000,
        createdAt: now,
        updatedAt: now,
      );
      final schedSegera = MaintenanceSchedule(
        id: '2',
        motorcycleId: 'm1',
        name: 'Busi',
        intervalKm: 4000,
        lastDoneKm: 1000,
        reminderLeadKm: 500,
        createdAt: now,
        updatedAt: now,
      );
      final schedAman = MaintenanceSchedule(
        id: '3',
        motorcycleId: 'm1',
        name: 'Filter Udara',
        intervalKm: 10000,
        lastDoneKm: 1000,
        createdAt: now,
        updatedAt: now,
      );
      final schedBelumDiatur = MaintenanceSchedule(
        id: '4',
        motorcycleId: 'm1',
        name: 'V-Belt',
        intervalKm: 15000,
        createdAt: now,
        updatedAt: now,
      );

      // At odometer 4800 km:
      // Sched 1: Due at 3000 -> Terlambat (-1800 km)
      // Sched 2: Due at 5000 -> Segera (remaining 200 km <= lead 500)
      // Sched 3: Due at 11000 -> Aman (remaining 6200 km)
      // Sched 4: No baseline -> Belum diatur
      const currentOdo = 4800;
      final items = [
        DashboardScheduleItem(
          schedule: schedAman,
          calculation: MaintenanceCalculator.calculate(
            schedule: schedAman,
            currentOdometerKm: currentOdo,
          ),
        ),
        DashboardScheduleItem(
          schedule: schedBelumDiatur,
          calculation: MaintenanceCalculator.calculate(
            schedule: schedBelumDiatur,
            currentOdometerKm: currentOdo,
          ),
        ),
        DashboardScheduleItem(
          schedule: schedTerlambat,
          calculation: MaintenanceCalculator.calculate(
            schedule: schedTerlambat,
            currentOdometerKm: currentOdo,
          ),
        ),
        DashboardScheduleItem(
          schedule: schedSegera,
          calculation: MaintenanceCalculator.calculate(
            schedule: schedSegera,
            currentOdometerKm: currentOdo,
          ),
        ),
      ];

      // Sort using production comparator
      items.sort(compareScheduleUrgency);

      expect(items[0].calculation.status, MaintenanceStatus.terlambat);
      expect(items[1].calculation.status, MaintenanceStatus.segera);
      expect(items[2].calculation.status, MaintenanceStatus.aman);
      expect(items[3].calculation.status, MaintenanceStatus.belumDiatur);
    });

    test('Overdue priority sorting orders more severely overdue schedules before less overdue ones', () {
      final now = DateTime.now();
      // Schedule A: interval 2000 km, lastDone at 1000 km. At 4000 km, elapsed = 3000 km (150% progress, 1000 km overdue)
      final schedSevere = MaintenanceSchedule(
        id: '1',
        motorcycleId: 'm1',
        name: 'Oli Mesin',
        intervalKm: 2000,
        lastDoneKm: 1000,
        createdAt: now,
        updatedAt: now,
      );
      // Schedule B: interval 2000 km, lastDone at 1000 km. At 3200 km, elapsed = 2200 km (110% progress, 200 km overdue)
      final schedMild = MaintenanceSchedule(
        id: '2',
        motorcycleId: 'm1',
        name: 'Busi',
        intervalKm: 2000,
        lastDoneKm: 1000,
        createdAt: now,
        updatedAt: now,
      );

      final calcSevere = MaintenanceCalculator.calculate(
        schedule: schedSevere,
        currentOdometerKm: 4000,
      );
      final calcMild = MaintenanceCalculator.calculate(
        schedule: schedMild,
        currentOdometerKm: 3200,
      );

      expect(calcSevere.status, MaintenanceStatus.terlambat);
      expect(calcMild.status, MaintenanceStatus.terlambat);

      final items = [
        DashboardScheduleItem(schedule: schedMild, calculation: calcMild),
        DashboardScheduleItem(schedule: schedSevere, calculation: calcSevere),
      ];

      items.sort(compareScheduleUrgency);

      // The more severely overdue schedule must come first
      expect(items[0].schedule.name, 'Oli Mesin');
      expect(items[1].schedule.name, 'Busi');
    });

    test('Dashboard expense summary calculates month expense correctly and updates when records change', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      final now = DateTime.now();
      final result1 = await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: now,
        odometerKm: 1500,
        additionalCost: 10000,
        items: [
          {'itemName': 'Oli Mesin', 'itemCost': 65000},
        ],
      );

      var monthExpense = await reportRepo.getCurrentMonthExpense(motorId);
      expect(monthExpense, 75000); // 65000 + 10000

      // Add another record in current month
      await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: now,
        odometerKm: 2000,
        additionalCost: 5000,
        items: [
          {'itemName': 'Busi', 'itemCost': 25000},
        ],
      );

      monthExpense = await reportRepo.getCurrentMonthExpense(motorId);
      expect(monthExpense, 105000); // 75000 + 30000

      // Delete first record
      await serviceRepo.deleteRecord(result1.recordId);
      monthExpense = await reportRepo.getCurrentMonthExpense(motorId);
      expect(monthExpense, 30000); // Only second record left
    });
  });
}
