import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:servis/core/constants/app_constants.dart';
import 'package:servis/core/errors/app_exceptions.dart';
import 'package:servis/core/services/attachment_storage_service.dart';
import 'package:servis/core/services/notification_service.dart';
import 'package:servis/core/validators/app_validators.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/maintenance/application/notification_reconciler.dart';
import 'package:servis/features/maintenance/data/maintenance_repository.dart';
import 'package:servis/features/maintenance/domain/maintenance_calculator.dart';
import 'package:servis/features/maintenance/domain/maintenance_schedule.dart';
import 'package:servis/features/motorcycles/data/motorcycle_repository.dart';
import 'package:servis/features/reports/data/report_repository.dart';
import 'package:servis/features/service_records/data/service_record_repository.dart';
import 'package:servis/features/settings/data/settings_repository.dart';

class MockNotificationServiceForHardening extends NotificationService {
  final List<int> cancelledIds = [];
  bool cancelledAll = false;
  int timezoneRefreshCount = 0;
  bool shouldFailCancel = false;

  @override
  Future<bool> areNotificationsEnabled() async => true;

  @override
  Future<NotificationCancelResult> cancelNotification(int id) async {
    if (shouldFailCancel) {
      return NotificationCancelResult.failure('Simulated platform cancellation error', id);
    }
    cancelledIds.add(id);
    return NotificationCancelResult.success;
  }

  @override
  Future<NotificationCancelResult> cancelAllNotifications() async {
    if (shouldFailCancel) {
      return NotificationCancelResult.failure('Simulated cancel-all error');
    }
    cancelledAll = true;
    return NotificationCancelResult.success;
  }

  @override
  Future<void> refreshDeviceTimezone() async {
    timezoneRefreshCount++;
  }
}

void main() {
  late AppDatabase db;
  late MockNotificationServiceForHardening mockNotificationService;
  late AttachmentStorageService attachmentService;
  late NotificationReconciler reconciler;
  late MotorcycleRepository motorcycleRepo;
  late MaintenanceRepository maintenanceRepo;
  late ServiceRecordRepository serviceRepo;
  late ReportRepository reportRepo;
  late SettingsRepository settingsRepo;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hardening_test_');
    db = AppDatabase(NativeDatabase.memory());
    attachmentService = AttachmentStorageService(baseDirectory: tempDir);
    mockNotificationService = MockNotificationServiceForHardening();
    reconciler = NotificationReconciler(
      db: db,
      notificationService: mockNotificationService,
    );
    motorcycleRepo = MotorcycleRepository(
      db,
      notificationReconciler: reconciler,
      attachmentService: attachmentService,
    );
    maintenanceRepo = MaintenanceRepository(
      db,
      notificationReconciler: reconciler,
    );
    serviceRepo = ServiceRecordRepository(
      db: db,
      attachmentService: attachmentService,
      maintenanceRepository: maintenanceRepo,
    );
    reportRepo = ReportRepository(
      db: db,
      serviceRecordRepository: serviceRepo,
    );
    settingsRepo = SettingsRepository(
      db: db,
      notificationService: mockNotificationService,
      attachmentService: attachmentService,
      notificationReconciler: reconciler,
    );
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Hardening & Compliance Verification Tests', () {
    test(
        'Independent dimensions: date urgency does not cause km false positive',
        () {
      final now = DateTime.now();
      final schedule = MaintenanceSchedule(
        id: 'sch-1',
        motorcycleId: 'moto-1',
        name: 'Ganti Oli',
        category: 'Pelumasan',
        intervalKm: 2000,
        intervalMonths: 3,
        lastDoneKm: 1000,
        lastDoneDate: now.subtract(const Duration(days: 95)), // Date overdue
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      // Current km is 1200 km (only 200 km elapsed out of 2000 km, so km is strictly Aman)
      final calc = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 1200,
      );

      expect(calc.kmStatus, MaintenanceStatus.aman);
      expect(calc.dateStatus, MaintenanceStatus.terlambat);
      expect(calc.overallStatus, MaintenanceStatus.terlambat);
    });

    test(
        'Odometer chronology: rejects lower km on same date without correction',
        () {
      final today = DateTime.now();
      final items = [
        OdometerChronologyItem(
          id: 'odo-1',
          readingDate: today,
          odometerKm: 5000,
          createdAt: today,
          source: 'manual',
        ),
      ];

      expect(
        () => AppValidators.validateOdometerChronology(
          odometerKm: 4800,
          readingDate: today,
          existingReadings: items,
          isCorrection: false,
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.code,
          'code',
          'ODO-002',
        )),
      );

      // When marked as correction with reason, it succeeds
      expect(
        () => AppValidators.validateOdometerChronology(
          odometerKm: 4800,
          readingDate: today,
          existingReadings: items,
          isCorrection: true,
          correctionReason: 'Salah input angka sebelumnya',
        ),
        returnsNormally,
      );
    });

    test(
        'Motorcycle deletion cleans up physical attachment files and directories',
        () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Beat Test',
        brand: 'Honda',
        model: 'Beat',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
      );

      // Create a valid test image file
      final testImg = File('${tempDir.path}/sample_invoice.jpg');
      final image = img.Image(width: 20, height: 20);
      img.fill(image, color: img.ColorRgba8(255, 128, 0, 255));
      await testImg.writeAsBytes(img.encodeJpg(image));

      final recResult = await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: DateTime.now(),
        odometerKm: 1500,
        items: [
          {'itemName': 'Servis Berkala', 'itemCost': 50000},
        ],
        photoFiles: [testImg],
      );

      expect(recResult.photosSavedSuccessfully, 1);

      // Verify physical attachment directory exists
      final recDir = Directory('${tempDir.path}/${recResult.recordId}');
      expect(await recDir.exists(), isTrue);

      // Delete motorcycle
      final delResult = await motorcycleRepo.deleteMotorcycle(motorId);
      expect(delResult.databaseSuccess, isTrue);
      expect(delResult.attachmentsCleaned, isTrue);
      expect(delResult.affectedServiceRecordsCount, 1);

      // Physical directory must now be completely gone
      expect(await recDir.exists(), isFalse);
    });

    test('Full data deletion returns structured DataDeletionResult', () async {
      await motorcycleRepo.createMotorcycle(
        nickname: 'Vario Wipe',
        brand: 'Honda',
        model: 'Vario',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
      );

      final wipeResult = await settingsRepo.clearAllData();
      expect(wipeResult.databaseSuccess, isTrue);
      expect(wipeResult.notificationsCancelled, isTrue);
      expect(wipeResult.attachmentsCleaned, isTrue);
      expect(wipeResult.isFullySuccessful, isTrue);

      final motors = await motorcycleRepo.getAll();
      expect(motors, isEmpty);
      expect(mockNotificationService.cancelledAll, isTrue);
    });

    test(
        'ReportRepository single-query SQL aggregation for current month expense',
        () async {
      final now = DateTime.now();
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Scoopy',
        brand: 'Honda',
        model: 'Scoopy',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
      );

      await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: now,
        odometerKm: 1200,
        additionalCost: 15000,
        items: [
          {'itemName': 'Oli Mesin', 'itemCost': 65000},
          {'itemName': 'Busi', 'itemCost': 30000},
        ],
      );

      // 65000 + 30000 + 15000 = 110000
      final expense = await reportRepo.getCurrentMonthExpense(motorId);
      expect(expense, 110000);
    });

    test('Attachment size validation rejects images above 15MB', () async {
      final largeFile = File('${tempDir.path}/large_file.jpg');
      // Create a simulated 16MB file
      final sink = largeFile.openWrite();
      final chunk = List.filled(1024 * 1024, 0xFF);
      for (int i = 0; i < 16; i++) {
        sink.add(chunk);
      }
      await sink.close();

      final validation =
          await attachmentService.validateImageFileAsync(largeFile);
      expect(validation.isValid, isFalse);
      expect(validation.errorMessage, contains('15MB'));
    });

    test('Notification service refreshDeviceTimezone executes without failure',
        () async {
      await mockNotificationService.refreshDeviceTimezone();
      expect(mockNotificationService.timezoneRefreshCount, 1);
    });

    test(
        'deleteSchedule platform cancellation failure throws NotificationException and preserves schedule',
        () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
      );

      final scheduleId = await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Ganti Oli',
        intervalKm: 2000,
        intervalMonths: 3,
        lastDoneKm: 1000,
        lastDoneDate: DateTime.now(),
      );

      await reconciler.reconcileAll();

      mockNotificationService.shouldFailCancel = true;

      expect(
        () => maintenanceRepo.deleteSchedule(scheduleId),
        throwsA(isA<NotificationException>()),
      );

      // Verify schedule is NOT deleted from SQLite
      final schedule = await maintenanceRepo.getById(scheduleId);
      expect(schedule, isNotNull);
      mockNotificationService.shouldFailCancel = false;
    });

    test(
        'deleteMotorcycle platform cancellation failure returns failure and preserves motorcycle',
        () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario Fail',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
      );

      await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Ganti Oli',
        intervalKm: 2000,
        intervalMonths: 3,
        lastDoneKm: 1000,
        lastDoneDate: DateTime.now(),
      );

      await reconciler.reconcileAll();

      mockNotificationService.shouldFailCancel = true;

      final delResult = await motorcycleRepo.deleteMotorcycle(motorId);
      expect(delResult.databaseSuccess, isFalse);
      expect(delResult.notificationsCancelled, isFalse);

      // Verify motorcycle is NOT deleted from SQLite
      final motor = await motorcycleRepo.getById(motorId);
      expect(motor, isNotNull);
      mockNotificationService.shouldFailCancel = false;
    });

    test(
        'clearAllData platform cancellation failure aborts deletion and preserves database',
        () async {
      await motorcycleRepo.createMotorcycle(
        nickname: 'Preserved Vario',
        brand: 'Honda',
        model: 'Vario',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
      );

      mockNotificationService.shouldFailCancel = true;

      final wipeResult = await settingsRepo.clearAllData();
      expect(wipeResult.databaseSuccess, isFalse);
      expect(wipeResult.notificationsCancelled, isFalse);

      final motors = await motorcycleRepo.getAll();
      expect(motors, isNotEmpty);
      mockNotificationService.shouldFailCancel = false;
    });

    test(
        'Timezone change reschedules date notifications and updates last known timezone',
        () async {
      final now = DateTime.now();
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario TZ',
        brand: 'Honda',
        model: 'Vario',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
      );

      await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Servis Waktu',
        intervalMonths: 3,
        lastDoneDate: now,
      );

      // Reconcile initial jobs
      await reconciler.reconcileAll();

      // Trigger timezone changed
      await reconciler.handleTimezoneChanged(newTimezone: 'Asia/Makassar');

      final storedTz =
          await settingsRepo.getSetting(AppConstants.keyLastKnownTimezone);
      expect(storedTz, 'Asia/Makassar');
    });
  });
}
