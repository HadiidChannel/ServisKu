import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/vector_illustrations.dart';
import '../domain/maintenance_calculator.dart';
import '../domain/maintenance_schedule.dart';

class MaintenanceScheduleScreen extends ConsumerStatefulWidget {
  final String motorcycleId;

  const MaintenanceScheduleScreen({
    super.key,
    required this.motorcycleId,
  });

  @override
  ConsumerState<MaintenanceScheduleScreen> createState() =>
      _MaintenanceScheduleScreenState();
}

class _MaintenanceScheduleScreenState
    extends ConsumerState<MaintenanceScheduleScreen> {
  String _selectedFilter = 'Semua'; // Semua, Perlu Perhatian, Nonaktif

  @override
  Widget build(BuildContext context) {
    final motorcyclesAsync = ref.watch(motorcyclesStreamProvider);
    final schedulesAsync =
        ref.watch(motorcycleSchedulesProvider(widget.motorcycleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Perawatan'),
      ),
      body: motorcyclesAsync.when(
        data: (motorcycles) {
          final matches =
              motorcycles.where((m) => m.id == widget.motorcycleId).toList();
          final motorcycle = matches.isNotEmpty ? matches.first : null;

          if (motorcycle == null) {
            return const Center(child: Text('Kendaraan tidak ditemukan.'));
          }

          return schedulesAsync.when(
            data: (schedules) {
              final calculatedList = schedules.map((s) {
                final calc = MaintenanceCalculator.calculate(
                  schedule: s,
                  currentOdometerKm: motorcycle.currentOdometerKm,
                );
                return {'schedule': s, 'calc': calc};
              }).toList();

              // Filter
              final filtered = calculatedList.where((item) {
                final s = item['schedule'] as MaintenanceSchedule;
                final c = item['calc'] as MaintenanceCalculationResult;

                if (_selectedFilter == 'Perlu Perhatian') {
                  return s.isActive &&
                      (c.status == MaintenanceStatus.terlambat ||
                          c.status == MaintenanceStatus.segera);
                } else if (_selectedFilter == 'Nonaktif') {
                  return !s.isActive;
                }
                return true;
              }).toList();

              return Column(
                children: [
                  // Filter Chips Bar
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: AppColors.surface,
                    child: Row(
                      children: [
                        _buildFilterChip('Semua'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Perlu Perhatian'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Nonaktif'),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const EmptyIllustrationWidget(
                                    title: 'Tidak Ada Jadwal',
                                    subtitle:
                                        'Belum ada jadwal perawatan pada kategori filter ini.',
                                    icon: Icons.calendar_month_rounded,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () => context.push(
                                      '${RouteNames.addMaintenance}?vehicleId=${motorcycle.id}',
                                    ),
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text('Tambah Jadwal'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final s = item['schedule'] as MaintenanceSchedule;
                              final c =
                                  item['calc'] as MaintenanceCalculationResult;

                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  s.name,
                                                  style:
                                                      AppTypography.titleMedium,
                                                ),
                                                if (s.category != null &&
                                                    s.category!.isNotEmpty) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    s.category!,
                                                    style:
                                                        AppTypography.bodySmall,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          StatusBadge(status: c.status),
                                          PopupMenuButton<String>(
                                            icon: const Icon(
                                                Icons.more_vert_rounded),
                                            onSelected: (val) async {
                                              if (val == 'edit') {
                                                context.push(
                                                    '/maintenance/${s.id}/edit');
                                              } else if (val == 'toggle') {
                                                await ref
                                                    .read(
                                                        maintenanceRepositoryProvider)
                                                    .toggleActive(
                                                        s.id, !s.isActive);
                                              } else if (val == 'delete') {
                                                _confirmDelete(context, ref, s);
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit_outlined,
                                                        size: 20),
                                                    SizedBox(width: 10),
                                                    Text('Ubah Jadwal'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'toggle',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      s.isActive
                                                          ? Icons
                                                              .pause_circle_outline_rounded
                                                          : Icons
                                                              .play_circle_outline_rounded,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(s.isActive
                                                        ? 'Nonaktifkan'
                                                        : 'Aktifkan'),
                                                  ],
                                                ),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        size: 20,
                                                        color: AppColors
                                                            .statusTerlambat),
                                                    SizedBox(width: 10),
                                                    Text('Hapus Jadwal',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .statusTerlambat)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        c.reason,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: c.status.color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: c.progress,
                                          minHeight: 6,
                                          backgroundColor:
                                              AppColors.surfaceVariant,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            c.status.color,
                                          ),
                                        ),
                                      ),
                                      const Divider(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (s.intervalKm != null)
                                            Text(
                                              'Tiap ${AppFormatters.formatNumber(s.intervalKm!)} km',
                                              style: AppTypography.bodySmall,
                                            ),
                                          if (s.intervalMonths != null)
                                            Text(
                                              'Tiap ${s.intervalMonths} bulan',
                                              style: AppTypography.bodySmall,
                                            ),
                                          if (!s.isActive)
                                            const Text(
                                              'Status: Nonaktif',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textMuted,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Gagal memuat jadwal.')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Gagal memuat data.')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(
          '${RouteNames.addMaintenance}?vehicleId=${widget.motorcycleId}',
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Jadwal'),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedFilter = label);
      },
      selectedColor: AppColors.primaryContainer,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    MaintenanceSchedule schedule,
  ) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Hapus Jadwal?',
      message:
          'Jadwal "${schedule.name}" akan dihapus. Riwayat servis yang pernah terhubung ke jadwal ini akan tetap tersimpan.',
      confirmLabel: 'Hapus Jadwal',
      cancelLabel: 'Batal',
      isDestructive: true,
    );

    if (confirmed == true) {
      await ref.read(maintenanceRepositoryProvider).deleteSchedule(schedule.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Jadwal "${schedule.name}" telah dihapus.')),
        );
      }
    }
  }
}
