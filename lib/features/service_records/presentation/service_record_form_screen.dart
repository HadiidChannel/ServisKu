import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../maintenance/domain/maintenance_schedule.dart';
import '../data/service_record_repository.dart';

class ServiceItemFormData {
  String itemName;
  String? category;
  int itemCost;
  String? maintenanceScheduleId;
  String? notes;

  ServiceItemFormData({
    this.itemName = '',
    this.category,
    this.itemCost = 0,
    this.maintenanceScheduleId,
    this.notes,
  });
}

class ServiceRecordFormScreen extends ConsumerStatefulWidget {
  final String? recordId;
  final String? vehicleId;

  const ServiceRecordFormScreen({
    super.key,
    this.recordId,
    this.vehicleId,
  });

  @override
  ConsumerState<ServiceRecordFormScreen> createState() =>
      _ServiceRecordFormScreenState();
}

class _ServiceRecordFormScreenState
    extends ConsumerState<ServiceRecordFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedMotorcycleId;
  DateTime _serviceDate = DateTime.now();
  final _odometerController = TextEditingController();
  final _workshopController = TextEditingController();
  final _additionalCostController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  final List<ServiceItemFormData> _items = [];
  final List<File> _selectedPhotos = [];
  final List<String> _existingAttachmentPaths = [];
  final List<String> _deletedAttachmentIds = [];

  bool _isLoading = false;

  bool get isEditing => widget.recordId != null;

  @override
  void initState() {
    super.initState();
    _selectedMotorcycleId = widget.vehicleId;

    if (isEditing) {
      _loadExisting();
    } else {
      // Start with one empty item
      _items.add(ServiceItemFormData());
    }
  }

  Future<void> _loadExisting() async {
    final record = await ref
        .read(serviceRecordRepositoryProvider)
        .getById(widget.recordId!);
    if (record != null && mounted) {
      setState(() {
        _selectedMotorcycleId = record.motorcycleId;
        _serviceDate = record.serviceDate;
        _odometerController.text = record.odometerKm.toString();
        _workshopController.text = record.workshopName ?? '';
        _additionalCostController.text = record.additionalCost.toString();
        _notesController.text = record.notes ?? '';

        _items.clear();
        for (final it in record.items) {
          _items.add(ServiceItemFormData(
            itemName: it.itemName,
            category: it.category,
            itemCost: it.itemCost,
            maintenanceScheduleId: it.maintenanceScheduleId,
            notes: it.notes,
          ));
        }

        for (final att in record.attachments) {
          _existingAttachmentPaths.add(att.localPath);
        }
      });
    }
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _workshopController.dispose();
    _additionalCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _calculatedTotal {
    int itemsSum = 0;
    for (final it in _items) {
      itemsSum += it.itemCost;
    }
    final additional = int.tryParse(_additionalCostController.text.trim()) ?? 0;
    return itemsSum + additional;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _selectedPhotos.add(File(picked.path));
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto tidak dapat dibuka.')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _serviceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _serviceDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMotorcycleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih motor terlebih dahulu.')),
      );
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tambahkan minimal satu pekerjaan servis.'),
          backgroundColor: AppColors.statusTerlambat,
        ),
      );
      return;
    }

    final odoKm = int.tryParse(_odometerController.text.trim());
    if (odoKm == null || odoKm < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan kilometer yang valid.'),
          backgroundColor: AppColors.statusTerlambat,
        ),
      );
      return;
    }

    final additionalCost =
        int.tryParse(_additionalCostController.text.trim()) ?? 0;
    if (additionalCost < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biaya tambahan tidak boleh bernilai negatif.'),
          backgroundColor: AppColors.statusTerlambat,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final serviceRepo = ref.read(serviceRecordRepositoryProvider);

      final itemsPayload = _items
          .map((i) => {
                'itemName': i.itemName.trim(),
                'category': i.category?.trim(),
                'itemCost': i.itemCost,
                'maintenanceScheduleId': i.maintenanceScheduleId,
                'notes': i.notes?.trim(),
              })
          .toList();

      CreateServiceRecordResult? createResult;
      UpdateServiceRecordResult? updateResult;
      if (isEditing) {
        updateResult = await serviceRepo.updateRecord(
          recordId: widget.recordId!,
          motorcycleId: _selectedMotorcycleId!,
          serviceDate: _serviceDate,
          odometerKm: odoKm,
          workshopName: _workshopController.text.trim(),
          additionalCost: additionalCost,
          notes: _notesController.text.trim(),
          items: itemsPayload,
          newPhotoFiles: _selectedPhotos,
          deletedAttachmentIds: _deletedAttachmentIds,
        );
      } else {
        createResult = await serviceRepo.createRecord(
          motorcycleId: _selectedMotorcycleId!,
          serviceDate: _serviceDate,
          odometerKm: odoKm,
          workshopName: _workshopController.text.trim(),
          additionalCost: additionalCost,
          notes: _notesController.text.trim(),
          items: itemsPayload,
          photoFiles: _selectedPhotos,
        );
      }

      if (!mounted) return;
      if (createResult != null && !createResult.allAttachmentsSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Catatan servis disimpan, tetapi ${createResult.attachmentErrors.length} foto nota gagal disimpan.',
            ),
            backgroundColor: AppColors.statusSegera,
          ),
        );
      } else if (updateResult != null && !updateResult.allAttachmentsSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Catatan servis diperbarui, tetapi ${updateResult.attachmentErrors.length} foto nota gagal disimpan.',
            ),
            backgroundColor: AppColors.statusSegera,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing
                ? 'Catatan servis berhasil diperbarui.'
                : 'Catatan servis berhasil disimpan.'),
          ),
        );
      }
      context.pop();
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
          content: Text('Data belum berhasil disimpan. Silakan coba kembali.'),
          backgroundColor: AppColors.statusTerlambat,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final motorcyclesAsync = ref.watch(motorcyclesStreamProvider);
    final schedulesAsync = _selectedMotorcycleId != null
        ? ref.watch(motorcycleSchedulesProvider(_selectedMotorcycleId!))
        : null;

    final availableSchedules = schedulesAsync?.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title:
            Text(isEditing ? 'Ubah Catatan Servis' : 'Tambah Catatan Servis'),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Biaya Servis',
                        style: AppTypography.bodySmall),
                    Text(
                      AppFormatters.formatRupiah(_calculatedTotal),
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              CustomButton(
                label: isEditing ? 'Simpan Ubahan' : 'Simpan Servis',
                isLoading: _isLoading,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Motorcycle Selector
                motorcyclesAsync.when(
                  data: (list) {
                    if (_selectedMotorcycleId == null && list.isNotEmpty) {
                      _selectedMotorcycleId = list.first.id;
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedMotorcycleId,
                      decoration:
                          const InputDecoration(labelText: 'Pilih Motor *'),
                      items: list.map((m) {
                        return DropdownMenuItem<String>(
                          value: m.id,
                          child: Text('${m.nickname} (${m.brand} ${m.model})'),
                        );
                      }).toList(),
                      onChanged: isEditing
                          ? null
                          : (val) {
                              setState(() {
                                _selectedMotorcycleId = val;
                                // Clear linked schedules from items if motorcycle changed
                                for (final it in _items) {
                                  it.maintenanceScheduleId = null;
                                }
                              });
                            },
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 16),

                // Date & Odometer Row
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Tanggal Servis *',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textMuted)),
                                  Text(
                                    AppFormatters.formatDateIndonesian(
                                        _serviceDate),
                                    style: AppTypography.titleSmall,
                                  ),
                                ],
                              ),
                              const Icon(Icons.calendar_today_rounded,
                                  size: 16, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _odometerController,
                        label: 'Kilometer Servis *',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Wajib diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _workshopController,
                  label: 'Nama Bengkel / Lokasi',
                  hint: 'Contoh: Bengkel AHASS 0123, Mandiri Motor',
                ),
                const SizedBox(height: 24),

                // Multi-item Service List Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Pekerjaan Servis',
                        style: AppTypography.titleMedium,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _items.add(ServiceItemFormData());
                        });
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Tambah Item'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, index) {
                    return _buildItemCard(index, availableSchedules);
                  },
                ),
                const SizedBox(height: 20),

                // Additional Cost
                CustomTextField(
                  controller: _additionalCostController,
                  label: 'Biaya Tambahan / Ongkos Pasang (Rp)',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _notesController,
                  label: 'Catatan Kunjungan Servis',
                  hint: 'Saran mekanik, keluhan motor, atau catatan garansi',
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Photo Receipts Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Foto Nota & Bukti Servis',
                      style: AppTypography.titleMedium,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt_outlined,
                              color: AppColors.primary),
                          tooltip: 'Ambil Foto',
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                        IconButton(
                          icon: const Icon(Icons.photo_library_outlined,
                              color: AppColors.primary),
                          tooltip: 'Pilih dari Galeri',
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (_selectedPhotos.isEmpty &&
                    _existingAttachmentPaths.isEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.border, style: BorderStyle.solid),
                    ),
                    child: const Center(
                      child: Text(
                        'Belum ada foto nota terpilih.\nGunakan kamera atau galeri untuk melampirkan nota.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ..._existingAttachmentPaths.map((path) {
                          final file = File(path);
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            height: 100,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    file,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.receipt_rounded),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        ..._selectedPhotos.map((file) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            height: 100,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    file,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () => setState(
                                        () => _selectedPhotos.remove(file)),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close_rounded,
                                          size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(
      int index, List<MaintenanceSchedule> availableSchedules) {
    final item = _items[index];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item #${index + 1}',
                  style: AppTypography.titleSmall
                      .copyWith(color: AppColors.primary),
                ),
                if (_items.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 20, color: AppColors.statusTerlambat),
                    onPressed: () {
                      setState(() {
                        _items.removeAt(index);
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: item.itemName,
              decoration: const InputDecoration(
                labelText: 'Nama Pekerjaan / Komponen *',
                hintText: 'Contoh: Ganti Oli Mesin, Kampas Rem Belakang',
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Nama pekerjaan wajib diisi.';
                }
                return null;
              },
              onChanged: (val) => item.itemName = val,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue:
                        item.itemCost > 0 ? item.itemCost.toString() : '0',
                    decoration: const InputDecoration(
                      labelText: 'Biaya (Rp) *',
                      hintText: '0',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        item.itemCost = int.tryParse(val.trim()) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: item.category ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      hintText: 'Pelumasan, dll',
                    ),
                    onChanged: (val) => item.category = val,
                  ),
                ),
              ],
            ),
            if (availableSchedules.isNotEmpty) ...[
              const SizedBox(height: 10),
              DropdownButtonFormField<String?>(
                initialValue: item.maintenanceScheduleId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Hubungkan ke Jadwal Perawatan (Opsional)',
                  helperText:
                      'Menandai jadwal selesai dan memulai siklus baru.',
                  helperMaxLines: 2,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Tidak dihubungkan ke jadwal'),
                  ),
                  ...availableSchedules.map((s) {
                    return DropdownMenuItem<String?>(
                      value: s.id,
                      child: Text(s.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    );
                  }),
                ],
                onChanged: (val) {
                  setState(() {
                    item.maintenanceScheduleId = val;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
