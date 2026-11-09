import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../domain/motorcycle.dart';

class AddEditMotorcycleScreen extends ConsumerStatefulWidget {
  final Motorcycle? motorcycle;

  const AddEditMotorcycleScreen({
    super.key,
    this.motorcycle,
  });

  @override
  ConsumerState<AddEditMotorcycleScreen> createState() =>
      _AddEditMotorcycleScreenState();
}

class _AddEditMotorcycleScreenState
    extends ConsumerState<AddEditMotorcycleScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nicknameController;
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _plateController;
  late final TextEditingController _odometerController;
  late final TextEditingController _notesController;

  late String _selectedType;
  late String _selectedPropulsion;
  bool _isLoading = false;

  bool get isEditing => widget.motorcycle != null;

  @override
  void initState() {
    super.initState();
    final m = widget.motorcycle;
    _nicknameController = TextEditingController(text: m?.nickname ?? '');
    _brandController = TextEditingController(text: m?.brand ?? '');
    _modelController = TextEditingController(text: m?.model ?? '');
    _yearController =
        TextEditingController(text: m?.manufactureYear?.toString() ?? '');
    _plateController = TextEditingController(text: m?.licensePlate ?? '');
    _odometerController =
        TextEditingController(text: m?.currentOdometerKm.toString() ?? '0');
    _notesController = TextEditingController(text: m?.notes ?? '');

    _selectedType = m?.motorcycleType ?? AppConstants.typeMatic;
    _selectedPropulsion = m?.propulsionType ?? AppConstants.propulsionGasoline;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    _odometerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final motorcycleRepo = ref.read(motorcycleRepositoryProvider);
      final yearText = _yearController.text.trim();
      final int? year = yearText.isNotEmpty ? int.tryParse(yearText) : null;

      if (isEditing) {
        final updated = widget.motorcycle!.copyWith(
          nickname: _nicknameController.text.trim(),
          brand: _brandController.text.trim(),
          model: _modelController.text.trim(),
          motorcycleType: _selectedType,
          manufactureYear: year,
          licensePlate: _plateController.text.trim().isNotEmpty
              ? _plateController.text.trim()
              : null,
          propulsionType: _selectedPropulsion,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        );

        await motorcycleRepo.updateMotorcycle(updated);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data motor berhasil diperbarui.')),
        );
        context.pop();
      } else {
        final odometerKm = int.tryParse(_odometerController.text.trim()) ?? 0;

        final newId = await motorcycleRepo.createMotorcycle(
          nickname: _nicknameController.text.trim(),
          brand: _brandController.text.trim(),
          model: _modelController.text.trim(),
          motorcycleType: _selectedType,
          manufactureYear: year,
          licensePlate: _plateController.text.trim().isNotEmpty
              ? _plateController.text.trim()
              : null,
          propulsionType: _selectedPropulsion,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
          initialOdometerKm: odometerKm,
        );

        await ref.read(activeMotorcycleIdProvider.notifier).setActiveId(newId);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Motor berhasil ditambahkan.')),
        );

        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.home);
        }
      }
    } on ValidationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.statusTerlambat,
        ),
      );
    } catch (e) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Ubah Data Motor' : 'Tambah Motor Baru'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _nicknameController,
                  label: 'Nama Panggilan Motor *',
                  hint: 'Contoh: Vario Hitam, Si Merah',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nama motor wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _brandController,
                        label: 'Merek *',
                        hint: 'Honda, Yamaha, dll',
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Merek wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _modelController,
                        label: 'Model / Varian *',
                        hint: 'Vario 160, NMAX, dll',
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Model wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tipe Motor *',
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTypeChip('Matic', AppConstants.typeMatic),
                    const SizedBox(width: 8),
                    _buildTypeChip('Bebek', AppConstants.typeBebek),
                    const SizedBox(width: 8),
                    _buildTypeChip('Sport', AppConstants.typeSport),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Jenis Penggerak *',
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPropulsionChip(
                        'Bensin', AppConstants.propulsionGasoline),
                    const SizedBox(width: 8),
                    _buildPropulsionChip(
                        'Listrik', AppConstants.propulsionElectric),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _yearController,
                        label: 'Tahun Produksi',
                        hint: 'Contoh: 2022',
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val != null && val.trim().isNotEmpty) {
                            final y = int.tryParse(val.trim());
                            if (y == null ||
                                y < 1950 ||
                                y > DateTime.now().year) {
                              return 'Tahun tidak valid.';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _plateController,
                        label: 'Nomor Polisi',
                        hint: 'B 1234 ABC',
                      ),
                    ),
                  ],
                ),
                if (!isEditing) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _odometerController,
                    label: 'Kilometer Saat Ini (km) *',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    helperText:
                        'Kilometer awal akan dicatat sebagai titik acuan servis.',
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
                ],
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _notesController,
                  label: 'Catatan Kendaraan',
                  hint: 'Warna, nomor rangka, atau informasi penting lainnya',
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    label: isEditing ? 'Simpan Perubahan' : 'Simpan Motor',
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

  Widget _buildTypeChip(String label, String value) {
    final isSelected = _selectedType == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryContainer : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                    isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropulsionChip(String label, String value) {
    final isSelected = _selectedPropulsion == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPropulsion = value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryContainer : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                    isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
