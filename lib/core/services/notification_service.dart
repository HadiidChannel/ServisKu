import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/app_constants.dart';

enum NotificationScheduleStatus { scheduled, deliveredImmediate, failed }

class NotificationScheduleResult {
  final NotificationScheduleStatus status;
  final String? errorMessage;

  const NotificationScheduleResult({required this.status, this.errorMessage});

  bool get isSuccess => status != NotificationScheduleStatus.failed;
  bool get isDeliveredImmediate =>
      status == NotificationScheduleStatus.deliveredImmediate;
  bool get isScheduled => status == NotificationScheduleStatus.scheduled;

  static const success = NotificationScheduleResult(
    status: NotificationScheduleStatus.scheduled,
  );

  static NotificationScheduleResult failure(String message, [int? id]) =>
      NotificationScheduleResult(
        status: NotificationScheduleStatus.failed,
        errorMessage: message,
      );
}

class NotificationCancelResult {
  final bool isSuccess;
  final String? errorMessage;
  final int? failedId;

  const NotificationCancelResult({
    required this.isSuccess,
    this.errorMessage,
    this.failedId,
  });

  static const success = NotificationCancelResult(isSuccess: true);

  static NotificationCancelResult failure(String message, [int? id]) =>
      NotificationCancelResult(
        isSuccess: false,
        errorMessage: message,
        failedId: id,
      );
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String channelId = 'servisku_maintenance_reminders';
  static const String channelName = 'Pengingat Perawatan ServisKu';
  static const String channelDescription =
      'Pemberitahuan pengingat jadwal perawatan sepeda motor';

  Future<void> configureLocalTimezone([String? explicitZone]) async {
    tz.initializeTimeZones();
    if (explicitZone != null && explicitZone.isNotEmpty) {
      try {
        tz.setLocalLocation(tz.getLocation(explicitZone));
        return;
      } catch (_) {}
    }

    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    } catch (_) {
      // Safe fallback based on current device UTC offset
      final offsetHours = DateTime.now().timeZoneOffset.inHours;
      String fallbackZone = 'Asia/Jakarta'; // WIB (UTC+7)
      if (offsetHours == 8) {
        fallbackZone = 'Asia/Makassar'; // WITA (UTC+8)
      } else if (offsetHours == 9) {
        fallbackZone = 'Asia/Jayapura'; // WIT (UTC+9)
      }
      try {
        tz.setLocalLocation(tz.getLocation(fallbackZone));
      } catch (_) {
        // Keep tz.local fallback
      }
    }
  }

  Future<void> initialize() async {
    if (_initialized) return;

    await configureLocalTimezone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
    );

    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final granted = await androidImplementation
        ?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<bool> areNotificationsEnabled() async {
    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final enabled = await androidImplementation?.areNotificationsEnabled();
    return enabled ?? false;
  }

  /// Deterministic 31-bit FNV-1a hash algorithm to ensure notification IDs
  /// remain strictly stable across application restarts and device reboots.
  static int generateNotificationId(String scheduleId, String triggerType) {
    final input = '$scheduleId:$triggerType';
    var hash = 0x811c9dc5;
    for (var i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash & 0x7FFFFFFF;
  }

  Future<bool> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _plugin.show(id, title, body, notificationDetails);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<NotificationScheduleResult> scheduleDateNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      final now = DateTime.now();
      final targetDateTime = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        AppConstants.defaultNotificationHour,
        AppConstants.defaultNotificationMinute,
      );

      // If scheduled time has already passed or is today, trigger immediate notification
      if (targetDateTime.isBefore(now)) {
        final shown = await showImmediateNotification(
          id: id,
          title: title,
          body: body,
        );
        return NotificationScheduleResult(
          status: shown
              ? NotificationScheduleStatus.deliveredImmediate
              : NotificationScheduleStatus.failed,
          errorMessage: shown ? null : 'Gagal menampilkan notifikasi langsung.',
        );
      }

      final scheduledTZ = tz.TZDateTime.from(targetDateTime, tz.local);

      const androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTZ,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return const NotificationScheduleResult(
        status: NotificationScheduleStatus.scheduled,
      );
    } catch (e) {
      return NotificationScheduleResult(
        status: NotificationScheduleStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshDeviceTimezone() async {
    await configureLocalTimezone();
  }

  Future<String> getCurrentTimezone() async {
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      return timezoneInfo.identifier;
    } catch (_) {
      return tz.local.name;
    }
  }

  Future<NotificationCancelResult> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id);
      return NotificationCancelResult.success;
    } catch (e) {
      return NotificationCancelResult(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NotificationCancelResult> cancelAllNotifications() async {
    try {
      await _plugin.cancelAll();
      return NotificationCancelResult.success;
    } catch (e) {
      return NotificationCancelResult(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
}
