import '../../service_records/domain/service_record.dart';

enum ReportPeriod {
  thisMonth,
  lastThreeMonths,
  thisYear,
  custom;

  String get label {
    switch (this) {
      case ReportPeriod.thisMonth:
        return 'Bulan Ini';
      case ReportPeriod.lastThreeMonths:
        return '3 Bulan Terakhir';
      case ReportPeriod.thisYear:
        return 'Tahun Ini';
      case ReportPeriod.custom:
        return 'Rentang Kustom';
    }
  }
}

class MonthlyExpense {
  final int year;
  final int month;
  final int totalCost;

  const MonthlyExpense({
    required this.year,
    required this.month,
    required this.totalCost,
  });

  String get monthName {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return month.toString();
  }

  String get label => '$monthName ${year.toString().substring(2)}';
}

class CategoryExpense {
  final String category;
  final int totalCost;
  final double percentage;

  const CategoryExpense({
    required this.category,
    required this.totalCost,
    required this.percentage,
  });
}

class ExpenseReportSummary {
  final int totalCost;
  final int serviceCount;
  final List<MonthlyExpense> monthlyExpenses;
  final List<CategoryExpense> categoryBreakdown;
  final List<ServiceRecord> records;

  const ExpenseReportSummary({
    required this.totalCost,
    required this.serviceCount,
    required this.monthlyExpenses,
    required this.categoryBreakdown,
    required this.records,
  });
}
