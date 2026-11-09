import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../domain/maintenance_schedule.dart';
import '../domain/maintenance_template.dart';

class MaintenanceFormScreen extends ConsumerStatefulWidget {
  final String? scheduleId;
  final String? vehicleId;

  const MaintenanceFormScreen({
    super.key,
    this.scheduleId,
    this.vehicleId,
  });

  @override
  ConsumerState<MaintenanceFormScreen> createState() =>
      _MaintenanceFormScreenState();
}

class _MaintenanceFormScreenState extends ConsumerState<MaintenanceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _intervalKmController;
  late final TextEditingController _intervalMonthsController;
  late final TextEditingController _lastDoneKmController;
  late final TextEditingController _reminderLeadKmController;
  late final TextEditingController _reminderLeadDaysController;

  String? _selectedMotorcycleId;
  DateTime? _lastDoneDate;
  bool _isActive = true;
  bool _isLoading = false;
  MaintenanceSchedule? _existingSchedule;

  bool get isEditing => widget.scheduleId != null;

  @override
  void initState() {
    super.initState();
    _selectedMotorcycleId = widget.vehicleId;

    _nameController = TextEditingController();
    _categoryController = TextEditingController();
    _intervalKmController = TextEditingController();
    _intervalMonthsController = TextEditingController();
    _lastDoneKmController = TextEditingController();
    _reminderLeadKmController = TextEditingController(
        text: AppConstants.defaultReminderLeadKm.toString());
    _reminderLeadDaysController = TextEditingController(
        text: AppConstants.defaultReminderLeadDays.toString());

    if (isEditing) {
      _loadExisting();
    }
  }

  Future<void> _loadExisting() async {
    final schedule = await ref
        .read(maintenanceRepositoryProvider)
        .getById(widget.scheduleId!);
    if (schedule != null && mounted) {
      setState(() {
        _existingSchedule = schedule;
        _selectedMotorcycleId = schedule.motorcycleId;
        _nameController.text = schedule.name;
        _categoryController.text = schedule.category ?? '';
        _intervalKmController.text = schedule.intervalKm?.toString() ?? '';
        _intervalMonthsController.text =
            schedule.intervalMonths?.toString() ?? '';
        _lastDoneKmController.text = schedule.lastDoneKm?.toString() ?? '';
        _lastDoneDate = schedule.lastDoneDate;
        _reminderLeadKmController.text =
            schedule.reminderLeadKm?.toString() ?? '';
        _reminderLeadDaysController.text =
            schedule.reminderLeadDays?.toString() ?? '';
        _isActive = schedule.isActive;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _intervalKmController.dispose();
    _intervalMonthsController.dispose();
    _lastDoneKmController.dispose();
    _reminderLeadKmController.dispose();
    _reminderLeadDaysController.dispose();
    super.dispose();
  }

  void _applyTemplate(MaintenanceTemplate template) {
    setState(() {
      _nameController.text = template.name;
      _categoryController.text = template.category;
      _intervalKmController.text = template.defaultIntervalKm?.toString() ?? '';
      _intervalMonthsController.text =
          template.defaultIntervalMonths?.toString() ?? '';
      _reminderLeadKmController.text = template.defaultLeadKm.toString();
      _reminderLeadDaysController.text = template.defaultLeadDays.toString();
    });
  }

  Future<void> _showTemplatePicker() async {
    final motorcycles = await ref.read(motorcycleRepositoryProvider).getAll();
    final currentMotorcycle =
        motorcycles.where((m) => m.id == _selectedMotorcycleId).firstOrNull;

    final templates = MaintenanceTemplate.getTemplatesForMotorcycle(
      motorcycleType: currentMotorcycle?.motorcycleType ?? 'matic',
      propulsionType: currentMotorcycle?.propulsionType ?? 'gasoline',
    );

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderMedium,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Template Perawatan',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 18, color: AppColors.primaryDark),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Interval pada template adalah nilai acuan awal yang dapat disesuaikan. Sesuaikan interval berdasarkan buku manual resmi sepeda motor atau anjuran mekanik.',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: templates.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final t = templates[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(t.name, style: AppTypography.titleMedium),
                    subtitle: Text(
                      '${t.category} • ${t.defaultIntervalKm != null ? "${AppFormatters.formatNumber(t.defaultIntervalKm!)} km" : ""}${t.defaultIntervalKm != null && t.defaultIntervalMonths != null ? " / " : ""}${t.defaultIntervalMonths != null ? "${t.defaultIntervalMonths} bulan" : ""}',
                      style: AppTypography.bodySmall,
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _applyTemplate(t);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLastDoneDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastDoneDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _lastDoneDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMotorcycleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kendaraan terlebih dahulu.')),
      );
      return;
    }

    final intKm = int.tryParse(_intervalKmController.text.trim());
    final intMonths = int.tryParse(_intervalMonthsController.text.trim());

    if (intKm == null && intMonths == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Isi interval kilometer, interval waktu, atau keduanya.'),
          backgroundColor: AppColors.statusTerlambat,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final maintenanceRepo = ref.read(maintenanceRepositoryProvider);
      final lastKm = int.tryParse(_lastDoneKmController.text.trim());
      final leadKm = int.tryParse(_reminderLeadKmController.text.trim());
      final leadDays = int.tryParse(_reminderLeadDaysController.text.trim());

      if (isEditing) {
        final updated = _existingSchedule!.copyWith(
          name: _nameController.text.trim(),
          category: _categoryController.text.trim().isNotEmpty
              ? _categoryController.text.trim()
              : null,
          intervalKm: intKm,
          intervalMonths: intMonths,
          lastDoneKm: lastKm,
          lastDoneDate: _lastDoneDate,
          manualLastDoneKm: lastKm,
          manualLastDoneDate: _lastDoneDate,
          reminderLeadKm: leadKm,
          reminderLeadDays: leadDays,
          isActive: _isActive,
        );

        await maintenanceRepo.updateSchedule(updated);
      } else {
        await maintenanceRepo.createSchedule(
          motorcycleId: _selectedMotorcycleId!,
          name: _nameController.text.trim(),
          category: _categoryController.text.trim().isNotEmpty
              ? _categoryController.text.trim()
              : null,
          intervalKm: intKm,
          intervalMonths: intMonths,
          lastDoneKm: lastKm,
          lastDoneDate: _lastDoneDate,
          reminderLeadKm: leadKm,
          reminderLeadDays: leadDays,
          isActive: _isActive,
        );
      }

      // Reconcile notifications
      final motorcycle = await ref
          .read(motorcycleRepositoryProvider)
          .getById(_selectedMotorcycleId!);
      final schedules = await ref
          .read(maintenanceRepositoryProvider)
          .getSchedules(_selectedMotorcycleId!);
      if (motorcycle != null) {
        await ref.read(notificationReconcilerProvider).reconcileForMotorcycle(
              motorcycle: motorcycle,
              schedules: schedules,
            );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing
              ? 'Jadwal perawatan berhasil diperbarui.'
              : 'Jadwal perawatan berhasil disimpan.'),
        ),
      );
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

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Ubah Jadwal' : 'Tambah Jadwal Perawatan'),
        actions: [
          if (!isEditing)
            TextButton.icon(
              onPressed: _showTemplatePicker,
              icon: const Icon(Icons.auto_awesome_rounded, size: 16),
              label: const Text('Template'),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Picker if not fixed
                motorcyclesAsync.when(
                  data: (list) {
                    if (_selectedMotorcycleId == null && list.isNotEmpty) {
                      _selectedMotorcycleId = list.first.id;
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedMotorcycleId,
                      decoration: const InputDecoration(
                        labelText: 'Kendaraan *',
                      ),
                      items: list.map((m) {
                        return DropdownMenuItem<String>(
                          value: m.id,
                          child: Text('${m.nickname} (${m.brand} ${m.model})'),
                        );
                      }).toList(),
                      onChanged: isEditing
                          ? null
                          : (val) =>
                              setState(() => _selectedMotorcycleId = val),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Perawatan *',
                  hint: 'Contoh: Oli Mesin, Busi, Filter Udara',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nama perawatan wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _categoryController,
                  label: 'Kategori (Opsional)',
                  hint: 'Pelumasan, Pengereman, Mesin, dll',
                ),
                const SizedBox(height: 20),

                const Text(
                  'Interval Perawatan (Isi Salah Satu atau Keduanya)',
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _intervalKmController,
                        label: 'Interval Kilometer',
                        hint: 'Contoh: 2500',
                        keyboardType: TextInputType.number,
                        helperText: 'Tiap kelipatan km',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _intervalMonthsController,
                        label: 'Interval Bulan',
                        hint: 'Contoh: 3',
                        keyboardType: TextInputType.number,
                        helperText: 'Tiap berapa bulan',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'Titik Acuan Terakhir Dilakukan (Baseline)',
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Jika belum tahu, biarkan kosong. Jadwal akan berstatus "Belum diatur" sampai diservis pertama kali.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _lastDoneKmController,
                        label: 'Km Terakhir Dilakukan',
                        hint: 'Contoh: 10000',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Terakhir',
                              style: AppTypography.titleSmall),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: _selectLastDoneDate,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 52,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _lastDoneDate != null
                                        ? AppFormatters.formatDateIndonesian(
                                            _lastDoneDate!)
                                        : 'Pilih Tanggal',
                                    style: TextStyle(
                                      color: _lastDoneDate != null
                                          ? AppColors.textPrimary
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today_rounded,
                                      size: 18, color: AppColors.primary),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'Konfigurasi Pengingat (Lead Reminder)',
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _reminderLeadKmController,
                        label: 'Ingatkan Sebelum (km)',
                        hint: '500',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _reminderLeadDaysController,
                        label: 'Ingatkan Sebelum (hari)',
                        hint: '7',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Status Aktif',
                      style: AppTypography.titleSmall),
                  subtitle:
                      const Text('Jadwal aktif dipantau dan masuk pengingat'),
                  value: _isActive,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) => setState(() => _isActive = val),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    label: isEditing ? 'Simpan Perubahan' : 'Simpan Jadwal',
                    isLoading: _isLoading,
                    onPressed: _save,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
