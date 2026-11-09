import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/services/notification_service.dart';
import '../../../database/app_database.dart';
import '../../motorcycles/domain/motorcycle.dart';
import '../domain/maintenance_calculator.dart';
import '../domain/maintenance_schedule.dart';

class NotificationReconciler {
  final AppDatabase db;
  final NotificationService notificationService;
  final _uuid = const Uuid();

  NotificationReconciler({
    required this.db,
    required this.notificationService,
  });

  Future<void> reconcileAll({bool forceRescheduleDateJobs = false}) async {
    try {
      final enabledSetting = await (db.select(db.appSettings)
            ..where(
                (tbl) => tbl.key.equals(AppConstants.keyNotificationsEnabled)))
          .getSingleOrNull();

      final isNotificationsEnabled = enabledSetting?.value != 'false';
      if (!isNotificationsEnabled) return;

      final hasDevicePermission =
          await notificationService.areNotificationsEnabled();
      if (!hasDevicePermission) return;

      final motorcycles = await db.select(db.motorcycles).get();
      for (final mRow in motorcycles) {
        final currentKm = await _getLatestOdometerKm(mRow.id);
        final lastUpdate = await _getLatestOdometerDate(mRow.id);
        final motorcycle = Motorcycle(
          id: mRow.id,
          nickname: mRow.nickname,
          brand: mRow.brand,
          model: mRow.model,
          motorcycleType: mRow.motorcycleType,
          propulsionType: mRow.propulsionType,
          manufactureYear: mRow.manufactureYear,
          licensePlate: mRow.licensePlate,
          notes: mRow.notes,
          createdAt: DateTime.parse(mRow.createdAt),
          updatedAt: DateTime.parse(mRow.updatedAt),
          currentOdometerKm: currentKm,
          lastOdometerUpdate: lastUpdate,
        );

        final scheduleRows = await (db.select(db.maintenanceSchedules)
              ..where((tbl) => tbl.motorcycleId.equals(mRow.id)))
            .get();
        final schedules = scheduleRows.map(_scheduleToDomain).toList();

        await reconcileForMotorcycle(
          motorcycle: motorcycle,
          schedules: schedules,
          forceRescheduleDateJobs: forceRescheduleDateJobs,
        );
      }
    } catch (_) {
      // Reconcile must not throw to break the app
    }
  }

  Future<void> reconcileForMotorcycle({
    required Motorcycle motorcycle,
    required List<MaintenanceSchedule> schedules,
    bool forceRescheduleDateJobs = false,
  }) async {
    try {
      // Check if notifications are enabled in settings
      final enabledSetting = await (db.select(db.appSettings)
            ..where(
                (tbl) => tbl.key.equals(AppConstants.keyNotificationsEnabled)))
          .getSingleOrNull();

      final isNotificationsEnabled = enabledSetting?.value != 'false';
      if (!isNotificationsEnabled) return;

      final hasDevicePermission =
          await notificationService.areNotificationsEnabled();
      if (!hasDevicePermission) return;

      for (final schedule in schedules) {
        if (!schedule.isActive) {
          await cancelJobsForSchedule(schedule.id);
          continue;
        }

        final result = MaintenanceCalculator.calculate(
          schedule: schedule,
          currentOdometerKm: motorcycle.currentOdometerKm,
        );

        final cycleKey = MaintenanceCalculator.generateCycleKey(schedule);

        // Cancel any obsolete jobs for this schedule from a previous cycle
        final obsoleteJobs = await (db.select(db.notificationJobs)
              ..where((tbl) =>
                  tbl.maintenanceScheduleId.equals(schedule.id) &
                  tbl.cycleKey.isNotValue(cycleKey)))
            .get();

        for (final oldJob in obsoleteJobs) {
          final res = await notificationService
              .cancelNotification(oldJob.platformNotificationId);
          if (res.isSuccess) {
            await (db.delete(db.notificationJobs)
                  ..where((tbl) => tbl.id.equals(oldJob.id)))
                .go();
          } else {
            await (db.update(db.notificationJobs)
                  ..where((tbl) => tbl.id.equals(oldJob.id)))
                .write(
              NotificationJobsCompanion(
                state: const Value(AppConstants.jobStateFailed),
                updatedAt: Value(DateTime.now().toIso8601String()),
              ),
            );
          }
        }

        // 1. Date-based reminder
        if (schedule.intervalMonths != null &&
            schedule.intervalMonths! > 0 &&
            result.dueDate != null &&
            schedule.lastDoneDate != null) {
          final existingJob = await (db.select(db.notificationJobs)
                ..where((tbl) =>
                    tbl.maintenanceScheduleId.equals(schedule.id) &
                    tbl.cycleKey.equals(cycleKey) &
                    tbl.triggerType.equals(AppConstants.triggerDateDue)))
              .getSingleOrNull();

          // FSD 8.4: default reminderLeadDays is 0 (due date itself)
          final leadDays = schedule.reminderLeadDays ?? 0;
          final reminderDate =
              result.dueDate!.subtract(Duration(days: leadDays));
          final reminderDateIso = reminderDate.toIso8601String();
          final notifId = NotificationService.generateNotificationId(
            schedule.id,
            AppConstants.triggerDateDue,
          );

          bool needsSchedule = false;

          if (existingJob == null) {
            needsSchedule = true;
          } else if (existingJob.state == AppConstants.jobStateFailed ||
              existingJob.state == AppConstants.jobStateCancelled) {
            needsSchedule = true;
          } else if (existingJob.state == AppConstants.jobStateScheduled) {
            if (forceRescheduleDateJobs ||
                existingJob.plannedAt != reminderDateIso) {
              // Configuration or timezone changed, cancel obsolete platform notification
              await notificationService
                  .cancelNotification(existingJob.platformNotificationId);
              needsSchedule = true;
            }
          } else if (existingJob.state == AppConstants.jobStateDelivered) {
            // If reminder date changed to a future date, schedule the new date
            if (existingJob.plannedAt != reminderDateIso &&
                reminderDate.isAfter(DateTime.now())) {
              needsSchedule = true;
            }
          }

          if (needsSchedule) {
            final scheduleResult =
                await notificationService.scheduleDateNotification(
              id: notifId,
              title: 'Pengingat: ${schedule.name}',
              body:
                  '${motorcycle.nickname} mendekati batas waktu servis (${result.dateReason ?? result.reason}).',
              scheduledDate: reminderDate,
            );

            final String state;
            if (scheduleResult.isDeliveredImmediate) {
              state = AppConstants.jobStateDelivered;
            } else if (scheduleResult.isScheduled) {
              state = AppConstants.jobStateScheduled;
            } else {
              state = AppConstants.jobStateFailed;
            }

            final nowIso = DateTime.now().toIso8601String();
            if (existingJob != null) {
              await (db.update(db.notificationJobs)
                    ..where((tbl) => tbl.id.equals(existingJob.id)))
                  .write(
                NotificationJobsCompanion(
                  state: Value(state),
                  plannedAt: Value(reminderDateIso),
                  updatedAt: Value(nowIso),
                ),
              );
            } else {
              await db.into(db.notificationJobs).insert(
                    NotificationJobsCompanion.insert(
                      id: _uuid.v4(),
                      maintenanceScheduleId: schedule.id,
                      cycleKey: cycleKey,
                      triggerType: AppConstants.triggerDateDue,
                      platformNotificationId: notifId,
                      plannedAt: Value(reminderDateIso),
                      state: state,
                      createdAt: nowIso,
                      updatedAt: nowIso,
                    ),
                  );
            }
          }
        }

        // 2. KM-based reminder (strictly evaluated on kmStatus, never on date or combined status)
        if (schedule.intervalKm != null &&
            schedule.intervalKm! > 0 &&
            result.kmStatus != null &&
            result.remainingKm != null &&
            schedule.lastDoneKm != null) {
          if (result.kmStatus == MaintenanceStatus.segera) {
            final existingJob = await (db.select(db.notificationJobs)
                  ..where((tbl) =>
                      tbl.maintenanceScheduleId.equals(schedule.id) &
                      tbl.cycleKey.equals(cycleKey) &
                      tbl.triggerType.equals(AppConstants.triggerKmSoon)))
                .getSingleOrNull();

            if (existingJob == null ||
                existingJob.state == AppConstants.jobStateFailed ||
                existingJob.state == AppConstants.jobStateCancelled) {
              final notifId = NotificationService.generateNotificationId(
                schedule.id,
                AppConstants.triggerKmSoon,
              );

              final delivered =
                  await notificationService.showImmediateNotification(
                id: notifId,
                title: 'Perawatan Segera: ${schedule.name}',
                body:
                    '${motorcycle.nickname} mendekati jadwal perawatan (${result.kmReason ?? result.reason}).',
              );

              final state = delivered
                  ? AppConstants.jobStateDelivered
                  : AppConstants.jobStateFailed;

              final nowIso = DateTime.now().toIso8601String();
              if (existingJob != null) {
                await (db.update(db.notificationJobs)
                      ..where((tbl) => tbl.id.equals(existingJob.id)))
                    .write(
                  NotificationJobsCompanion(
                    state: Value(state),
                    plannedAt: Value(nowIso),
                    updatedAt: Value(nowIso),
                  ),
                );
              } else {
                await db.into(db.notificationJobs).insert(
                      NotificationJobsCompanion.insert(
                        id: _uuid.v4(),
                        maintenanceScheduleId: schedule.id,
                        cycleKey: cycleKey,
                        triggerType: AppConstants.triggerKmSoon,
                        platformNotificationId: notifId,
                        plannedAt: Value(nowIso),
                        state: state,
                        createdAt: nowIso,
                        updatedAt: nowIso,
                      ),
                    );
              }
            }
          } else if (result.kmStatus == MaintenanceStatus.terlambat) {
            final existingJob = await (db.select(db.notificationJobs)
                  ..where((tbl) =>
                      tbl.maintenanceScheduleId.equals(schedule.id) &
                      tbl.cycleKey.equals(cycleKey) &
                      tbl.triggerType.equals(AppConstants.triggerKmOverdue)))
                .getSingleOrNull();

            if (existingJob == null ||
                existingJob.state == AppConstants.jobStateFailed ||
                existingJob.state == AppConstants.jobStateCancelled) {
              final notifId = NotificationService.generateNotificationId(
                schedule.id,
                AppConstants.triggerKmOverdue,
              );

              final delivered =
                  await notificationService.showImmediateNotification(
                id: notifId,
                title: 'Perawatan Jatuh Tempo: ${schedule.name}',
                body:
                    '${motorcycle.nickname} telah mencapai batas perawatan (${result.kmReason ?? result.reason}).',
              );

              final state = delivered
                  ? AppConstants.jobStateDelivered
                  : AppConstants.jobStateFailed;

              final nowIso = DateTime.now().toIso8601String();
              if (existingJob != null) {
                await (db.update(db.notificationJobs)
                      ..where((tbl) => tbl.id.equals(existingJob.id)))
                    .write(
                  NotificationJobsCompanion(
                    state: Value(state),
                    plannedAt: Value(nowIso),
                    updatedAt: Value(nowIso),
                  ),
                );
              } else {
                await db.into(db.notificationJobs).insert(
                      NotificationJobsCompanion.insert(
                        id: _uuid.v4(),
                        maintenanceScheduleId: schedule.id,
                        cycleKey: cycleKey,
                        triggerType: AppConstants.triggerKmOverdue,
                        platformNotificationId: notifId,
                        plannedAt: Value(nowIso),
                        state: state,
                        createdAt: nowIso,
                        updatedAt: nowIso,
                      ),
                    );
              }
            }
          }
        }
      }
    } catch (_) {
      // Notification errors must not propagate to caller
    }
  }

  Future<NotificationCancelResult> cancelJobsForSchedule(
      String scheduleId) async {
    try {
      final jobs = await (db.select(db.notificationJobs)
            ..where((tbl) => tbl.maintenanceScheduleId.equals(scheduleId)))
          .get();

      NotificationCancelResult? firstFailure;

      for (final job in jobs) {
        final res = await notificationService
            .cancelNotification(job.platformNotificationId);
        if (res.isSuccess) {
          await (db.delete(db.notificationJobs)
                ..where((tbl) => tbl.id.equals(job.id)))
              .go();
        } else {
          firstFailure ??= res;
          await (db.update(db.notificationJobs)
                ..where((tbl) => tbl.id.equals(job.id)))
              .write(
            NotificationJobsCompanion(
              state: const Value(AppConstants.jobStateFailed),
              updatedAt: Value(DateTime.now().toIso8601String()),
            ),
          );
        }
      }

      if (firstFailure != null) {
        return firstFailure;
      }
      return NotificationCancelResult.success;
    } catch (e) {
      return NotificationCancelResult.failure(e.toString());
    }
  }

  Future<NotificationCancelResult> cancelJobsForMotorcycle(
      String motorcycleId) async {
    try {
      final scheduleRows = await (db.select(db.maintenanceSchedules)
            ..where((tbl) => tbl.motorcycleId.equals(motorcycleId)))
          .get();
      for (final s in scheduleRows) {
        final res = await cancelJobsForSchedule(s.id);
        if (!res.isSuccess) {
          return res;
        }
      }
      return NotificationCancelResult.success;
    } catch (e) {
      return NotificationCancelResult.failure(e.toString());
    }
  }

  Future<NotificationCancelResult> onNotificationsDisabled() async {
    try {
      final res = await notificationService.cancelAllNotifications();
      final targetState = res.isSuccess
          ? AppConstants.jobStateCancelled
          : AppConstants.jobStateFailed;

      await (db.update(db.notificationJobs)
            ..where((tbl) => tbl.state.equals(AppConstants.jobStateScheduled)))
          .write(
        NotificationJobsCompanion(
          state: Value(targetState),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
      return res;
    } catch (e) {
      return NotificationCancelResult.failure(e.toString());
    }
  }

  Future<void> onNotificationsEnabled() async {
    try {
      await notificationService.requestPermission();
      await reconcileAll();
    } catch (_) {
      // Ignore
    }
  }

  Future<void> handleTimezoneChanged({required String newTimezone}) async {
    try {
      // 1. Cancel all currently scheduled date jobs
      final scheduledDateJobs = await (db.select(db.notificationJobs)
            ..where((tbl) =>
                tbl.triggerType.equals(AppConstants.triggerDateDue) &
                tbl.state.equals(AppConstants.jobStateScheduled)))
          .get();

      for (final job in scheduledDateJobs) {
        await notificationService.cancelNotification(job.platformNotificationId);
        await (db.update(db.notificationJobs)
              ..where((tbl) => tbl.id.equals(job.id)))
            .write(
          NotificationJobsCompanion(
            state: const Value(AppConstants.jobStateCancelled),
            updatedAt: Value(DateTime.now().toIso8601String()),
          ),
        );
      }

      // 2. Persist new timezone in settings
      await db.into(db.appSettings).insertOnConflictUpdate(
            AppSettingsCompanion.insert(
              key: AppConstants.keyLastKnownTimezone,
              value: newTimezone,
              updatedAt: DateTime.now().toIso8601String(),
            ),
          );

      // 3. Force reschedule all date-based jobs with new timezone
      await reconcileAll(forceRescheduleDateJobs: true);
    } catch (_) {}
  }

  Future<int> _getLatestOdometerKm(String motorcycleId) async {
    final query = db.select(db.odometerReadings)
      ..where((tbl) => tbl.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.readingDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ])
      ..limit(1);

    final reading = await query.getSingleOrNull();
    return reading?.odometerKm ?? 0;
  }

  Future<DateTime?> _getLatestOdometerDate(String motorcycleId) async {
    final query = db.select(db.odometerReadings)
      ..where((tbl) => tbl.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.readingDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ])
      ..limit(1);

    final reading = await query.getSingleOrNull();
    return reading != null
        ? AppFormatters.parseDateBusiness(reading.readingDate)
        : null;
  }

  MaintenanceSchedule _scheduleToDomain(MaintenanceScheduleRow row) {
    return MaintenanceSchedule(
      id: row.id,
      motorcycleId: row.motorcycleId,
      name: row.name,
      category: row.category,
      intervalKm: row.intervalKm,
      intervalMonths: row.intervalMonths,
      lastDoneKm: row.lastDoneKm,
      lastDoneDate: row.lastDoneDate != null
          ? AppFormatters.parseDateBusiness(row.lastDoneDate!)
          : null,
      manualLastDoneKm: row.manualLastDoneKm,
      manualLastDoneDate: row.manualLastDoneDate != null
          ? AppFormatters.parseDateBusiness(row.manualLastDoneDate!)
          : null,
      reminderLeadKm: row.reminderLeadKm,
      reminderLeadDays: row.reminderLeadDays,
      isActive: row.isActive,
      createdAt: DateTime.parse(row.createdAt),
      updatedAt: DateTime.parse(row.updatedAt),
    );
  }
}
