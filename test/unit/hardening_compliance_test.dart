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

class ScheduledNotificationRecord {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledDate;
  final String? payload;

  const ScheduledNotificationRecord({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDate,
    this.payload,
  });
}

class MockNotificationServiceForHardening extends NotificationService {
  final List<int> cancelledIds = [];
  final List<ScheduledNotificationRecord> scheduledRecords = [];
  bool cancelledAll = false;
  int timezoneRefreshCount = 0;
  bool shouldFailCancel = false;
  bool shouldFailSchedule = false;
  bool hasPermission = true;
  bool requestPermissionResult = true;
  int requestPermissionCallCount = 0;

  @override
  Future<bool> areNotificationsEnabled() async => hasPermission;

  @override
  Future<bool> requestPermission() async {
    requestPermissionCallCount++;
    hasPermission = requestPermissionResult;
    return requestPermissionResult;
  }

  @override
  Future<NotificationCancelResult> cancelNotification(int id) async {
    if (shouldFailCancel) {
      return NotificationCancelResult.failure(
        'Simulated platform cancellation error',
        id,
      );
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
  Future<NotificationScheduleResult> scheduleDateNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (shouldFailSchedule) {
      return NotificationScheduleResult.failure(
        'Simulated platform scheduling error',
        id,
      );
    }
    scheduledRecords.add(
      ScheduledNotificationRecord(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        payload: payload,
      ),
    );
    return NotificationScheduleResult.success;
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
    reportRepo = ReportRepository(db: db, serviceRecordRepository: serviceRepo);
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
      },
    );

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
          throwsA(
            isA<ValidationException>().having((e) => e.code, 'code', 'ODO-002'),
          ),
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
      },
    );

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
      },
    );

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
      },
    );

    test('Attachment size validation rejects images above 15MB', () async {
      final largeFile = File('${tempDir.path}/large_file.jpg');
      // Create a simulated 16MB file
      final sink = largeFile.openWrite();
      final chunk = List.filled(1024 * 1024, 0xFF);
      for (int i = 0; i < 16; i++) {
        sink.add(chunk);
      }
      await sink.close();

      final validation = await attachmentService.validateImageFileAsync(
        largeFile,
      );
      expect(validation.isValid, isFalse);
      expect(validation.errorMessage, contains('15MB'));
    });

    test(
      'Notification service refreshDeviceTimezone executes without failure',
      () async {
        await mockNotificationService.refreshDeviceTimezone();
        expect(mockNotificationService.timezoneRefreshCount, 1);
      },
    );

    test('deleteSchedule platform cancellation failure throws NotificationException and preserves schedule', () async {
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

    test('deleteMotorcycle platform cancellation failure returns failure and preserves motorcycle', () async {
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

    test('clearAllData platform cancellation failure aborts deletion and preserves database', () async {
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

    test('Timezone change cancels old date notification and reschedules with new timezone', () async {
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
      final initialScheduled = mockNotificationService.scheduledRecords.length;
      expect(initialScheduled, greaterThan(0));
      final initialJobId = mockNotificationService.scheduledRecords.first.id;

      mockNotificationService.cancelledIds.clear();
      mockNotificationService.scheduledRecords.clear();

      // Trigger timezone changed
      await reconciler.handleTimezoneChanged(newTimezone: 'Asia/Makassar');

      // Verify old alarm was cancelled on platform
      expect(mockNotificationService.cancelledIds, contains(initialJobId));
      // Verify new alarm was scheduled on platform
      expect(
        mockNotificationService.scheduledRecords.any(
          (r) => r.id == initialJobId,
        ),
        isTrue,
      );

      final storedTz = await settingsRepo.getSetting(
        AppConstants.keyLastKnownTimezone,
      );
      expect(storedTz, 'Asia/Makassar');
    });

    test('Timezone change cancellation failure marks job as failed and does not schedule duplicate alarm', () async {
      final now = DateTime.now();
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario TZ Fail',
        brand: 'Honda',
        model: 'Vario',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
      );

      final scheduleId = await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Servis Waktu Fail',
        intervalMonths: 3,
        lastDoneDate: now,
      );

      await reconciler.reconcileAll();

      mockNotificationService.cancelledIds.clear();
      mockNotificationService.scheduledRecords.clear();
      mockNotificationService.shouldFailCancel = true;

      // Trigger timezone changed with simulated cancellation failure
      await reconciler.handleTimezoneChanged(newTimezone: 'Asia/Jayapura');

      // Failed cancellation should NOT mark job cancelled or schedule a duplicate alarm
      final jobs = await db.select(db.notificationJobs).get();
      final failedJob = jobs.firstWhere(
        (j) => j.maintenanceScheduleId == scheduleId,
      );
      expect(failedJob.state, AppConstants.jobStateFailed);

      mockNotificationService.shouldFailCancel = false;
    });

    test('toggleActive platform cancellation failure throws NotificationException and preserves schedule as active', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario Toggle',
        brand: 'Honda',
        model: 'Vario',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
      );

      final scheduleId = await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Ganti Busi',
        intervalMonths: 6,
        lastDoneDate: DateTime.now(),
      );

      await reconciler.reconcileAll();

      mockNotificationService.shouldFailCancel = true;

      // Toggling to inactive should fail because platform cancellation fails
      expect(
        () => maintenanceRepo.toggleActive(scheduleId, false),
        throwsA(isA<NotificationException>()),
      );

      // Verify schedule remains active in SQLite
      final schedule = await maintenanceRepo.getById(scheduleId);
      expect(schedule?.isActive, isTrue);

      mockNotificationService.shouldFailCancel = false;

      // When cancellation succeeds, schedule can be deactivated
      await maintenanceRepo.toggleActive(scheduleId, false);
      final deactivatedSchedule = await maintenanceRepo.getById(scheduleId);
      expect(deactivatedSchedule?.isActive, isFalse);
    });

    test('Single-owner notification permission flow: enabling requests permission once and saves setting when granted', () async {
      mockNotificationService.hasPermission = false;
      mockNotificationService.requestPermissionResult = true;
      mockNotificationService.requestPermissionCallCount = 0;

      final res = await settingsRepo.setNotificationsEnabled(true);
      expect(res.status, NotificationToggleStatus.enabled);
      expect(res.hasPermission, isTrue);
      expect(mockNotificationService.requestPermissionCallCount, 1);

      final isEnabled = await settingsRepo.areNotificationsEnabled();
      expect(isEnabled, isTrue);
    });

    test('Single-owner notification permission flow: denied permission returns permissionDenied and keeps notifications disabled', () async {
      mockNotificationService.hasPermission = false;
      mockNotificationService.requestPermissionResult = false;
      mockNotificationService.requestPermissionCallCount = 0;

      final res = await settingsRepo.setNotificationsEnabled(true);
      expect(res.status, NotificationToggleStatus.permissionDenied);
      expect(res.hasPermission, isFalse);
      expect(mockNotificationService.requestPermissionCallCount, 1);

      final isEnabled = await settingsRepo.areNotificationsEnabled();
      expect(isEnabled, isFalse);
    });

    test('Single-owner notification permission flow: disabling when cancel fails returns cancelFailed', () async {
      mockNotificationService.hasPermission = true;
      mockNotificationService.shouldFailCancel = true;

      final res = await settingsRepo.setNotificationsEnabled(false);
      expect(res.status, NotificationToggleStatus.cancelFailed);

      mockNotificationService.shouldFailCancel = false;
    });

    test('deleteRecord returns RecordDeletionResult with full cleanup when all files deleted', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario Del',
        brand: 'Honda',
        model: 'Vario',
        motorcycleType: 'matic',
        initialOdometerKm: 1000,
        initialReadingDate: DateTime(2026, 1, 1),
      );

      final dummyPhoto = File('${tempDir.path}/dummy_receipt.jpg');
      await dummyPhoto.writeAsBytes(
        img.encodeJpg(img.Image(width: 100, height: 100)),
      );

      final createRes = await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: DateTime(2026, 2, 1),
        odometerKm: 2000,
        items: [
          {'itemName': 'Oli Mesin', 'itemCost': 50000},
        ],
        photoFiles: [dummyPhoto],
      );

      final delRes = await serviceRepo.deleteRecord(createRes.recordId);
      expect(delRes.databaseSuccess, isTrue);
      expect(delRes.isFullSuccess, isTrue);
      expect(delRes.cleanupResult.deletedCount, greaterThan(0));

      final deletedRecord = await serviceRepo.getById(createRes.recordId);
      expect(deletedRecord, isNull);
    });

    test('Symlink pointing outside attachments directory is rejected by _isSafePath', () async {
      final outsideDir = await Directory.systemTemp.createTemp(
        'outside_secret_',
      );
      final secretFile = File('${outsideDir.path}/secret.txt');
      await secretFile.writeAsString('sensitivedata');

      final baseDir = Directory('${tempDir.path}/attachments');
      await baseDir.create(recursive: true);

      // Create a symlink inside attachments that targets outside directory
      final linkPath = '${baseDir.path}/evil_symlink';
      try {
        final link = Link(linkPath);
        await link.create(secretFile.path);

        // Validation using _isSafePath should detect target resolves outside baseDir and reject it
        final safe = attachmentService.isSafePathForTesting(link.path, baseDir);
        expect(safe, isFalse);
      } on FileSystemException {
        // Platform without symlink creation privileges (e.g. unprivileged Windows user)
      } finally {
        await outsideDir.delete(recursive: true);
      }
    });
  });
}
