import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/services/attachment_storage_service.dart';
import '../../../core/widgets/vector_illustrations.dart';
import '../domain/service_record.dart';

class ServiceHistoryScreen extends ConsumerStatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  ConsumerState<ServiceHistoryScreen> createState() =>
      _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends ConsumerState<ServiceHistoryScreen> {
  String? _selectedMotorcycleId; // null means all vehicles

  @override
  Widget build(BuildContext context) {
    final motorcyclesAsync = ref.watch(motorcyclesStreamProvider);
    final recordsStream =
        ref.watch(motorcycleServiceRecordsProvider(_selectedMotorcycleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Servis'),
      ),
      body: Column(
        children: [
          // Motorcycle Filter Bar
          motorcyclesAsync.when(
            data: (motorcycles) {
              if (motorcycles.isEmpty) return const SizedBox();

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.surface,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Semua Motor'),
                        selected: _selectedMotorcycleId == null,
                        onSelected: (val) {
                          if (val) setState(() => _selectedMotorcycleId = null);
                        },
                        selectedColor: AppColors.primaryContainer,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: _selectedMotorcycleId == null
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _selectedMotorcycleId == null
                              ? AppColors.primaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...motorcycles.map((m) {
                        final isSelected = _selectedMotorcycleId == m.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(m.nickname),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) {
                                setState(() => _selectedMotorcycleId = m.id);
                              }
                            },
                            selectedColor: AppColors.primaryContainer,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const Divider(height: 1),

          // Records List
          Expanded(
            child: recordsStream.when(
              data: (records) {
                if (records.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const EmptyIllustrationWidget(
                            title: 'Belum Ada Riwayat Servis',
                            subtitle:
                                'Catat kunjungan servis motor Anda untuk menyimpan bukti nota dan melacak biaya.',
                            icon: Icons.receipt_long_rounded,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () =>
                                context.push(RouteNames.addServiceRecord),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Catat Servis Pertama'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final motorcycles = motorcyclesAsync.value ?? [];

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final rec = records[i];
                    final motorcycle = motorcycles
                        .where((m) => m.id == rec.motorcycleId)
                        .firstOrNull;

                    return Card(
                      child: InkWell(
                        onTap: () => context.push('/service-records/${rec.id}'),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Receipt thumbnail or icon
                              _buildThumbnail(rec),
                              const SizedBox(width: 14),

                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppFormatters.formatDateIndonesian(
                                              rec.serviceDate),
                                          style: AppTypography.titleSmall,
                                        ),
                                        Text(
                                          AppFormatters.formatRupiah(
                                              rec.totalCost),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rec.itemsSummary,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        if (motorcycle != null) ...[
                                          Text(
                                            motorcycle.nickname,
                                            style: AppTypography.bodySmall,
                                          ),
                                          const Text(' • ',
                                              style: AppTypography.bodySmall),
                                        ],
                                        Text(
                                          AppFormatters.formatKm(
                                              rec.odometerKm),
                                          style: AppTypography.bodySmall,
                                        ),
                                        if (rec.workshopName != null &&
                                            rec.workshopName!.isNotEmpty) ...[
                                          const Text(' • ',
                                              style: AppTypography.bodySmall),
                                          Flexible(
                                            child: Text(
                                              rec.workshopName!,
                                              style: AppTypography.bodySmall,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
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
                  const Center(child: Text('Gagal memuat riwayat servis.')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.addServiceRecord),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Catat Servis'),
      ),
    );
  }

  Widget _buildThumbnail(ServiceRecord record) {
    if (record.attachments.isNotEmpty) {
      final originalPath = record.attachments.first.localPath;
      final thumbPath = AttachmentStorageService.getThumbnailPath(originalPath);
      final thumbFile = File(thumbPath);
      final displayFile =
          thumbFile.existsSync() ? thumbFile : File(originalPath);

      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 52,
          height: 52,
          color: AppColors.surfaceVariant,
          child: displayFile.existsSync()
              ? Image.file(
                  displayFile,
                  fit: BoxFit.cover,
                  cacheWidth: 150,
                  errorBuilder: (_, __, ___) {
                    return const Icon(Icons.receipt_rounded,
                        color: AppColors.textMuted);
                  },
                )
              : const Icon(Icons.receipt_rounded, color: AppColors.textMuted),
        ),
      );
    }

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child:
          const Icon(Icons.build_rounded, color: AppColors.primary, size: 24),
    );
  }
}
