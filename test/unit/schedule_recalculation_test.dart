import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/core/services/attachment_storage_service.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/maintenance/data/maintenance_repository.dart';
import 'package:servis/features/motorcycles/data/motorcycle_repository.dart';
import 'package:servis/features/service_records/data/service_record_repository.dart';

void main() {
  late AppDatabase db;
  late MotorcycleRepository motorcycleRepo;
  late MaintenanceRepository maintenanceRepo;
  late ServiceRecordRepository serviceRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    motorcycleRepo = MotorcycleRepository(db);
    maintenanceRepo = MaintenanceRepository(db);
    serviceRepo = ServiceRecordRepository(
      db: db,
      attachmentService: AttachmentStorageService(),
      maintenanceRepository: maintenanceRepo,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Schedule Baseline and Recalculation Tests', () {
    test(
        'Schedule updates from service completion and restores manual baseline when service deleted',
        () async {
      // 1. Create motorcycle
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario Test',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: 'matic',
        propulsionType: 'gasoline',
        initialOdometerKm: 1000,
        initialReadingDate: DateTime(2026, 1, 1),
      );

      // 2. Create schedule with manual baseline
      final scheduleId = await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Oli Mesin',
        category: 'Pelumasan',
        intervalKm: 2000,
        intervalMonths: 3,
        lastDoneKm: 1000,
        lastDoneDate: DateTime(2026, 1, 1),
      );

      var schedule = await maintenanceRepo.getById(scheduleId);
      expect(schedule?.lastDoneKm, 1000);
      expect(schedule?.manualLastDoneKm, 1000);

      // 3. Add service record linked to schedule
      final createResult = await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: DateTime(2026, 3, 15),
        odometerKm: 3100,
        workshopName: 'AHASS 1',
        additionalCost: 10000,
        items: [
          {
            'itemName': 'Ganti Oli Mesin',
            'itemCost': 65000,
            'maintenanceScheduleId': scheduleId,
          }
        ],
      );
      final recordId = createResult.recordId;

      // Schedule last_done should now be updated to 3100 km and 2026-03-15
      schedule = await maintenanceRepo.getById(scheduleId);
      expect(schedule?.lastDoneKm, 3100);
      expect(schedule?.lastDoneDate?.year, 2026);
      expect(schedule?.lastDoneDate?.month, 3);
      expect(schedule?.lastDoneDate?.day, 15);
      // Manual baseline is still safely preserved!
      expect(schedule?.manualLastDoneKm, 1000);

      // 4. Delete the service record
      await serviceRepo.deleteRecord(recordId);

      // Schedule last_done should safely revert to the manual baseline!
      schedule = await maintenanceRepo.getById(scheduleId);
      expect(schedule?.lastDoneKm, 1000);
      expect(schedule?.lastDoneDate?.year, 2026);
      expect(schedule?.lastDoneDate?.month, 1);
      expect(schedule?.lastDoneDate?.day, 1);
    });
  });
}
