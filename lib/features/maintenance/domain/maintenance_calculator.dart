import '../../../core/extensions/date_extensions.dart';
import '../../../core/formatters/app_formatters.dart';
import 'maintenance_schedule.dart';

class MaintenanceCalculationResult {
  final MaintenanceStatus overallStatus;
  final MaintenanceStatus? kmStatus;
  final MaintenanceStatus? dateStatus;
  final int? dueKm;
  final int? remainingKm;
  final DateTime? dueDate;
  final int? remainingDays;
  final String reason;
  final String? kmReason;
  final String? dateReason;
  final double progress; // 0.0 to 1.0 (clamped for UI progress bars)
  final double unclampedProgress; // Unclamped ratio for accurate urgency ordering

  const MaintenanceCalculationResult({
    required this.overallStatus,
    this.kmStatus,
    this.dateStatus,
    this.dueKm,
    this.remainingKm,
    this.dueDate,
    this.remainingDays,
    required this.reason,
    this.kmReason,
    this.dateReason,
    this.progress = 0.0,
    this.unclampedProgress = 0.0,
  });

  // Backward compatibility getters
  MaintenanceStatus get status => overallStatus;
  int? get kmDue => dueKm;
  DateTime? get dateDue => dueDate;
}

class MaintenanceCalculator {
  static MaintenanceCalculationResult calculate({
    required MaintenanceSchedule schedule,
    required int currentOdometerKm,
    DateTime? today,
  }) {
    final now = (today ?? DateTime.now()).toDateOnly();

    final hasKm = schedule.intervalKm != null && schedule.intervalKm! > 0;
    final hasMonths =
        schedule.intervalMonths != null && schedule.intervalMonths! > 0;

    int? dueKm;
    int? remainingKm;
    MaintenanceStatus? kmStatus;
    double kmProgress = 0.0;
    double rawKmProgress = 0.0;
    bool kmBaselineMissing = false;
    String? kmReason;

    if (hasKm) {
      if (schedule.lastDoneKm != null) {
        dueKm = schedule.lastDoneKm! + schedule.intervalKm!;
        remainingKm = dueKm - currentOdometerKm;
        final leadKm = schedule.reminderLeadKm ?? 0;

        final elapsedKm = currentOdometerKm - schedule.lastDoneKm!;
        rawKmProgress = elapsedKm / schedule.intervalKm!;
        kmProgress = rawKmProgress.clamp(0.0, 1.0);

        if (currentOdometerKm >= dueKm) {
          kmStatus = MaintenanceStatus.terlambat;
          final overdueKm = remainingKm.abs();
          kmReason = 'Terlambat ${AppFormatters.formatNumber(overdueKm)} km';
        } else if (remainingKm <= leadKm) {
          kmStatus = MaintenanceStatus.segera;
          kmReason = 'Sisa ${AppFormatters.formatNumber(remainingKm)} km';
        } else {
          kmStatus = MaintenanceStatus.aman;
          kmReason = 'Sisa ${AppFormatters.formatNumber(remainingKm)} km';
        }
      } else {
        kmBaselineMissing = true;
        kmStatus = MaintenanceStatus.belumDiatur;
        kmReason = 'Kilometer terakhir belum diisi';
      }
    }

    DateTime? dueDate;
    int? remainingDays;
    MaintenanceStatus? dateStatus;
    double dateProgress = 0.0;
    double rawDateProgress = 0.0;
    bool dateBaselineMissing = false;
    String? dateReason;

    if (hasMonths) {
      if (schedule.lastDoneDate != null) {
        dueDate = schedule.lastDoneDate!
            .addMonthsClamped(schedule.intervalMonths!)
            .toDateOnly();
        remainingDays = dueDate.difference(now).inDays;
        final leadDays = schedule.reminderLeadDays ?? 0;
        final reminderDate =
            dueDate.subtract(Duration(days: leadDays)).toDateOnly();

        final totalCycleDays =
            dueDate.difference(schedule.lastDoneDate!.toDateOnly()).inDays;
        final elapsedDays =
            now.difference(schedule.lastDoneDate!.toDateOnly()).inDays;
        if (totalCycleDays > 0) {
          rawDateProgress = elapsedDays / totalCycleDays;
          dateProgress = rawDateProgress.clamp(0.0, 1.0);
        }

        if (now.isSameOrAfterDay(dueDate)) {
          dateStatus = MaintenanceStatus.terlambat;
          final overdueDays = remainingDays.abs();
          dateReason = 'Terlambat $overdueDays hari';
        } else if (now.isSameOrAfterDay(reminderDate)) {
          dateStatus = MaintenanceStatus.segera;
          dateReason = 'Sisa $remainingDays hari';
        } else {
          dateStatus = MaintenanceStatus.aman;
          dateReason = 'Sisa $remainingDays hari';
        }
      } else {
        dateBaselineMissing = true;
        dateStatus = MaintenanceStatus.belumDiatur;
        dateReason = 'Tanggal terakhir belum diisi';
      }
    }

    // Determine combined status:
    // 1. Any calculable overdue -> Terlambat
    // 2. Incomplete baseline (and not overdue) -> Belum diatur
    // 3. Any calculable soon -> Segera
    // 4. Aman
    MaintenanceStatus finalStatus;
    final reasons = <String>[];

    final isAnyOverdue = kmStatus == MaintenanceStatus.terlambat ||
        dateStatus == MaintenanceStatus.terlambat;

    if (isAnyOverdue) {
      finalStatus = MaintenanceStatus.terlambat;
      if (kmStatus == MaintenanceStatus.terlambat && kmReason != null) {
        reasons.add(kmReason);
      }
      if (dateStatus == MaintenanceStatus.terlambat && dateReason != null) {
        reasons.add(dateReason);
      }
    } else if (kmBaselineMissing || dateBaselineMissing) {
      finalStatus = MaintenanceStatus.belumDiatur;
      if (kmBaselineMissing && dateBaselineMissing) {
        reasons.add('Kilometer dan tanggal terakhir belum diisi');
      } else if (kmBaselineMissing) {
        reasons.add('Kilometer terakhir belum diisi');
      } else {
        reasons.add('Tanggal terakhir belum diisi');
      }
    } else if (kmStatus == MaintenanceStatus.segera ||
        dateStatus == MaintenanceStatus.segera) {
      finalStatus = MaintenanceStatus.segera;
      if (kmStatus == MaintenanceStatus.segera && kmReason != null) {
        reasons.add(kmReason);
      }
      if (dateStatus == MaintenanceStatus.segera && dateReason != null) {
        reasons.add(dateReason);
      }
    } else {
      finalStatus = MaintenanceStatus.aman;
      if (remainingKm != null && remainingDays != null) {
        reasons.add(
            'Sisa ${AppFormatters.formatNumber(remainingKm)} km atau $remainingDays hari');
      } else if (remainingKm != null) {
        reasons.add('Sisa ${AppFormatters.formatNumber(remainingKm)} km');
      } else if (remainingDays != null) {
        reasons.add('Sisa $remainingDays hari');
      } else {
        reasons.add('Kondisi prima');
      }
    }

    final overallProgress =
        (kmProgress > dateProgress ? kmProgress : dateProgress);

    double overallUnclamped = 0.0;
    if (hasKm &&
        hasMonths &&
        schedule.lastDoneKm != null &&
        schedule.lastDoneDate != null) {
      overallUnclamped =
          rawKmProgress > rawDateProgress ? rawKmProgress : rawDateProgress;
    } else if (hasKm && schedule.lastDoneKm != null) {
      overallUnclamped = rawKmProgress;
    } else if (hasMonths && schedule.lastDoneDate != null) {
      overallUnclamped = rawDateProgress;
    }

    return MaintenanceCalculationResult(
      overallStatus: finalStatus,
      kmStatus: kmStatus,
      dateStatus: dateStatus,
      dueKm: dueKm,
      remainingKm: remainingKm,
      dueDate: dueDate,
      remainingDays: remainingDays,
      reason: reasons.join(' / '),
      kmReason: kmReason,
      dateReason: dateReason,
      progress: overallProgress,
      unclampedProgress: overallUnclamped,
    );
  }

  static String generateCycleKey(MaintenanceSchedule schedule) {
    final lastKm = schedule.lastDoneKm?.toString() ?? 'none';
    final lastDate = schedule.lastDoneDate != null
        ? AppFormatters.formatDateBusiness(schedule.lastDoneDate!)
        : 'none';
    final intKm = schedule.intervalKm?.toString() ?? '0';
    final intM = schedule.intervalMonths?.toString() ?? '0';
    return '${schedule.id}_${lastKm}_${lastDate}_${intKm}_$intM';
  }
}
