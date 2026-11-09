import 'package:drift/drift.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../database/app_database.dart';
import '../../service_records/data/service_record_repository.dart';
import '../../service_records/domain/service_record.dart';
import '../../service_records/domain/service_record_item.dart';
import '../domain/expense_summary.dart';

class ReportRepository {
  final AppDatabase db;
  final ServiceRecordRepository serviceRecordRepository;

  ReportRepository({required this.db, required this.serviceRecordRepository});

  Future<int> getCurrentMonthExpense(String motorcycleId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final startStr = AppFormatters.formatDateBusiness(startOfMonth);
    final endStr = AppFormatters.formatDateBusiness(endOfMonth);

    final rows = await db
        .customSelect(
          'SELECT sr.id, sr.additional_cost, '
          'COALESCE((SELECT SUM(sri.item_cost) FROM service_record_items sri WHERE sri.service_record_id = sr.id), 0) AS items_cost '
          'FROM service_records sr '
          'WHERE sr.motorcycle_id = ? AND sr.service_date >= ? AND sr.service_date <= ?;',
          variables: [
            Variable.withString(motorcycleId),
            Variable.withString(startStr),
            Variable.withString(endStr),
          ],
          readsFrom: {db.serviceRecords, db.serviceRecordItems},
        )
        .get();

    int total = 0;
    for (final row in rows) {
      final additional = row.read<int>('additional_cost');
      final itemsCost = row.read<int>('items_cost');
      total += additional + itemsCost;
    }
    return total;
  }

  Stream<int> watchCurrentMonthExpense(String motorcycleId) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final startStr = AppFormatters.formatDateBusiness(startOfMonth);
    final endStr = AppFormatters.formatDateBusiness(endOfMonth);

    return db
        .customSelect(
          'SELECT sr.id, sr.additional_cost, '
          'COALESCE((SELECT SUM(sri.item_cost) FROM service_record_items sri WHERE sri.service_record_id = sr.id), 0) AS items_cost '
          'FROM service_records sr '
          'WHERE sr.motorcycle_id = ? AND sr.service_date >= ? AND sr.service_date <= ?;',
          variables: [
            Variable.withString(motorcycleId),
            Variable.withString(startStr),
            Variable.withString(endStr),
          ],
          readsFrom: {db.serviceRecords, db.serviceRecordItems},
        )
        .watch()
        .map((rows) {
          int total = 0;
          for (final row in rows) {
            final additional = row.read<int>('additional_cost');
            final itemsCost = row.read<int>('items_cost');
            total += additional + itemsCost;
          }
          return total;
        });
  }

  (DateTime, DateTime) _resolveDateRange({
    required ReportPeriod period,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (period) {
      case ReportPeriod.thisMonth:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case ReportPeriod.lastThreeMonths:
        startDate = DateTime(now.year, now.month - 2, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case ReportPeriod.thisYear:
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;
      case ReportPeriod.custom:
        startDate = customStartDate ?? DateTime(now.year, now.month, 1);
        endDate = customEndDate ?? now;
        break;
    }
    return (startDate, endDate);
  }

  Stream<ExpenseReportSummary> watchReportSummary({
    String? motorcycleId,
    required ReportPeriod period,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    final range = _resolveDateRange(
      period: period,
      customStartDate: customStartDate,
      customEndDate: customEndDate,
    );
    final startDate = range.$1;
    final endDate = range.$2;
    final startStr = AppFormatters.formatDateBusiness(startDate);
    final endStr = AppFormatters.formatDateBusiness(endDate);

    final query = db.select(db.serviceRecords)
      ..where((tbl) {
        Expression<bool> predicate =
            tbl.serviceDate.isBiggerOrEqualValue(startStr) &
            tbl.serviceDate.isSmallerOrEqualValue(endStr);
        if (motorcycleId != null) {
          predicate = predicate & tbl.motorcycleId.equals(motorcycleId);
        }
        return predicate;
      })
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.serviceDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ]);

    return query.watch().asyncMap((recordRows) async {
      return _buildSummaryFromRows(
        recordRows: recordRows,
        startDate: startDate,
        endDate: endDate,
      );
    });
  }

  Future<ExpenseReportSummary> getReportSummary({
    String? motorcycleId,
    required ReportPeriod period,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) async {
    final range = _resolveDateRange(
      period: period,
      customStartDate: customStartDate,
      customEndDate: customEndDate,
    );
    final startDate = range.$1;
    final endDate = range.$2;
    final startStr = AppFormatters.formatDateBusiness(startDate);
    final endStr = AppFormatters.formatDateBusiness(endDate);

    final query = db.select(db.serviceRecords)
      ..where((tbl) {
        Expression<bool> predicate =
            tbl.serviceDate.isBiggerOrEqualValue(startStr) &
            tbl.serviceDate.isSmallerOrEqualValue(endStr);
        if (motorcycleId != null) {
          predicate = predicate & tbl.motorcycleId.equals(motorcycleId);
        }
        return predicate;
      })
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.serviceDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ]);

    final recordRows = await query.get();
    return _buildSummaryFromRows(
      recordRows: recordRows,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<ExpenseReportSummary> _buildSummaryFromRows({
    required List<ServiceRecordRow> recordRows,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final itemsByRecord = <String, List<ServiceRecordItem>>{};
    if (recordRows.isNotEmpty) {
      final recordIds = recordRows.map((r) => r.id).toList();
      final itemRows = await (db.select(
        db.serviceRecordItems,
      )..where((tbl) => tbl.serviceRecordId.isIn(recordIds))).get();

      for (final itemRow in itemRows) {
        itemsByRecord
            .putIfAbsent(itemRow.serviceRecordId, () => [])
            .add(
              ServiceRecordItem(
                id: itemRow.id,
                serviceRecordId: itemRow.serviceRecordId,
                maintenanceScheduleId: itemRow.maintenanceScheduleId,
                itemName: itemRow.itemName,
                category: itemRow.category,
                itemCost: itemRow.itemCost,
                notes: itemRow.notes,
              ),
            );
      }
    }

    final mappedRecords = recordRows.map((r) {
      return ServiceRecord(
        id: r.id,
        motorcycleId: r.motorcycleId,
        serviceDate: AppFormatters.parseDateBusiness(r.serviceDate),
        odometerKm: r.odometerKm,
        workshopName: r.workshopName,
        additionalCost: r.additionalCost,
        notes: r.notes,
        createdAt: DateTime.parse(r.createdAt),
        updatedAt: DateTime.parse(r.updatedAt),
        items: itemsByRecord[r.id] ?? const [],
        attachments: const [],
      );
    }).toList();

    int totalCost = 0;
    int totalAdditionalCost = 0;
    final categoryTotals = <String, int>{};
    final monthlyTotals = <String, int>{};

    for (final r in mappedRecords) {
      totalCost += r.totalCost;
      totalAdditionalCost += r.additionalCost;

      final year = r.serviceDate.year;
      final month = r.serviceDate.month;
      final monthKey = '$year-${month.toString().padLeft(2, '0')}';
      monthlyTotals[monthKey] = (monthlyTotals[monthKey] ?? 0) + r.totalCost;

      for (final item in r.items) {
        final cat = (item.category != null && item.category!.trim().isNotEmpty)
            ? item.category!.trim()
            : 'Lainnya';
        categoryTotals[cat] = (categoryTotals[cat] ?? 0) + item.itemCost;
      }
    }

    if (totalAdditionalCost > 0) {
      categoryTotals[AppConstants.categoryAdditionalCost] =
          (categoryTotals[AppConstants.categoryAdditionalCost] ?? 0) +
          totalAdditionalCost;
    }

    final monthlyExpensesList = <MonthlyExpense>[];
    DateTime cur = DateTime(startDate.year, startDate.month, 1);
    final endMonthDate = DateTime(endDate.year, endDate.month, 1);

    while (!cur.isAfter(endMonthDate)) {
      final monthKey = '${cur.year}-${cur.month.toString().padLeft(2, '0')}';
      final cost = monthlyTotals[monthKey] ?? 0;
      monthlyExpensesList.add(
        MonthlyExpense(year: cur.year, month: cur.month, totalCost: cost),
      );
      if (cur.month == 12) {
        cur = DateTime(cur.year + 1, 1, 1);
      } else {
        cur = DateTime(cur.year, cur.month + 1, 1);
      }
    }

    final categoryList = <CategoryExpense>[];
    if (totalCost > 0) {
      categoryTotals.forEach((cat, cost) {
        if (cost > 0) {
          final pct = (cost / totalCost) * 100.0;
          categoryList.add(
            CategoryExpense(category: cat, totalCost: cost, percentage: pct),
          );
        }
      });
      categoryList.sort((a, b) => b.totalCost.compareTo(a.totalCost));
    }

    return ExpenseReportSummary(
      totalCost: totalCost,
      serviceCount: mappedRecords.length,
      monthlyExpenses: monthlyExpensesList,
      categoryBreakdown: categoryList,
      records: mappedRecords,
    );
  }
}
