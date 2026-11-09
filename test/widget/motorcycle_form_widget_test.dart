import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/app/providers/app_providers.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/motorcycles/presentation/add_edit_motorcycle_screen.dart';

void main() {
  testWidgets('AddEditMotorcycleScreen validates required fields on submit', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: AddEditMotorcycleScreen()),
      ),
    );

    // Initial fields are displayed
    expect(find.text('Tambah Motor Baru'), findsOneWidget);
    expect(find.text('Nama Panggilan Motor *'), findsOneWidget);
    expect(find.text('Merek *'), findsOneWidget);
    expect(find.text('Model / Varian *'), findsOneWidget);
    expect(find.text('Matic'), findsOneWidget);
    expect(find.text('Bebek'), findsOneWidget);
    expect(find.text('Sport'), findsOneWidget);
    expect(find.text('Bensin'), findsOneWidget);
    expect(find.text('Listrik'), findsOneWidget);

    // Tap save without filling form
    final saveButton = find.text('Simpan Motor');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verification: validation messages appear
    expect(find.text('Nama motor wajib diisi.'), findsOneWidget);
    expect(find.text('Merek wajib diisi.'), findsOneWidget);
    expect(find.text('Model wajib diisi.'), findsOneWidget);

    await db.close();
  });
}
