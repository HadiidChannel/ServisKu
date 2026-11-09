import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/custom_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Catat & Pantau Perawatan',
      'subtitle': 'Simpan data sepeda motor, pembacaan kilometer, dan riwayat pekerjaan servis lengkap beserta foto nota bukti pembayaran.',
      'icon': Icons.two_wheeler_rounded,
      'color': AppColors.primary,
      'asset': 'assets/illustrations/onboarding_1.svg',
    },
    {
      'title': 'Pengingat Tepat Waktu',
      'subtitle': 'Dapatkan notifikasi lokal saat jarak tempuh atau waktu servis mendekati jatuh tempo, tanpa perlu bergantung pada koneksi internet.',
      'icon': Icons.notifications_active_rounded,
      'color': AppColors.statusSegera,
      'asset': 'assets/illustrations/onboarding_2.svg',
    },
    {
      'title': 'Laporan Biaya Transparan',
      'subtitle': 'Evaluasi pengeluaran motor Anda secara berkala melalui ringkasan dan grafik pengeluaran bulanan yang akurat.',
      'icon': Icons.bar_chart_rounded,
      'color': AppColors.statusAman,
      'asset': 'assets/illustrations/onboarding_3.svg',
    },
  ];

  Future<void> _completeOnboarding() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    await settingsRepo.setOnboardingCompleted(true);
    if (!mounted) return;
    context.go(RouteNames.addMotorcycle);
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: _completeOnboarding,
            child: const Text('Lewati'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (ctx, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: SvgPicture.asset(
                            page['asset'] as String,
                            fit: BoxFit.contain,
                            placeholderBuilder: (ctx) => Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: (page['color'] as Color).withValues(
                                  alpha: 0.12,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                page['icon'] as IconData,
                                size: 68,
                                color: page['color'] as Color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          page['title'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: disableAnimations
                            ? Duration.zero
                            : const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.borderMedium,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      label: _currentPage == _pages.length - 1
                          ? 'Mulai Sekarang'
                          : 'Lanjut',
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          if (disableAnimations) {
                            _pageController.jumpToPage(_currentPage + 1);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        } else {
                          _completeOnboarding();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
