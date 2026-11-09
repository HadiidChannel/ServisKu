import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/confirmation_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _hasDevicePermission = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final notifService = ref.read(notificationServiceProvider);

    final enabled = await settingsRepo.areNotificationsEnabled();
    final devicePerm = await notifService.areNotificationsEnabled();

    if (mounted) {
      setState(() {
        _notificationsEnabled = enabled;
        _hasDevicePermission = devicePerm;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    final settingsRepo = ref.read(settingsRepositoryProvider);
    await settingsRepo.setNotificationsEnabled(value);

    if (value) {
      final notifService = ref.read(notificationServiceProvider);
      var granted = await notifService.areNotificationsEnabled();
      if (!granted) {
        granted = await notifService.requestPermission();
      }
      if (mounted) {
        setState(() => _hasDevicePermission = granted);
      }
      if (granted) {
        await ref.read(notificationReconcilerProvider).reconcileAll();
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    final granted =
        await ref.read(notificationServiceProvider).requestPermission();
    setState(() => _hasDevicePermission = granted);

    if (granted) {
      await ref.read(notificationReconcilerProvider).reconcileAll();
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(granted
            ? 'Izin notifikasi telah diberikan.'
            : 'Izin notifikasi belum diberikan. Pengingat tetap dapat dilihat di aplikasi.'),
      ),
    );
  }

  Future<void> _confirmClearAllData() async {
    // Dialog 1
    final firstConfirm = await ConfirmationDialog.show(
      context,
      title: 'Hapus Seluruh Data?',
      message:
          'Seluruh data kendaraan, pembacaan kilometer, jadwal perawatan, riwayat servis, foto nota, dan preferensi aplikasi akan dihapus secara permanen dari perangkat ini.',
      confirmLabel: 'Lanjut Hapus',
      cancelLabel: 'Batal',
      isDestructive: true,
    );

    if (firstConfirm != true || !mounted) return;

    // Dialog 2 (Multi-step verification)
    final finalConfirm = await ConfirmationDialog.show(
      context,
      title: 'Konfirmasi Penghapusan Akhir',
      message:
          'Tindakan ini tidak dapat dibatalkan. Apakah Anda benar-benar yakin ingin mengosongkan seluruh data aplikasi ServisKu?',
      confirmLabel: 'Hapus Semua Data',
      cancelLabel: 'Batal',
      isDestructive: true,
    );

    if (finalConfirm == true && mounted) {
      final result = await ref.read(settingsRepositoryProvider).clearAllData();

      if (!mounted) return;
      if (!result.databaseSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                result.errorMessage ?? 'Gagal menghapus database aplikasi.'),
            backgroundColor: AppColors.statusTerlambat,
          ),
        );
        return;
      }

      if (!result.attachmentsCleaned) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Data database telah dihapus, namun sebagian berkas foto tidak dapat dibersihkan secara fisik.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seluruh data aplikasi telah dihapus.')),
        );
      }
      context.go(RouteNames.splash);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section: Pengingat & Notifikasi
          const Text('Pengingat & Notifikasi',
              style: AppTypography.headlineSmall),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: const Text('Aktifkan Pengingat Lokal',
                      style: AppTypography.titleSmall),
                  subtitle: const Text(
                    'Jadwalkan pemberitahuan saat jarak atau tanggal servis mendekati jatuh tempo.',
                    style: AppTypography.bodySmall,
                  ),
                  value: _notificationsEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: _toggleNotifications,
                ),
                const Divider(height: 1),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: const Text('Status Izin Perangkat',
                      style: AppTypography.titleSmall),
                  subtitle: Text(
                    _hasDevicePermission
                        ? 'Izin notifikasi Android aktif.'
                        : 'Izin belum diberikan. Pengingat tetap dapat dipantau dari aplikasi.',
                    style: AppTypography.bodySmall,
                  ),
                  trailing: _hasDevicePermission
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.statusAman)
                      : OutlinedButton(
                          onPressed: _requestNotificationPermission,
                          child: const Text('Minta Izin'),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: Informasi Aplikasi & Privasi
          const Text('Informasi Aplikasi & Privasi',
              style: AppTypography.headlineSmall),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Versi Aplikasi', style: AppTypography.titleSmall),
                      Text(AppConstants.appVersion,
                          style: AppTypography.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Platform', style: AppTypography.titleSmall),
                      Text('Android Offline-first',
                          style: AppTypography.bodyMedium),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Penyimpanan Data Lokal',
                      style: AppTypography.titleSmall),
                  const SizedBox(height: 4),
                  const Text(
                    'Seluruh data sepeda motor, catatan odometer, jadwal perawatan, riwayat servis, dan foto nota bukti pembayaran Anda disimpan secara privat di dalam penyimpanan lokal perangkat ini.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ServisKu tidak memerlukan akun, tidak memiliki server eksternal, dan tidak mengirim data kendaraan Anda ke pihak mana pun.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 20, color: AppColors.primaryDark),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Penting: Menghapus aplikasi atau membersihkan data aplikasi melalui pengaturan Android dapat menghapus seluruh data yang tersimpan secara permanen.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryDark,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section: Zona Bahaya / Hapus Data
          const Text('Zona Pengelolaan Data',
              style: AppTypography.headlineSmall),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hapus Seluruh Data Aplikasi',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.statusTerlambat)),
                  const SizedBox(height: 4),
                  const Text(
                    'Kosongkan semua data kendaraan, jadwal, riwayat servis, foto, dan preferensi untuk memulai kembali dari awal.',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _confirmClearAllData,
                    icon: const Icon(Icons.delete_forever_rounded,
                        color: AppColors.statusTerlambat),
                    label: const Text('Hapus Seluruh Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.statusTerlambat,
                      side: const BorderSide(
                          color: AppColors.statusTerlambat, width: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
