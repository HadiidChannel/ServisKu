import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/motorcycle_selector_sheet.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/vector_illustrations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motorcyclesAsync = ref.watch(motorcyclesStreamProvider);

    return motorcyclesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: const ServisKuLogoWidget(size: 36),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(
          title: const ServisKuLogoWidget(size: 36),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 48, color: AppColors.statusTerlambat),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat data kendaraan: $err',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(motorcyclesStreamProvider),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (motorcycles) {
        if (motorcycles.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const ServisKuLogoWidget(size: 36),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push(RouteNames.settings),
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const EmptyIllustrationWidget(
                      title: 'Belum Ada Motor',
                      subtitle:
                          'Tambahkan sepeda motor Anda untuk mulai memantau perawatan dan odometer.',
                      icon: Icons.two_wheeler_rounded,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: 'Tambah Motor Pertama',
                      icon: Icons.add_rounded,
                      onPressed: () => context.push(RouteNames.addMotorcycle),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final summary = ref.watch(dashboardSummaryProvider);
        final activeMotorcycle = summary.activeMotorcycle ?? motorcycles.first;

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 16,
            title: InkWell(
              onTap: () => MotorcycleSelectorSheet.show(context),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              activeMotorcycle.nickname,
                              style: AppTypography.headlineSmall,
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                        Text(
                          '${activeMotorcycle.brand} ${activeMotorcycle.model}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Pengaturan',
                onPressed: () => context.push(RouteNames.settings),
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(motorcyclesStreamProvider);
                ref.invalidate(
                    motorcycleSchedulesProvider(activeMotorcycle.id));
                ref.invalidate(
                    motorcycleServiceRecordsProvider(activeMotorcycle.id));
                ref.invalidate(activeMotorcycleMonthExpenseProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle Hero Card
                    _buildHeroCard(context, activeMotorcycle),
                    const SizedBox(height: 16),

                    // Maintenance Status Overview Bar
                    _buildStatusOverview(context, summary),
                    const SizedBox(height: 20),

                    // Priority Maintenance Schedules
                    _buildPrioritySchedules(
                        context, ref, activeMotorcycle.id, summary),
                    const SizedBox(height: 20),

                    // Latest Service Activity & Monthly Expense Row
                    _buildActivityAndExpense(
                        context, activeMotorcycle.id, summary),
                    const SizedBox(height: 24),

                    // Prominent Tambah Catatan Servis Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: CustomButton(
                        label: 'Tambah Catatan Servis',
                        icon: Icons.add_circle_outline_rounded,
                        onPressed: () => context.push(
                          '${RouteNames.addServiceRecord}?vehicleId=${activeMotorcycle.id}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroCard(BuildContext context, dynamic motorcycle) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final duration =
        disableAnimations ? Duration.zero : const Duration(milliseconds: 250);

    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Card(
        key: ValueKey(motorcycle.id),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // Vehicle Hero Illustration with AnimatedSwitcher for type
              AnimatedSwitcher(
                duration: duration,
                child: MotorcycleHeroWidget(
                  key:
                      ValueKey('${motorcycle.id}_${motorcycle.motorcycleType}'),
                  motorcycleType: motorcycle.motorcycleType,
                  height: 120,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kilometer Saat Ini',
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: 2),
                      AnimatedSwitcher(
                        duration: duration,
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: Text(
                          AppFormatters.formatKm(motorcycle.currentOdometerKm),
                          key: ValueKey(motorcycle.currentOdometerKm),
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.primary,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      if (motorcycle.lastOdometerUpdate != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Pembaruan: ${AppFormatters.formatDateIndonesian(motorcycle.lastOdometerUpdate!)}',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.push(
                      '/vehicles/${motorcycle.id}/odometer',
                    ),
                    icon: const Icon(Icons.speed_rounded, size: 18),
                    label: const Text('Perbarui'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusOverview(BuildContext context, DashboardSummary summary) {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewItem(
            context: context,
            label: 'Terlambat',
            count: summary.overdueCount,
            color: AppColors.statusTerlambat,
            bgColor: AppColors.statusTerlambatContainer,
            icon: Icons.error_outline_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildOverviewItem(
            context: context,
            label: 'Segera',
            count: summary.soonCount,
            color: AppColors.statusSegera,
            bgColor: AppColors.statusSegeraContainer,
            icon: Icons.warning_amber_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildOverviewItem(
            context: context,
            label: 'Aman',
            count: summary.safeCount,
            color: AppColors.statusAman,
            bgColor: AppColors.statusAmanContainer,
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewItem({
    required BuildContext context,
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final duration =
        disableAnimations ? Duration.zero : const Duration(milliseconds: 200);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: duration,
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              count.toString(),
              key: ValueKey(count),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySchedules(
    BuildContext context,
    WidgetRef ref,
    String motorcycleId,
    DashboardSummary summary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Jadwal Prioritas',
              style: AppTypography.headlineSmall,
            ),
            TextButton(
              onPressed: () =>
                  context.push('/vehicles/$motorcycleId/maintenance'),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (summary.hasSchedulesError) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.statusTerlambat),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Gagal memuat jadwal perawatan.',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(
                        motorcycleSchedulesProvider(motorcycleId)),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ] else if (summary.prioritySchedules.isEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Belum ada jadwal perawatan aktif untuk motor ini.',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.push(
                      '${RouteNames.addMaintenance}?vehicleId=$motorcycleId',
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Atur Jadwal Perawatan'),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: summary.prioritySchedules.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final item = summary.prioritySchedules[i];
              return InkWell(
                onTap: () =>
                    context.push('/vehicles/$motorcycleId/maintenance'),
                borderRadius: BorderRadius.circular(14),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.schedule.name,
                                style: AppTypography.titleMedium,
                              ),
                            ),
                            StatusBadge(status: item.calculation.status),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.calculation.reason,
                          style: AppTypography.bodySmall.copyWith(
                            color: item.calculation.status.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TweenAnimationBuilder<double>(
                          duration: MediaQuery.of(context).disableAnimations
                              ? Duration.zero
                              : const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          tween: Tween<double>(
                              begin: 0, end: item.calculation.progress),
                          builder: (context, value, _) => ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: value,
                              minHeight: 6,
                              backgroundColor: AppColors.surfaceVariant,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                item.calculation.status.color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildActivityAndExpense(
    BuildContext context,
    String motorcycleId,
    DashboardSummary summary,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Latest Service Activity
        Expanded(
          child: Card(
            child: InkWell(
              onTap: () {
                if (summary.latestService != null) {
                  context.push('/service-records/${summary.latestService!.id}');
                } else {
                  context.push(RouteNames.history);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.history_rounded,
                            size: 18, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'Servis Terakhir',
                          style: AppTypography.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (summary.hasRecordsError) ...[
                      const Text(
                        'Gagal memuat servis terakhir.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.statusTerlambat,
                        ),
                      ),
                    ] else if (summary.latestService != null) ...[
                      Text(
                        AppFormatters.formatDateIndonesian(
                            summary.latestService!.serviceDate),
                        style: AppTypography.labelMedium
                            .copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        summary.latestService!.itemsSummary,
                        style: AppTypography.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppFormatters.formatRupiah(
                            summary.latestService!.totalCost),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'Belum ada catatan servis.',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Month Expense
        Expanded(
          child: Card(
            child: InkWell(
              onTap: () => context.push(RouteNames.reports),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            size: 18, color: AppColors.blueAccent),
                        SizedBox(width: 6),
                        Text(
                          'Biaya Bulan Ini',
                          style: AppTypography.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (summary.hasExpenseError) ...[
                      const Text(
                        'Gagal memuat biaya',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.statusTerlambat,
                        ),
                      ),
                    ] else ...[
                      Text(
                        AppFormatters.formatRupiah(summary.currentMonthExpense),
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 2),
                    const Text(
                      'Ketuk untuk laporan lengkap',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
