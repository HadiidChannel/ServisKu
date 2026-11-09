import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/app/providers/app_providers.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  testWidgets('DashboardScreen displays empty state when no motorcycle added',
      (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Belum Ada Motor'), findsOneWidget);
    expect(find.text('Tambah Motor Pertama'), findsOneWidget);

    await db.close();
  });
}
