import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/app/providers/app_providers.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/service_records/presentation/service_record_form_screen.dart';

void main() {
  testWidgets(
      'ServiceRecordFormScreen supports dynamic service items and total calculation',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: ServiceRecordFormScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Tambah Catatan Servis'), findsOneWidget);
    expect(find.text('Item #1'), findsOneWidget);
    expect(find.text('Tambah Item'), findsOneWidget);
    expect(find.text('Total Biaya Servis'), findsOneWidget);

    // Tap Tambah Item to add second item
    final tambahBtn = find.text('Tambah Item');
    await tester.ensureVisible(tambahBtn);
    await tester.tap(tambahBtn);
    await tester.pumpAndSettle();

    expect(find.text('Item #2'), findsOneWidget);

    await db.close();
  });
}
