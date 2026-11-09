import '../../../core/constants/app_constants.dart';
import '../../../core/services/attachment_storage_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../database/app_database.dart';
import '../../maintenance/application/notification_reconciler.dart';

enum NotificationToggleStatus {
  enabled,
  permissionDenied,
  disabled,
  cancelFailed,
}

class NotificationToggleResult {
  final NotificationToggleStatus status;
  final String? message;
  final bool hasPermission;

  const NotificationToggleResult({
    required this.status,
    this.message,
    this.hasPermission = false,
  });

  bool get isSuccess =>
      status == NotificationToggleStatus.enabled ||
      status == NotificationToggleStatus.disabled;
}

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
    await db
        .into(db.appSettings)
        .insertOnConflictUpdate(
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
      AppConstants.keyOnboardingCompleted,
      completed ? 'true' : 'false',
    );
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

  Future<NotificationToggleResult> setNotificationsEnabled(bool enabled) async {
    if (enabled) {
      // 1. Single owner checks and requests OS permission
      var granted = await notificationService.areNotificationsEnabled();
      if (!granted) {
        granted = await notificationService.requestPermission();
      }

      if (!granted) {
        // Permission was denied: do not set keyNotificationsEnabled to true
        await setSetting(AppConstants.keyNotificationsEnabled, 'false');
        return const NotificationToggleResult(
          status: NotificationToggleStatus.permissionDenied,
          hasPermission: false,
          message: 'Izin notifikasi tidak diberikan. Pengingat tetap dapat dilihat di aplikasi.',
        );
      }

      // Permission granted: save preference and reconcile
      await setSetting(AppConstants.keyNotificationsEnabled, 'true');
      if (notificationReconciler != null) {
        await notificationReconciler!.reconcileAll();
      }
      return const NotificationToggleResult(
        status: NotificationToggleStatus.enabled,
        hasPermission: true,
        message: 'Pengingat berhasil diaktifkan.',
      );
    } else {
      // 2. Disabling notifications
      await setSetting(AppConstants.keyNotificationsEnabled, 'false');
      NotificationCancelResult cancelRes;
      if (notificationReconciler != null) {
        cancelRes = await notificationReconciler!.onNotificationsDisabled();
      } else {
        cancelRes = await notificationService.cancelAllNotifications();
      }

      if (!cancelRes.isSuccess) {
        return NotificationToggleResult(
          status: NotificationToggleStatus.cancelFailed,
          hasPermission: true,
          message:
              'Sebagian pengingat di sistem Android gagal dibatalkan: ${cancelRes.errorMessage ?? 'Kesalahan platform'}.',
        );
      }

      return const NotificationToggleResult(
        status: NotificationToggleStatus.disabled,
        hasPermission: true,
        message: 'Pengingat dinonaktifkan.',
      );
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
        errorMessage: 'Gagal membatalkan pengingat di sistem Android. Penghapusan data dibatalkan demi keamanan.',
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
