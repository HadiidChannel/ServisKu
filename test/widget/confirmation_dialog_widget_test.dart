import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/core/widgets/confirmation_dialog.dart';

void main() {
  testWidgets('ConfirmationDialog displays prompt and triggers onConfirm', (
    WidgetTester tester,
  ) async {
    bool confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConfirmationDialog(
            title: 'Hapus Motor?',
            message: 'Semua data akan dihapus.',
            confirmLabel: 'Hapus',
            cancelLabel: 'Batal',
            isDestructive: true,
            onConfirm: () {
              confirmed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Hapus Motor?'), findsOneWidget);
    expect(find.text('Semua data akan dihapus.'), findsOneWidget);
    expect(find.text('Hapus'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);

    await tester.tap(find.text('Hapus'));
    expect(confirmed, isTrue);
  });
}
