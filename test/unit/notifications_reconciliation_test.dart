import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/core/constants/app_constants.dart';
import 'package:servis/core/services/notification_service.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/maintenance/application/notification_reconciler.dart';
import 'package:servis/features/maintenance/data/maintenance_repository.dart';
import 'package:servis/features/maintenance/domain/maintenance_schedule.dart';
import 'package:servis/features/motorcycles/data/motorcycle_repository.dart';
import 'package:servis/features/settings/data/settings_repository.dart';
import 'package:servis/core/services/attachment_storage_service.dart';

class MockNotificationService extends NotificationService {
  final List<int> scheduledNotifIds = [];
  final List<int> immediateNotifIds = [];
  final List<int> cancelledNotifIds = [];
  bool failNextSchedule = false;
  bool notificationsEnabled = true;

  @override
  Future<bool> areNotificationsEnabled() async => notificationsEnabled;

  @override
  Future<bool> requestPermission() async => notificationsEnabled;

  @override
  Future<NotificationScheduleResult> scheduleDateNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (failNextSchedule) {
      return const NotificationScheduleResult(
        status: NotificationScheduleStatus.failed,
        errorMessage: 'Simulated failure',
      );
    }
    if (scheduledDate.isBefore(DateTime.now())) {
      immediateNotifIds.add(id);
      return const NotificationScheduleResult(
        status: NotificationScheduleStatus.deliveredImmediate,
      );
    }
    scheduledNotifIds.add(id);
    return const NotificationScheduleResult(
      status: NotificationScheduleStatus.scheduled,
    );
  }

  @override
  Future<bool> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (failNextSchedule) return false;
    immediateNotifIds.add(id);
    return true;
  }

  @override
  Future<NotificationCancelResult> cancelNotification(int id) async {
    cancelledNotifIds.add(id);
    return NotificationCancelResult.success;
  }

  @override
  Future<NotificationCancelResult> cancelAllNotifications() async {
    cancelledNotifIds.add(-1); // Sentinel for all
    return NotificationCancelResult.success;
  }
}

void main() {
  late AppDatabase db;
  late MockNotificationService mockNotif;
  late NotificationReconciler reconciler;
  late MotorcycleRepository motorcycleRepo;
  late MaintenanceRepository maintenanceRepo;
  late SettingsRepository settingsRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    mockNotif = MockNotificationService();
    reconciler = NotificationReconciler(db: db, notificationService: mockNotif);
    motorcycleRepo = MotorcycleRepository(
      db,
      notificationReconciler: reconciler,
    );
    maintenanceRepo = MaintenanceRepository(
      db,
      notificationReconciler: reconciler,
    );
    settingsRepo = SettingsRepository(
      db: db,
      notificationService: mockNotif,
      attachmentService: AttachmentStorageService(),
      notificationReconciler: reconciler,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Deterministic Notification ID Tests', () {
    test('generateNotificationId produces stable deterministic positive 31-bit integer', () {
      final id1 = NotificationService.generateNotificationId(
        'sched-123',
        'date_due',
      );
      final id2 = NotificationService.generateNotificationId(
        'sched-123',
        'date_due',
      );
      final id3 = NotificationService.generateNotificationId(
        'sched-123',
        'km_soon',
      );
      final id4 = NotificationService.generateNotificationId(
        'sched-456',
        'date_due',
      );

      expect(id1, equals(id2));
      expect(id1, isNot(equals(id3)));
      expect(id1, isNot(equals(id4)));
      expect(id1, isNonNegative);
      expect(id1, lessThanOrEqualTo(0x7FFFFFFF));
    });
  });

  group('Notification Reconciliation & Scheduling Tests', () {
    test('Schedules future date reminder and creates notification_jobs record with scheduled state', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      final schedId = await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Ganti Oli',
        intervalMonths: 3,
        lastDoneDate: DateTime.now(),
        reminderLeadDays: 7,
      );

      final motor = (await motorcycleRepo.getById(motorId))!;
      final schedules = await maintenanceRepo.getSchedules(motorId);

      await reconciler.reconcileForMotorcycle(
        motorcycle: motor,
        schedules: schedules,
      );

      final jobs = await db.select(db.notificationJobs).get();
      expect(jobs.length, 1);
      expect(jobs.first.state, AppConstants.jobStateScheduled);
      expect(jobs.first.maintenanceScheduleId, schedId);
      expect(mockNotif.scheduledNotifIds, isNotEmpty);
    });

    test(
      'Prevents duplicate notification jobs on repeated reconciliation calls',
      () async {
        final motorId = await motorcycleRepo.createMotorcycle(
          nickname: 'Vario',
          brand: 'Honda',
          model: 'Vario 160',
          motorcycleType: AppConstants.typeMatic,
          initialOdometerKm: 1000,
        );

        await maintenanceRepo.createSchedule(
          motorcycleId: motorId,
          name: 'Busi',
          intervalMonths: 6,
          lastDoneDate: DateTime.now(),
        );

        final motor = (await motorcycleRepo.getById(motorId))!;
        final schedules = await maintenanceRepo.getSchedules(motorId);

        // Reconcile twice
        await reconciler.reconcileForMotorcycle(
          motorcycle: motor,
          schedules: schedules,
        );
        await reconciler.reconcileForMotorcycle(
          motorcycle: motor,
          schedules: schedules,
        );

        final jobs = await db.select(db.notificationJobs).get();
        expect(jobs.length, 1);
      },
    );

    test('Records failed state when platform scheduling fails without throwing error', () async {
      mockNotif.failNextSchedule = true;

      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Oli Mesin',
        intervalMonths: 3,
        lastDoneDate: DateTime.now(),
      );

      final motor = (await motorcycleRepo.getById(motorId))!;
      final schedules = await maintenanceRepo.getSchedules(motorId);

      // Must complete without unhandled exception
      await reconciler.reconcileForMotorcycle(
        motorcycle: motor,
        schedules: schedules,
      );

      final jobs = await db.select(db.notificationJobs).get();
      expect(jobs.length, 1);
      expect(jobs.first.state, AppConstants.jobStateFailed);
    });

    test('Deleting maintenance schedule cancels platform notifications and deletes jobs', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      final schedId = await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Filter Udara',
        intervalMonths: 6,
        lastDoneDate: DateTime.now(),
      );

      final motor = (await motorcycleRepo.getById(motorId))!;
      final schedules = await maintenanceRepo.getSchedules(motorId);
      await reconciler.reconcileForMotorcycle(
        motorcycle: motor,
        schedules: schedules,
      );

      expect(mockNotif.scheduledNotifIds, isNotEmpty);

      // Delete schedule
      await maintenanceRepo.deleteSchedule(schedId);

      expect(mockNotif.cancelledNotifIds, isNotEmpty);
      final remainingJobs = await db.select(db.notificationJobs).get();
      expect(remainingJobs, isEmpty);
    });

    test(
      'Deleting motorcycle cancels notifications for all its schedules',
      () async {
        final motorId = await motorcycleRepo.createMotorcycle(
          nickname: 'Vario',
          brand: 'Honda',
          model: 'Vario 160',
          motorcycleType: AppConstants.typeMatic,
          initialOdometerKm: 1000,
        );

        await maintenanceRepo.createSchedule(
          motorcycleId: motorId,
          name: 'Oli Gardan',
          intervalMonths: 12,
          lastDoneDate: DateTime.now(),
        );

        final motor = (await motorcycleRepo.getById(motorId))!;
        final schedules = await maintenanceRepo.getSchedules(motorId);
        await reconciler.reconcileForMotorcycle(
          motorcycle: motor,
          schedules: schedules,
        );

        await motorcycleRepo.deleteMotorcycle(motorId);

        expect(mockNotif.cancelledNotifIds, isNotEmpty);
      },
    );

    test('Disabling notifications cancels platform notifications and marks jobs cancelled', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Radiator Coolant',
        intervalMonths: 12,
        lastDoneDate: DateTime.now(),
      );

      final motor = (await motorcycleRepo.getById(motorId))!;
      final schedules = await maintenanceRepo.getSchedules(motorId);
      await reconciler.reconcileForMotorcycle(
        motorcycle: motor,
        schedules: schedules,
      );

      // Disable notifications
      await settingsRepo.setNotificationsEnabled(false);

      expect(mockNotif.cancelledNotifIds.contains(-1), isTrue);
      final jobs = await db.select(db.notificationJobs).get();
      expect(jobs.first.state, AppConstants.jobStateCancelled);
    });

    test(
      'Re-enabling notifications restores cancelled jobs and reschedules them',
      () async {
        final motorId = await motorcycleRepo.createMotorcycle(
          nickname: 'Vario',
          brand: 'Honda',
          model: 'Vario 160',
          motorcycleType: AppConstants.typeMatic,
          initialOdometerKm: 1000,
        );

        await maintenanceRepo.createSchedule(
          motorcycleId: motorId,
          name: 'Radiator Coolant',
          intervalMonths: 6,
          lastDoneDate: DateTime.now(),
          reminderLeadDays: 7,
        );

        final motor = (await motorcycleRepo.getById(motorId))!;
        final schedules = await maintenanceRepo.getSchedules(motorId);
        await reconciler.reconcileForMotorcycle(
          motorcycle: motor,
          schedules: schedules,
        );

        // Disable notifications
        await settingsRepo.setNotificationsEnabled(false);
        var jobs = await db.select(db.notificationJobs).get();
        expect(jobs.first.state, AppConstants.jobStateCancelled);

        mockNotif.scheduledNotifIds.clear();

        // Re-enable notifications
        await settingsRepo.setNotificationsEnabled(true);
        jobs = await db.select(db.notificationJobs).get();
        expect(jobs.length, equals(1));
        expect(jobs.first.state, AppConstants.jobStateScheduled);
        expect(mockNotif.scheduledNotifIds, isNotEmpty);
      },
    );

    test('Repeated toggling of notifications keeps state consistent without duplicates', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Busi',
        intervalMonths: 6,
        lastDoneDate: DateTime.now(),
        reminderLeadDays: 3,
      );

      final motor = (await motorcycleRepo.getById(motorId))!;
      final schedules = await maintenanceRepo.getSchedules(motorId);
      await reconciler.reconcileForMotorcycle(
        motorcycle: motor,
        schedules: schedules,
      );

      // Toggle multiple times: false -> true -> false -> true
      await settingsRepo.setNotificationsEnabled(false);
      await settingsRepo.setNotificationsEnabled(true);
      await settingsRepo.setNotificationsEnabled(false);
      await settingsRepo.setNotificationsEnabled(true);

      final jobs = await db.select(db.notificationJobs).get();
      expect(jobs.length, equals(1));
      expect(jobs.first.state, AppConstants.jobStateScheduled);
    });

    test('Updating reminderLeadDays cancels old notification and reschedules with new date', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      final schedId = await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Oli Mesin',
        intervalMonths: 3,
        lastDoneDate: DateTime.now(),
        reminderLeadDays: 7,
      );

      var motor = (await motorcycleRepo.getById(motorId))!;
      var schedules = await maintenanceRepo.getSchedules(motorId);
      await reconciler.reconcileForMotorcycle(
        motorcycle: motor,
        schedules: schedules,
      );

      var jobs = await db.select(db.notificationJobs).get();
      final initialPlannedAt = jobs.first.plannedAt;
      final oldNotifId = jobs.first.platformNotificationId;

      mockNotif.cancelledNotifIds.clear();
      mockNotif.scheduledNotifIds.clear();

      // Update schedule with reminderLeadDays: 3
      final existingSchedule = (await maintenanceRepo.getById(schedId))!;
      final updatedSchedule = MaintenanceSchedule(
        id: existingSchedule.id,
        motorcycleId: existingSchedule.motorcycleId,
        name: existingSchedule.name,
        category: existingSchedule.category,
        intervalKm: existingSchedule.intervalKm,
        intervalMonths: existingSchedule.intervalMonths,
        lastDoneKm: existingSchedule.lastDoneKm,
        lastDoneDate: existingSchedule.lastDoneDate,
        manualLastDoneKm: existingSchedule.manualLastDoneKm,
        manualLastDoneDate: existingSchedule.manualLastDoneDate,
        reminderLeadKm: existingSchedule.reminderLeadKm,
        reminderLeadDays: 3,
        isActive: existingSchedule.isActive,
        createdAt: existingSchedule.createdAt,
        updatedAt: DateTime.now(),
      );
      await maintenanceRepo.updateSchedule(updatedSchedule);

      motor = (await motorcycleRepo.getById(motorId))!;
      schedules = await maintenanceRepo.getSchedules(motorId);
      await reconciler.reconcileForMotorcycle(
        motorcycle: motor,
        schedules: schedules,
      );

      jobs = await db.select(db.notificationJobs).get();
      expect(jobs.length, equals(1));
      expect(jobs.first.plannedAt, isNot(equals(initialPlannedAt)));
      expect(mockNotif.cancelledNotifIds.contains(oldNotifId), isTrue);
      expect(mockNotif.scheduledNotifIds.contains(oldNotifId), isTrue);
    });

    test('Due date in the past marks notification job state as delivered instead of scheduled', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      // Last done 4 months ago with interval 3 months (already overdue)
      await maintenanceRepo.createSchedule(
        motorcycleId: motorId,
        name: 'Oli Mesin Lampau',
        intervalMonths: 3,
        lastDoneDate: DateTime.now().subtract(const Duration(days: 120)),
        reminderLeadDays: 0,
      );

      final motor = (await motorcycleRepo.getById(motorId))!;
      final schedules = await maintenanceRepo.getSchedules(motorId);
      await reconciler.reconcileForMotorcycle(
        motorcycle: motor,
        schedules: schedules,
      );

      final jobs = await db.select(db.notificationJobs).get();
      expect(jobs.length, equals(1));
      expect(jobs.first.state, equals(AppConstants.jobStateDelivered));
    });
  });
}
