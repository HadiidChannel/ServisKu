import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../database/app_database.dart';
import '../providers/app_providers.dart';
import '../theme/app_colors.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  Future<void> _onAppResumed() async {
    // 1. Refresh device timezone dynamically and detect timezone changes
    bool timezoneChanged = false;
    try {
      final notifService = ref.read(notificationServiceProvider);
      await notifService.refreshDeviceTimezone();
      final currentTz = await notifService.getCurrentTimezone();

      final db = ref.read(databaseProvider);
      final storedTzSetting =
          await (db.select(db.appSettings)..where(
                (tbl) => tbl.key.equals(AppConstants.keyLastKnownTimezone),
              ))
              .getSingleOrNull();

      if (storedTzSetting == null) {
        await db
            .into(db.appSettings)
            .insertOnConflictUpdate(
              AppSettingsCompanion.insert(
                key: AppConstants.keyLastKnownTimezone,
                value: currentTz,
                updatedAt: DateTime.now().toIso8601String(),
              ),
            );
      } else if (storedTzSetting.value != currentTz) {
        timezoneChanged = true;
        await ref
            .read(notificationReconcilerProvider)
            .handleTimezoneChanged(newTimezone: currentTz);
      }
    } catch (_) {}

    // 2. Reconcile maintenance notifications (if not already handled by timezone change)
    if (!timezoneChanged) {
      try {
        await ref.read(notificationReconcilerProvider).reconcileAll();
      } catch (_) {}
    }

    // 3. Concurrency-guarded orphan attachment cleanup
    try {
      final db = ref.read(databaseProvider);
      final activeRows = await db.select(db.serviceAttachments).get();
      final activePaths = activeRows.map((r) => r.localPath).toSet();
      await ref
          .read(attachmentStorageServiceProvider)
          .runStartupOrphanCleanup(activePaths);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryContainer,
        elevation: 2,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: AppColors.primaryDark,
            ),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.two_wheeler_outlined),
            selectedIcon: Icon(
              Icons.two_wheeler_rounded,
              color: AppColors.primaryDark,
            ),
            label: 'Kendaraan',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(
              Icons.history_rounded,
              color: AppColors.primaryDark,
            ),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(
              Icons.bar_chart_rounded,
              color: AppColors.primaryDark,
            ),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }
}
