import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/vector_illustrations.dart';
import '../domain/motorcycle.dart';
import 'add_edit_motorcycle_screen.dart';

class MotorcycleListScreen extends ConsumerWidget {
  const MotorcycleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motorcyclesAsync = ref.watch(motorcyclesStreamProvider);
    final activeId = ref.watch(activeMotorcycleIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kendaraan Saya')),
      body: motorcyclesAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const EmptyIllustrationWidget(
                      title: 'Belum Ada Motor',
                      subtitle: 'Tambahkan sepeda motor Anda untuk mulai mengelola jadwal dan servis.',
                      icon: Icons.two_wheeler_rounded,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push(RouteNames.addMotorcycle),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Tambah Motor'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final m = list[i];
              final isActive = m.id == activeId || (activeId == null && i == 0);

              return Card(
                child: InkWell(
                  onTap: () => context.push('/vehicles/${m.id}'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primaryContainer
                                    : AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.two_wheeler_rounded,
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          m.nickname,
                                          style: AppTypography.headlineSmall
                                              .copyWith(fontSize: 17),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isActive) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            'Aktif',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${m.brand} ${m.model} (${m.typeLabel})',
                                    style: AppTypography.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded),
                              onSelected: (val) async {
                                if (val == 'activate') {
                                  await ref
                                      .read(activeMotorcycleIdProvider.notifier)
                                      .setActiveId(m.id);
                                } else if (val == 'edit') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AddEditMotorcycleScreen(
                                        motorcycle: m,
                                      ),
                                    ),
                                  );
                                } else if (val == 'delete') {
                                  _confirmDelete(context, ref, m);
                                }
                              },
                              itemBuilder: (context) => [
                                if (!isActive)
                                  const PopupMenuItem(
                                    value: 'activate',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text('Jadikan Aktif'),
                                      ],
                                    ),
                                  ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_outlined, size: 20),
                                      SizedBox(width: 10),
                                      Text('Ubah Data'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline_rounded,
                                        size: 20,
                                        color: AppColors.statusTerlambat,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Hapus Motor',
                                        style: TextStyle(
                                          color: AppColors.statusTerlambat,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Odometer: ${AppFormatters.formatKm(m.currentOdometerKm)}',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Row(
                              children: [
                                Text(
                                  'Lihat Detail',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Gagal memuat daftar kendaraan.')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.addMotorcycle),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Motor'),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Motorcycle motorcycle,
  ) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Hapus ${motorcycle.nickname}?',
      message: 'Seluruh data jadwal perawatan, riwayat servis, pembacaan kilometer, dan foto nota untuk motor ini akan dihapus secara permanen.',
      confirmLabel: 'Hapus Motor',
      cancelLabel: 'Batal',
      isDestructive: true,
    );

    if (confirmed == true) {
      final result = await ref
          .read(motorcycleRepositoryProvider)
          .deleteMotorcycle(motorcycle.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.attachmentsCleaned
                  ? '${motorcycle.nickname} dan seluruh berkas berhasil dihapus.'
                  : '${motorcycle.nickname} dihapus, sebagian foto tidak dapat dibersihkan.',
            ),
          ),
        );
      }
    }
  }
}
