import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../domain/odometer_reading.dart';

class OdometerScreen extends ConsumerStatefulWidget {
  final String motorcycleId;

  const OdometerScreen({
    super.key,
    required this.motorcycleId,
  });

  @override
  ConsumerState<OdometerScreen> createState() => _OdometerScreenState();
}

class _OdometerScreenState extends ConsumerState<OdometerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odometerController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _odometerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save(
      {bool isCorrection = false, String? correctionReason}) async {
    if (!_formKey.currentState!.validate() && !isCorrection) return;

    final km = int.tryParse(_odometerController.text.trim());
    if (km == null || km < 0) return;

    setState(() => _isLoading = true);

    try {
      final odoRepo = ref.read(odometerRepositoryProvider);
      final latest = await odoRepo.getLatestReading(widget.motorcycleId);

      // Check if lower than latest and not yet in correction flow
      if (latest != null && km < latest.odometerKm && !isCorrection) {
        setState(() => _isLoading = false);
        _promptCorrectionDialog(latest.odometerKm, km);
        return;
      }

      await odoRepo.addReading(
        motorcycleId: widget.motorcycleId,
        odometerKm: km,
        readingDate: _selectedDate,
        notes: isCorrection ? correctionReason : _notesController.text.trim(),
        isCorrection: isCorrection,
      );

      // Reconcile notifications after odometer update
      final motorcycle = await ref
          .read(motorcycleRepositoryProvider)
          .getById(widget.motorcycleId);
      final schedules = await ref
          .read(maintenanceRepositoryProvider)
          .getSchedules(widget.motorcycleId);
      if (motorcycle != null) {
        await ref.read(notificationReconcilerProvider).reconcileForMotorcycle(
              motorcycle: motorcycle,
              schedules: schedules,
            );
      }

      _odometerController.clear();
      _notesController.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kilometer berhasil diperbarui.')),
      );
    } on ValidationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.statusTerlambat),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan kilometer. Silakan coba kembali.'),
          backgroundColor: AppColors.statusTerlambat,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _promptCorrectionDialog(int oldKm, int newKm) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.statusSegera),
            SizedBox(width: 8),
            Text('Koreksi Odometer'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kilometer baru (${AppFormatters.formatKm(newKm)}) lebih rendah dari pembacaan terakhir (${AppFormatters.formatKm(oldKm)}).',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'Masukkan alasan koreksi pembacaan kilometer:',
              style: AppTypography.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Salah ketik angka sebelumnya',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alasan koreksi wajib diisi.')),
                );
                return;
              }
              Navigator.of(ctx).pop();
              _save(isCorrection: true, correctionReason: reason);
            },
            child: const Text('Simpan Koreksi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final motorcyclesAsync = ref.watch(motorcyclesStreamProvider);
    final readingsStream = ref
        .watch(odometerRepositoryProvider)
        .watchReadings(widget.motorcycleId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembaruan Kilometer'),
      ),
      body: motorcyclesAsync.when(
        data: (list) {
          final matches =
              list.where((m) => m.id == widget.motorcycleId).toList();
          final motorcycle = matches.isNotEmpty ? matches.first : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Reading Hero Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              motorcycle?.nickname ?? 'Motor',
                              style: AppTypography.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Kilometer Terakhir',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                        Text(
                          AppFormatters.formatKm(
                              motorcycle?.currentOdometerKm ?? 0),
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.primary,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Update Form
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Catat Kilometer Baru',
                            style: AppTypography.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _odometerController,
                            label: 'Angka Kilometer Baru (km) *',
                            hint: 'Contoh: 15400',
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Masukkan kilometer yang valid.';
                              }
                              final km = int.tryParse(val.trim());
                              if (km == null || km < 0) {
                                return 'Masukkan kilometer yang valid.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _selectDate,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: AppColors.border),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today_rounded,
                                            size: 18, color: AppColors.primary),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Tanggal Pembacaan',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.textMuted)),
                                            Text(
                                              AppFormatters
                                                  .formatDateIndonesian(
                                                      _selectedDate),
                                              style: AppTypography.titleSmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _notesController,
                            label: 'Catatan (Opsional)',
                            hint: 'Catatan perjalanan atau kondisi',
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: CustomButton(
                              label: 'Simpan Kilometer',
                              isLoading: _isLoading,
                              onPressed: () => _save(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // History Timeline
                const Text(
                  'Riwayat Pembacaan Kilometer',
                  style: AppTypography.headlineSmall,
                ),
                const SizedBox(height: 12),
                StreamBuilder<List<OdometerReading>>(
                  stream: readingsStream,
                  builder: (context, snapshot) {
                    final readings = snapshot.data ?? [];
                    if (readings.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child:
                                Text('Belum ada riwayat pembacaan kilometer.'),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: readings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        final r = readings[i];
                        return Card(
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: r.isCorrection
                                    ? AppColors.statusSegeraContainer
                                    : AppColors.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                r.isCorrection
                                    ? Icons.edit_note_rounded
                                    : Icons.speed_rounded,
                                color: r.isCorrection
                                    ? AppColors.statusSegera
                                    : AppColors.primary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              AppFormatters.formatKm(r.odometerKm),
                              style: AppTypography.titleMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppFormatters.formatDateIndonesian(r.readingDate)} • Sumber: ${r.sourceLabel}',
                                  style: AppTypography.bodySmall,
                                ),
                                if (r.notes != null && r.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    r.notes!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Gagal memuat data.')),
      ),
    );
  }
}
