import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/attachment_storage_service.dart';
import '../../core/services/notification_service.dart';
import '../../database/app_database.dart';
import '../../features/maintenance/application/notification_reconciler.dart';
import '../../features/maintenance/data/maintenance_repository.dart';
import '../../features/maintenance/domain/maintenance_calculator.dart';
import '../../features/maintenance/domain/maintenance_schedule.dart';
import '../../features/motorcycles/data/motorcycle_repository.dart';
import '../../features/motorcycles/domain/motorcycle.dart';
import '../../features/odometer/data/odometer_repository.dart';
import '../../features/reports/data/report_repository.dart';
import '../../features/reports/domain/expense_summary.dart';
import '../../features/service_records/data/service_record_repository.dart';
import '../../features/service_records/domain/service_record.dart';
import '../../features/settings/data/settings_repository.dart';

// Single Database Instance
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Services
final attachmentStorageServiceProvider =
    Provider<AttachmentStorageService>((ref) {
  return AttachmentStorageService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationReconcilerProvider = Provider<NotificationReconciler>((ref) {
  return NotificationReconciler(
    db: ref.watch(databaseProvider),
    notificationService: ref.watch(notificationServiceProvider),
  );
});

// Repositories
final motorcycleRepositoryProvider = Provider<MotorcycleRepository>((ref) {
  return MotorcycleRepository(
    ref.watch(databaseProvider),
    notificationReconciler: ref.watch(notificationReconcilerProvider),
    attachmentService: ref.watch(attachmentStorageServiceProvider),
  );
});

final odometerRepositoryProvider = Provider<OdometerRepository>((ref) {
  return OdometerRepository(
    ref.watch(databaseProvider),
    notificationReconciler: ref.watch(notificationReconcilerProvider),
  );
});

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  return MaintenanceRepository(
    ref.watch(databaseProvider),
    notificationReconciler: ref.watch(notificationReconcilerProvider),
  );
});

final serviceRecordRepositoryProvider =
    Provider<ServiceRecordRepository>((ref) {
  return ServiceRecordRepository(
    db: ref.watch(databaseProvider),
    attachmentService: ref.watch(attachmentStorageServiceProvider),
    maintenanceRepository: ref.watch(maintenanceRepositoryProvider),
    notificationReconciler: ref.watch(notificationReconcilerProvider),
  );
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(
    db: ref.watch(databaseProvider),
    serviceRecordRepository: ref.watch(serviceRecordRepositoryProvider),
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    db: ref.watch(databaseProvider),
    notificationService: ref.watch(notificationServiceProvider),
    attachmentService: ref.watch(attachmentStorageServiceProvider),
    notificationReconciler: ref.watch(notificationReconcilerProvider),
  );
});

// Motorcycles Stream
final motorcyclesStreamProvider = StreamProvider<List<Motorcycle>>((ref) {
  return ref.watch(motorcycleRepositoryProvider).watchAll();
});

// Active Motorcycle ID State Notifier
class ActiveMotorcycleIdNotifier extends StateNotifier<String?> {
  final SettingsRepository _settingsRepo;

  ActiveMotorcycleIdNotifier(this._settingsRepo) : super(null) {
    _load();
  }

  Future<void> _load() async {
    final id = await _settingsRepo.getActiveMotorcycleId();
    state = id;
  }

  Future<void> setActiveId(String id) async {
    state = id;
    await _settingsRepo.setActiveMotorcycleId(id);
  }
}

final activeMotorcycleIdProvider =
    StateNotifierProvider<ActiveMotorcycleIdNotifier, String?>((ref) {
  return ActiveMotorcycleIdNotifier(ref.watch(settingsRepositoryProvider));
});

// Active Motorcycle Provider
final activeMotorcycleProvider = Provider<Motorcycle?>((ref) {
  final motorcyclesAsync = ref.watch(motorcyclesStreamProvider);
  final activeId = ref.watch(activeMotorcycleIdProvider);

  return motorcyclesAsync.when(
    data: (list) {
      if (list.isEmpty) return null;
      if (activeId != null) {
        final match = list.where((m) => m.id == activeId).toList();
        if (match.isNotEmpty) return match.first;
      }
      return list.first;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Maintenance Schedules Stream by motorcycleId
final motorcycleSchedulesProvider =
    StreamProvider.family<List<MaintenanceSchedule>, String>(
        (ref, motorcycleId) {
  return ref.watch(maintenanceRepositoryProvider).watchSchedules(motorcycleId);
});

// Service Records Stream by motorcycleId
final motorcycleServiceRecordsProvider =
    StreamProvider.family<List<ServiceRecord>, String?>((ref, motorcycleId) {
  return ref
      .watch(serviceRecordRepositoryProvider)
      .watchRecords(motorcycleId: motorcycleId);
});

// Current Month Expense for Active Motorcycle - reactively observes service records
final activeMotorcycleMonthExpenseProvider = StreamProvider<int>((ref) {
  final activeMotorcycle = ref.watch(activeMotorcycleProvider);
  if (activeMotorcycle == null) return Stream.value(0);
  return ref
      .watch(reportRepositoryProvider)
      .watchCurrentMonthExpense(activeMotorcycle.id);
});

class ReportFilterParams {
  final String? motorcycleId;
  final ReportPeriod period;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  const ReportFilterParams({
    this.motorcycleId,
    required this.period,
    this.customStartDate,
    this.customEndDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportFilterParams &&
          runtimeType == other.runtimeType &&
          motorcycleId == other.motorcycleId &&
          period == other.period &&
          customStartDate == other.customStartDate &&
          customEndDate == other.customEndDate;

  @override
  int get hashCode =>
      motorcycleId.hashCode ^
      period.hashCode ^
      customStartDate.hashCode ^
      customEndDate.hashCode;
}

final expenseReportStreamProvider =
    StreamProvider.family<ExpenseReportSummary, ReportFilterParams>(
        (ref, params) {
  return ref.watch(reportRepositoryProvider).watchReportSummary(
        motorcycleId: params.motorcycleId,
        period: params.period,
        customStartDate: params.customStartDate,
        customEndDate: params.customEndDate,
      );
});

// Dashboard Schedule Priority Item
class DashboardScheduleItem {
  final MaintenanceSchedule schedule;
  final MaintenanceCalculationResult calculation;

  const DashboardScheduleItem({
    required this.schedule,
    required this.calculation,
  });
}

// Dashboard Aggregated Summary
class DashboardSummary {
  final Motorcycle? activeMotorcycle;
  final bool isLoading;
  final bool hasSchedulesError;
  final bool hasRecordsError;
  final bool hasExpenseError;
  final String? errorMessage;
  final int overdueCount;
  final int soonCount;
  final int safeCount;
  final List<DashboardScheduleItem> prioritySchedules;
  final ServiceRecord? latestService;
  final int currentMonthExpense;

  const DashboardSummary({
    this.activeMotorcycle,
    this.isLoading = false,
    this.hasSchedulesError = false,
    this.hasRecordsError = false,
    this.hasExpenseError = false,
    this.errorMessage,
    this.overdueCount = 0,
    this.soonCount = 0,
    this.safeCount = 0,
    this.prioritySchedules = const [],
    this.latestService,
    this.currentMonthExpense = 0,
  });
}

// Deterministic unit-aware priority sorting policy without fabricating daily distance assumptions:
// 1. Status priority first: Terlambat > Segera > Aman > Belum diatur
// 2. Within the same status, sort by unclamped cycle progress descending (higher relative lateness / progress = more urgent)
// 3. Deterministic tie-break by schedule name
int compareScheduleUrgency(DashboardScheduleItem a, DashboardScheduleItem b) {
  final pA = a.calculation.status.priority;
  final pB = b.calculation.status.priority;
  if (pA != pB) return pA.compareTo(pB);

  // Unclamped progress preserves true relative overdue severity
  final progressCompare =
      b.calculation.unclampedProgress.compareTo(a.calculation.unclampedProgress);
  if (progressCompare != 0) return progressCompare;

  // Deterministic tie-break
  return a.schedule.name.compareTo(b.schedule.name);
}

final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final activeMotorcycle = ref.watch(activeMotorcycleProvider);
  if (activeMotorcycle == null) {
    return const DashboardSummary();
  }

  final schedulesAsync =
      ref.watch(motorcycleSchedulesProvider(activeMotorcycle.id));
  final recordsAsync =
      ref.watch(motorcycleServiceRecordsProvider(activeMotorcycle.id));
  final monthExpenseAsync = ref.watch(activeMotorcycleMonthExpenseProvider);

  final isInitialLoading =
      (schedulesAsync.isLoading && !schedulesAsync.hasValue) ||
          (recordsAsync.isLoading && !recordsAsync.hasValue);

  final hasSchedulesError = schedulesAsync.hasError;
  final hasRecordsError = recordsAsync.hasError;
  final hasExpenseError = monthExpenseAsync.hasError;

  final schedules = schedulesAsync.value ?? [];
  final records = recordsAsync.value ?? [];
  final monthExpense = monthExpenseAsync.value ?? 0;

  int overdue = 0;
  int soon = 0;
  int safe = 0;
  final calculatedItems = <DashboardScheduleItem>[];

  for (final schedule in schedules) {
    if (!schedule.isActive) continue;

    final result = MaintenanceCalculator.calculate(
      schedule: schedule,
      currentOdometerKm: activeMotorcycle.currentOdometerKm,
    );

    if (result.status == MaintenanceStatus.terlambat) {
      overdue++;
    } else if (result.status == MaintenanceStatus.segera) {
      soon++;
    } else if (result.status == MaintenanceStatus.aman) {
      safe++;
    }

    calculatedItems.add(DashboardScheduleItem(
      schedule: schedule,
      calculation: result,
    ));
  }

  // Strict deterministic sorting
  calculatedItems.sort(compareScheduleUrgency);

  // Maximum 3 priority schedules as per PRD & FSD
  final top3 = calculatedItems.take(3).toList();
  final latestRec = records.isNotEmpty ? records.first : null;

  return DashboardSummary(
    activeMotorcycle: activeMotorcycle,
    isLoading: isInitialLoading,
    hasSchedulesError: hasSchedulesError,
    hasRecordsError: hasRecordsError,
    hasExpenseError: hasExpenseError,
    overdueCount: overdue,
    soonCount: soon,
    safeCount: safe,
    prioritySchedules: top3,
    latestService: latestRec,
    currentMonthExpense: monthExpense,
  );
});
