import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/widgets/vector_illustrations.dart';
import '../domain/expense_summary.dart';

class ExpenseReportScreen extends ConsumerStatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  ConsumerState<ExpenseReportScreen> createState() =>
      _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends ConsumerState<ExpenseReportScreen> {
  ReportPeriod _selectedPeriod = ReportPeriod.thisMonth;
  String? _selectedMotorcycleId; // null = all motorcycles
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  void initState() {
    super.initState();
    // Default to active motorcycle
    final active = ref.read(activeMotorcycleProvider);
    _selectedMotorcycleId = active?.id;
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: _customStartDate ?? DateTime(now.year, now.month, 1),
        end: _customEndDate ?? now,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedPeriod = ReportPeriod.custom;
        _customStartDate = picked.start;
        _customEndDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final motorcycles = ref.watch(motorcyclesStreamProvider).value ?? [];
    final filterParams = ReportFilterParams(
      motorcycleId: _selectedMotorcycleId,
      period: _selectedPeriod,
      customStartDate: _customStartDate,
      customEndDate: _customEndDate,
    );
    final reportAsync = ref.watch(expenseReportStreamProvider(filterParams));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Biaya Perawatan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle & Period Filters
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    // Motorcycle Dropdown
                    DropdownButtonFormField<String?>(
                      initialValue: _selectedMotorcycleId,
                      decoration: const InputDecoration(
                        labelText: 'Filter Motor',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Semua Motor'),
                        ),
                        ...motorcycles.map((m) {
                          return DropdownMenuItem<String?>(
                            value: m.id,
                            child:
                                Text('${m.nickname} (${m.brand} ${m.model})'),
                          );
                        }),
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedMotorcycleId = val),
                    ),
                    const SizedBox(height: 12),

                    // Period presets row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildPeriodChip(ReportPeriod.thisMonth),
                          const SizedBox(width: 8),
                          _buildPeriodChip(ReportPeriod.lastThreeMonths),
                          const SizedBox(width: 8),
                          _buildPeriodChip(ReportPeriod.thisYear),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: Row(
                              children: [
                                const Icon(Icons.date_range_rounded, size: 14),
                                const SizedBox(width: 4),
                                Text(_selectedPeriod == ReportPeriod.custom &&
                                        _customStartDate != null &&
                                        _customEndDate != null
                                    ? '${AppFormatters.formatDateIndonesian(_customStartDate!)} - ${AppFormatters.formatDateIndonesian(_customEndDate!)}'
                                    : 'Kustom'),
                              ],
                            ),
                            selected: _selectedPeriod == ReportPeriod.custom,
                            onSelected: (_) => _pickCustomDateRange(),
                            selectedColor: AppColors.primaryContainer,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedPeriod == ReportPeriod.custom
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _selectedPeriod == ReportPeriod.custom
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Report Content
            reportAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 48, color: AppColors.statusTerlambat),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat laporan: $err',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(
                            expenseReportStreamProvider(filterParams)),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (summary) {
                if (summary.records.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const EmptyIllustrationWidget(
                            title: 'Tidak Ada Transaksi',
                            subtitle:
                                'Belum ada catatan servis pada periode atau filter motor yang dipilih.',
                            icon: Icons.bar_chart_rounded,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Total Pengeluaran: ${AppFormatters.formatRupiah(0)}',
                            style: AppTypography.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Summary Card
                    Card(
                      color: AppColors.primaryContainer.withValues(alpha: 0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Pengeluaran Periode',
                                    style: AppTypography.bodySmall),
                                const SizedBox(height: 4),
                                Text(
                                  AppFormatters.formatRupiah(summary.totalCost),
                                  style: AppTypography.displayLarge.copyWith(
                                    color: AppColors.primaryDark,
                                    fontSize: 26,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${summary.serviceCount} Servis',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Monthly Chart
                    if (summary.monthlyExpenses.isNotEmpty) ...[
                      const Text('Grafik Pengeluaran Bulanan',
                          style: AppTypography.headlineSmall),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                          child: SizedBox(
                            height: 200,
                            child: _buildBarChart(summary.monthlyExpenses),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Category Breakdown
                    if (summary.categoryBreakdown.isNotEmpty) ...[
                      const Text('Rincian Kategori Pekerjaan',
                          style: AppTypography.headlineSmall),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: summary.categoryBreakdown.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (ctx, i) {
                              final cat = summary.categoryBreakdown[i];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(cat.category,
                                          style: AppTypography.titleSmall),
                                      Text(
                                        '${AppFormatters.formatRupiah(cat.totalCost)} (${cat.percentage.toStringAsFixed(1)}%)',
                                        style:
                                            AppTypography.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: cat.percentage / 100.0,
                                      minHeight: 6,
                                      backgroundColor: AppColors.surfaceVariant,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Transaction List
                    const Text('Daftar Kunjungan Servis Terkait',
                        style: AppTypography.headlineSmall),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: summary.records.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        final rec = summary.records[i];
                        return Card(
                          child: ListTile(
                            onTap: () =>
                                context.push('/service-records/${rec.id}'),
                            title: Text(rec.itemsSummary,
                                style: AppTypography.titleSmall),
                            subtitle: Text(
                              '${AppFormatters.formatDateIndonesian(rec.serviceDate)} • ${AppFormatters.formatKm(rec.odometerKm)}',
                              style: AppTypography.bodySmall,
                            ),
                            trailing: Text(
                              AppFormatters.formatRupiah(rec.totalCost),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(ReportPeriod period) {
    final isSelected = _selectedPeriod == period;
    return ChoiceChip(
      label: Text(period.label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedPeriod = period);
      },
      selectedColor: AppColors.primaryContainer,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildBarChart(List<MonthlyExpense> monthly) {
    int maxVal = 0;
    for (final m in monthly) {
      if (m.totalCost > maxVal) maxVal = m.totalCost;
    }
    if (maxVal == 0) maxVal = 100000;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final m = monthly[groupIndex];
              return BarTooltipItem(
                '${m.label}\n${AppFormatters.formatRupiah(m.totalCost)}',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, meta) {
                final idx = val.toInt();
                if (idx < 0 || idx >= monthly.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    monthly[idx].label,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondary),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(monthly.length, (i) {
          final m = monthly[i];
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: m.totalCost.toDouble(),
                color: AppColors.primary,
                width: 18,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }),
      ),
    );
  }
}
