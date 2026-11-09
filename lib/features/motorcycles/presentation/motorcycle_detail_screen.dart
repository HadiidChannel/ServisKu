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
import '../../maintenance/domain/maintenance_calculator.dart';
import 'add_edit_motorcycle_screen.dart';

class MotorcycleDetailScreen extends ConsumerWidget {
  final String motorcycleId;

  const MotorcycleDetailScreen({super.key, required this.motorcycleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motorcyclesAsync = ref.watch(motorcyclesStreamProvider);

    return motorcyclesAsync.when(
      data: (list) {
        final matches = list.where((m) => m.id == motorcycleId).toList();
        if (matches.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Motor')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Kendaraan tidak ditemukan.',
                      style: AppTypography.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Motor mungkin telah dihapus.',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Kembali'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final motorcycle = matches.first;
        final schedulesAsync = ref.watch(
          motorcycleSchedulesProvider(motorcycle.id),
        );
        final recordsAsync = ref.watch(
          motorcycleServiceRecordsProvider(motorcycle.id),
        );

        final schedules = schedulesAsync.value ?? [];
        final records = recordsAsync.value ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text(motorcycle.nickname),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Ubah Data',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          AddEditMotorcycleScreen(motorcycle: motorcycle),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Hapus Motor',
                onPressed: () async {
                  final confirmed = await ConfirmationDialog.show(
                    context,
                    title: 'Hapus ${motorcycle.nickname}?',
                    message: 'Seluruh jadwal, riwayat servis, odometer, dan foto bukti untuk motor ini akan dihapus secara permanen.',
                    confirmLabel: 'Hapus Motor',
                    cancelLabel: 'Batal',
                    isDestructive: true,
                  );

                  if (confirmed == true) {
                    final result = await ref
                        .read(motorcycleRepositoryProvider)
                        .deleteMotorcycle(motorcycle.id);
                    if (context.mounted) {
                      if (result.databaseSuccess) {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result.attachmentsCleaned
                                  ? '${motorcycle.nickname} dan seluruh berkas berhasil dihapus.'
                                  : '${motorcycle.nickname} dihapus. Sebagian berkas lampiran akan dibersihkan di latar belakang.',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result.errorMessage ??
                                  'Gagal menghapus sepeda motor.',
                            ),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle hero illustration
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        MotorcycleHeroWidget(
                          motorcycleType: motorcycle.motorcycleType,
                          height: 120,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  motorcycle.nickname,
                                  style: AppTypography.headlineSmall,
                                ),
                                Text(
                                  '${motorcycle.brand} ${motorcycle.model}',
                                  style: AppTypography.bodyMedium,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppFormatters.formatKm(
                                    motorcycle.currentOdometerKm,
                                  ),
                                  style: AppTypography.headlineSmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (motorcycle.lastOdometerUpdate != null)
                                  Text(
                                    AppFormatters.formatDateIndonesian(
                                      motorcycle.lastOdometerUpdate!,
                                    ),
                                    style: AppTypography.bodySmall,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            context.push('/vehicles/${motorcycle.id}/odometer'),
                        icon: const Icon(Icons.speed_rounded, size: 18),
                        label: const Text('Odometer'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.push(
                          '/vehicles/${motorcycle.id}/maintenance',
                        ),
                        icon: const Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                        ),
                        label: const Text('Jadwal'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.push(
                          '${RouteNames.addServiceRecord}?vehicleId=${motorcycle.id}',
                        ),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Servis'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Vehicle specifications
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Kendaraan',
                          style: AppTypography.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Tipe Motor', motorcycle.typeLabel),
                        _buildInfoRow('Penggerak', motorcycle.propulsionLabel),
                        if (motorcycle.manufactureYear != null)
                          _buildInfoRow(
                            'Tahun Produksi',
                            motorcycle.manufactureYear.toString(),
                          ),
                        if (motorcycle.licensePlate != null &&
                            motorcycle.licensePlate!.isNotEmpty)
                          _buildInfoRow(
                            'Nomor Polisi',
                            motorcycle.licensePlate!,
                          ),
                        if (motorcycle.notes != null &&
                            motorcycle.notes!.isNotEmpty)
                          _buildInfoRow('Catatan', motorcycle.notes!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Maintenance schedules summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jadwal Perawatan',
                      style: AppTypography.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () => context.push(
                        '/vehicles/${motorcycle.id}/maintenance',
                      ),
                      child: const Text('Kelola'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (schedules.isEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Belum ada jadwal perawatan.'),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () => context.push(
                                '${RouteNames.addMaintenance}?vehicleId=${motorcycle.id}',
                              ),
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Tambah Jadwal'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: schedules.take(3).length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final s = schedules[i];
                      final calc = MaintenanceCalculator.calculate(
                        schedule: s,
                        currentOdometerKm: motorcycle.currentOdometerKm,
                      );

                      return Card(
                        child: ListTile(
                          title: Text(s.name, style: AppTypography.titleSmall),
                          subtitle: Text(
                            calc.reason,
                            style: AppTypography.bodySmall,
                          ),
                          trailing: StatusBadge(
                            status: calc.status,
                            compact: true,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),

                // Recent Service History
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Riwayat Servis Terakhir',
                      style: AppTypography.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () => context.push(RouteNames.history),
                      child: const Text('Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (records.isEmpty) ...[
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('Belum ada riwayat servis.')),
                    ),
                  ),
                ] else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: records.take(3).length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final rec = records[i];
                      return Card(
                        child: ListTile(
                          onTap: () =>
                              context.push('/service-records/${rec.id}'),
                          title: Text(
                            rec.itemsSummary,
                            style: AppTypography.titleSmall,
                          ),
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
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text('Gagal memuat data.'))),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
