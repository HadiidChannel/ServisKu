import '../../../core/constants/app_constants.dart';
import '../../../core/services/attachment_storage_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../database/app_database.dart';
import '../../maintenance/application/notification_reconciler.dart';

class DataDeletionResult {
  final bool databaseSuccess;
  final bool notificationsCancelled;
  final bool attachmentsCleaned;
  final String? errorMessage;

  const DataDeletionResult({
    required this.databaseSuccess,
    required this.notificationsCancelled,
    required this.attachmentsCleaned,
    this.errorMessage,
  });

  bool get isFullySuccessful =>
      databaseSuccess && notificationsCancelled && attachmentsCleaned;
}

class SettingsRepository {
  final AppDatabase db;
  final NotificationService notificationService;
  final AttachmentStorageService attachmentService;
  final NotificationReconciler? notificationReconciler;

  SettingsRepository({
    required this.db,
    required this.notificationService,
    required this.attachmentService,
    this.notificationReconciler,
  });

  Future<String?> getSetting(String key) async {
    final query = db.select(db.appSettings)
      ..where((tbl) => tbl.key.equals(key));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    final nowIso = DateTime.now().toIso8601String();
    await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: nowIso,
          ),
        );
  }

  Future<bool> isOnboardingCompleted() async {
    final val = await getSetting(AppConstants.keyOnboardingCompleted);
    return val == 'true';
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await setSetting(
        AppConstants.keyOnboardingCompleted, completed ? 'true' : 'false');
  }

  Future<String?> getActiveMotorcycleId() async {
    return await getSetting(AppConstants.keyActiveMotorcycleId);
  }

  Future<void> setActiveMotorcycleId(String id) async {
    await setSetting(AppConstants.keyActiveMotorcycleId, id);
  }

  Future<bool> areNotificationsEnabled() async {
    final val = await getSetting(AppConstants.keyNotificationsEnabled);
    if (val == null) return true; // Default true as per FSD
    return val == 'true';
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await setSetting(
        AppConstants.keyNotificationsEnabled, enabled ? 'true' : 'false');
    if (!enabled) {
      if (notificationReconciler != null) {
        await notificationReconciler!.onNotificationsDisabled();
      } else {
        await notificationService.cancelAllNotifications();
      }
    } else {
      if (notificationReconciler != null) {
        await notificationReconciler!.reconcileAll();
      }
    }
  }

  Future<DataDeletionResult> clearAllData() async {
    // 1. Cancel all notifications and verify platform result
    bool notifsCancelled = false;
    try {
      final cancelResult = await notificationService.cancelAllNotifications();
      notifsCancelled = cancelResult.isSuccess;
    } catch (_) {
      notifsCancelled = false;
    }

    if (!notifsCancelled) {
      return const DataDeletionResult(
        databaseSuccess: false,
        notificationsCancelled: false,
        attachmentsCleaned: false,
        errorMessage:
            'Gagal membatalkan pengingat di sistem Android. Penghapusan data dibatalkan demi keamanan.',
      );
    }

    // 2. Commit database deletion safely in a transaction
    bool dbSuccess = false;
    try {
      await db.transaction(() async {
        await db.delete(db.notificationJobs).go();
        await db.delete(db.serviceAttachments).go();
        await db.delete(db.serviceRecordItems).go();
        await db.delete(db.serviceRecords).go();
        await db.delete(db.maintenanceSchedules).go();
        await db.delete(db.odometerReadings).go();
        await db.delete(db.motorcycles).go();
        await db.delete(db.appSettings).go();
      });
      dbSuccess = true;
    } catch (e) {
      return DataDeletionResult(
        databaseSuccess: false,
        notificationsCancelled: notifsCancelled,
        attachmentsCleaned: false,
        errorMessage: 'Gagal menghapus database: $e',
      );
    }

    // 3. Clear physical attachments only after database commit succeeded
    bool attachmentsCleaned = false;
    try {
      final cleanupResult = await attachmentService.cleanupAllAttachments();
      attachmentsCleaned = cleanupResult.isComplete;
    } catch (_) {
      attachmentsCleaned = false;
    }

    return DataDeletionResult(
      databaseSuccess: dbSuccess,
      notificationsCancelled: notifsCancelled,
      attachmentsCleaned: attachmentsCleaned,
    );
  }
}
