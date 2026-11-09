import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:servis/core/constants/app_constants.dart';
import 'package:servis/core/services/attachment_storage_service.dart';
import 'package:servis/core/services/notification_service.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/maintenance/data/maintenance_repository.dart';
import 'package:servis/features/motorcycles/data/motorcycle_repository.dart';
import 'package:servis/features/service_records/data/service_record_repository.dart';
import 'package:servis/features/settings/data/settings_repository.dart';

class MockNotificationServiceForWipe extends NotificationService {
  bool cancelledAll = false;

  @override
  Future<NotificationCancelResult> cancelAllNotifications() async {
    cancelledAll = true;
    return NotificationCancelResult.success;
  }
}

void main() {
  late AppDatabase db;
  late MockNotificationServiceForWipe mockNotif;
  late AttachmentStorageService attachmentService;
  late MotorcycleRepository motorcycleRepo;
  late MaintenanceRepository maintenanceRepo;
  late ServiceRecordRepository serviceRepo;
  late SettingsRepository settingsRepo;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('servisku_test_wipe_');
    db = AppDatabase(NativeDatabase.memory());
    mockNotif = MockNotificationServiceForWipe();
    attachmentService = AttachmentStorageService(baseDirectory: tempDir);
    motorcycleRepo = MotorcycleRepository(db);
    maintenanceRepo = MaintenanceRepository(db);
    serviceRepo = ServiceRecordRepository(
      db: db,
      attachmentService: attachmentService,
      maintenanceRepository: maintenanceRepo,
    );
    settingsRepo = SettingsRepository(
      db: db,
      notificationService: mockNotif,
      attachmentService: attachmentService,
    );
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  File createTestPhoto(String name) {
    final image = img.Image(width: 10, height: 10);
    final bytes = img.encodeJpg(image);
    final file = File('${tempDir.path}/$name');
    file.writeAsBytesSync(bytes);
    return file;
  }

  group('Safe Data Deletion Tests', () {
    test(
        'clearAllData cancels notifications, wipes all database tables, and cleans attachments',
        () async {
      // 1. Populate data
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario Harian',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Ganti Oli',
        intervalKm: 2000,
      );

      final photo = createTestPhoto('nota.jpg');
      await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: DateTime.now(),
        odometerKm: 2000,
        items: [
          {'itemName': 'Oli MPX2', 'itemCost': 60000},
        ],
        photoFiles: [photo],
      );

      // Verify data exists
      expect((await motorcycleRepo.getAll()).length, 1);
      expect((await serviceRepo.getRecords()).length, 1);
      expect((await maintenanceRepo.getSchedules(motorId)).length, 1);

      // 2. Perform safe clearAllData
      await settingsRepo.clearAllData();

      // 3. Verify
      expect(mockNotif.cancelledAll, isTrue);
      expect((await motorcycleRepo.getAll()), isEmpty);
      expect((await serviceRepo.getRecords()), isEmpty);
      expect((await db.select(db.odometerReadings).get()), isEmpty);
      expect((await db.select(db.maintenanceSchedules).get()), isEmpty);
      expect((await db.select(db.serviceAttachments).get()), isEmpty);
      expect((await db.select(db.appSettings).get()), isEmpty);
    });
  });
}
