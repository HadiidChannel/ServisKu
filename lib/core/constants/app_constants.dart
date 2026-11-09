// App Constants for ServisKu
// Note: Never use en-dash or em-dash characters anywhere in text or comments.

class AppConstants {
  static const String appName = 'ServisKu';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Kelola Perawatan Sepeda Motor Pribadi';

  // Settings keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyActiveMotorcycleId = 'active_motorcycle_id';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLastKnownTimezone = 'last_known_timezone';

  // Motorcycle Types
  static const String typeMatic = 'matic';
  static const String typeBebek = 'bebek';
  static const String typeSport = 'sport';

  // Propulsion Types
  static const String propulsionGasoline = 'gasoline';
  static const String propulsionElectric = 'electric';

  // Odometer Sources
  static const String odoSourceManual = 'manual';
  static const String odoSourceService = 'service';
  static const String odoSourceInitial = 'initial';
  static const String odoSourceCorrection = 'correction';

  // Maintenance Status Labels
  static const String statusAman = 'Aman';
  static const String statusSegera = 'Segera';
  static const String statusTerlambat = 'Terlambat';
  static const String statusBelumDiatur = 'Belum diatur';

  // Notification Trigger Types
  static const String triggerDateDue = 'date_due';
  static const String triggerKmSoon = 'km_soon';
  static const String triggerKmOverdue = 'km_overdue';

  // Notification Job States
  static const String jobStateScheduled = 'scheduled';
  static const String jobStateDelivered = 'delivered';
  static const String jobStateCancelled = 'cancelled';
  static const String jobStateFailed = 'failed';

  // Default reminder configuration
  static const int defaultReminderLeadKm = 500;
  static const int defaultReminderLeadDays = 7;
  static const int defaultNotificationHour = 9;
  static const int defaultNotificationMinute = 0;

  // Additional cost category label in reports
  static const String categoryAdditionalCost = 'Biaya tambahan';
}
