import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/app/providers/app_providers.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/odometer/presentation/odometer_screen.dart';

void main() {
  testWidgets('OdometerScreen displays current reading and allows input', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: OdometerScreen(motorcycleId: 'm1')),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Pembaruan Kilometer'), findsOneWidget);
    expect(find.text('Catat Kilometer Baru'), findsOneWidget);
    expect(find.text('Angka Kilometer Baru (km) *'), findsOneWidget);
    expect(find.text('Simpan Kilometer'), findsOneWidget);
    expect(find.text('Riwayat Pembacaan Kilometer'), findsOneWidget);

    await db.close();
  });
}
