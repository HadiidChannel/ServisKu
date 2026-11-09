import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/vector_illustrations.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Allow splash animation minimum duration
      await Future.delayed(const Duration(milliseconds: 600));

      // 1. Initialize notification service safely (separate from database initialization)
      try {
        final notifService = ref.read(notificationServiceProvider);
        await notifService.initialize();
        // Trigger startup reconciliation in background
        ref.read(notificationReconcilerProvider).reconcileAll();
      } catch (_) {
        // Notification initialization failure must not prevent opening the application
      }

      // 2. Read settings and motorcycles
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final motorcycleRepo = ref.read(motorcycleRepositoryProvider);

      final isOnboarded = await settingsRepo.isOnboardingCompleted();
      final motorcycles = await motorcycleRepo.getAll();

      if (!mounted) return;

      if (!isOnboarded) {
        context.go(RouteNames.onboarding);
      } else if (motorcycles.isEmpty) {
        context.go(RouteNames.addMotorcycle);
      } else {
        // Ensure active motorcycle is valid
        final activeId = await settingsRepo.getActiveMotorcycleId();
        if (activeId == null || !motorcycles.any((m) => m.id == activeId)) {
          await settingsRepo.setActiveMotorcycleId(motorcycles.first.id);
        }
        if (!mounted) return;
        context.go(RouteNames.home);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal membuka database lokal. Silakan coba kembali.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const ServisKuLogoWidget(size: 80),
              const SizedBox(height: 28),
              const Text(
                'Perawatan Motor Tanpa Ribet',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.statusTerlambat),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _errorMessage = null);
                    _initializeApp();
                  },
                  child: const Text('Coba Lagi'),
                ),
              ] else ...[
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
