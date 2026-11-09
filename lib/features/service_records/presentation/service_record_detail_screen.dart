import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../domain/service_record.dart';
import 'service_record_form_screen.dart';

class ServiceRecordDetailScreen extends ConsumerStatefulWidget {
  final String recordId;

  const ServiceRecordDetailScreen({super.key, required this.recordId});

  @override
  ConsumerState<ServiceRecordDetailScreen> createState() =>
      _ServiceRecordDetailScreenState();
}

class _ServiceRecordDetailScreenState
    extends ConsumerState<ServiceRecordDetailScreen> {
  late Future<ServiceRecord?> _recordFuture;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  void _loadRecord() {
    _recordFuture = ref
        .read(serviceRecordRepositoryProvider)
        .getById(widget.recordId);
  }

  Future<void> _confirmDeleteAttachment(String attachmentId) async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Hapus Foto Nota?',
      message: 'Foto lampiran bukti servis ini akan dihapus dari penyimpanan.',
      confirmLabel: 'Hapus',
      isDestructive: true,
    );

    if (confirm == true) {
      final repo = ref.read(serviceRecordRepositoryProvider);
      final cleanupResult = await repo.deleteAttachment(attachmentId);
      ref.invalidate(motorcycleServiceRecordsProvider);
      if (mounted) {
        setState(() {
          _loadRecord();
        });
        if (cleanupResult.isComplete) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto nota berhasil dihapus.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Data foto dihapus dari database. Berkas fisik akan dibersihkan di latar belakang.',
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteRecord(ServiceRecord record) async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Hapus Catatan Servis?',
      message: 'Catatan servis ini dan seluruh lampiran foto nota akan dihapus secara permanen. Status jadwal perawatan terkait akan disesuaikan kembali.',
      confirmLabel: 'Hapus',
      isDestructive: true,
    );

    if (confirm == true) {
      final repo = ref.read(serviceRecordRepositoryProvider);
      final deleteResult = await repo.deleteRecord(record.id);

      ref.invalidate(motorcycleServiceRecordsProvider);
      ref.invalidate(activeMotorcycleMonthExpenseProvider);

      if (!mounted) return;
      if (deleteResult.isFullSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Catatan servis dan seluruh berkas lampiran berhasil dihapus.',
            ),
          ),
        );
      } else if (deleteResult.databaseSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Catatan servis dihapus. Sebagian berkas lampiran akan dibersihkan di latar belakang.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              deleteResult.errorMessage ?? 'Gagal menghapus catatan servis.',
            ),
          ),
        );
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceRecord?>(
      future: _recordFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final record = snapshot.data;
        if (record == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Servis')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Catatan servis tidak ditemukan.',
                      style: AppTypography.headlineSmall,
                    ),
                    const SizedBox(height: 20),
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

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Servis'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Ubah Servis',
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ServiceRecordFormScreen(recordId: widget.recordId),
                    ),
                  );
                  if (mounted) {
                    setState(() {
                      _loadRecord();
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.statusTerlambat,
                ),
                tooltip: 'Hapus Servis',
                onPressed: () => _deleteRecord(record),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Summary Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppFormatters.formatDateIndonesian(
                                record.serviceDate,
                              ),
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppFormatters.formatKm(record.odometerKm),
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (record.workshopName != null &&
                            record.workshopName!.isNotEmpty) ...[
                          const Divider(height: 20),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  record.workshopName!,
                                  style: AppTypography.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Items list
                const Text(
                  'Daftar Pekerjaan & Penggantian',
                  style: AppTypography.headlineSmall,
                ),
                const SizedBox(height: 8),

                Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: record.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final item = record.items[i];
                      return ListTile(
                        title: Text(
                          item.itemName,
                          style: AppTypography.titleSmall,
                        ),
                        subtitle:
                            item.category != null && item.category!.isNotEmpty
                            ? Text(
                                item.category!,
                                style: AppTypography.bodySmall,
                              )
                            : null,
                        trailing: Text(
                          AppFormatters.formatRupiah(item.itemCost),
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Cost Breakdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildCostRow(
                          'Total Pekerjaan',
                          AppFormatters.formatRupiah(record.itemsTotalCost),
                        ),
                        if (record.additionalCost > 0) ...[
                          const SizedBox(height: 8),
                          _buildCostRow(
                            'Biaya Tambahan / Jasa',
                            AppFormatters.formatRupiah(record.additionalCost),
                          ),
                        ],
                        const Divider(height: 20),
                        _buildCostRow(
                          'Total Biaya Kunjungan',
                          AppFormatters.formatRupiah(record.totalCost),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Notes
                if (record.notes != null && record.notes!.isNotEmpty) ...[
                  const Text(
                    'Catatan Kunjungan',
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        record.notes!,
                        style: AppTypography.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Attachments Gallery
                const Text(
                  'Foto Nota & Bukti Servis',
                  style: AppTypography.headlineSmall,
                ),
                const SizedBox(height: 8),
                if (record.attachments.isEmpty) ...[
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'Tidak ada foto nota yang dilampirkan.',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: record.attachments.length,
                    itemBuilder: (ctx, i) {
                      final att = record.attachments[i];
                      final file = File(att.localPath);

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: InkWell(
                              onTap: () => _showFullImage(context, file),
                              borderRadius: BorderRadius.circular(12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: AppColors.surfaceVariant,
                                  child: file.existsSync()
                                      ? Image.file(
                                          file,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Center(
                                                child: Icon(
                                                  Icons.broken_image_rounded,
                                                  size: 36,
                                                ),
                                              ),
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.broken_image_rounded,
                                            size: 36,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Material(
                              color: Colors.black.withValues(alpha: 0.6),
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () => _confirmDeleteAttachment(att.id),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCostRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? AppTypography.titleMedium : AppTypography.bodyMedium,
        ),
        Text(
          value,
          style: isBold
              ? AppTypography.headlineSmall.copyWith(color: AppColors.primary)
              : AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  void _showFullImage(BuildContext context, File file) {
    if (!file.existsSync()) return;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(file, fit: BoxFit.contain),
            ),
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
