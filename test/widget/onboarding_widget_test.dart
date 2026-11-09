import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/features/onboarding/presentation/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen displays benefits and actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: OnboardingScreen())),
    );

    expect(find.text('Catat & Pantau Perawatan'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);
    expect(find.text('Lanjut'), findsOneWidget);

    // Tap Lanjut to page 2
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    expect(find.text('Pengingat Tepat Waktu'), findsOneWidget);
  });
}
