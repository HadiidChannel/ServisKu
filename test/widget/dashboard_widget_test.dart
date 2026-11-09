import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/app/providers/app_providers.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/dashboard/presentation/dashboard_screen.dart';
import 'package:servis/features/motorcycles/domain/motorcycle.dart';

void main() {
  final testMotorcycle = Motorcycle(
    id: 'motor-1',
    nickname: 'Vario 160',
    brand: 'Honda',
    model: 'Vario',
    motorcycleType: 'matic',
    propulsionType: 'gasoline',
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
    currentOdometerKm: 5000,
  );

  testWidgets('DashboardScreen displays empty state when no motorcycle added', (
    WidgetTester tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Belum Ada Motor'), findsOneWidget);
    expect(find.text('Tambah Motor Pertama'), findsOneWidget);

    await db.close();
  });

  testWidgets(
    'DashboardScreen displays loading indicators and not false zeros',
    (WidgetTester tester) async {
      final db = AppDatabase(NativeDatabase.memory());

      final loadingSummary = DashboardSummary(
        activeMotorcycle: testMotorcycle,
        isLoading: true,
        isSchedulesLoading: true,
        isRecordsLoading: true,
        isExpenseLoading: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            motorcyclesStreamProvider.overrideWith(
              (ref) => Stream.value([testMotorcycle]),
            ),
            dashboardSummaryProvider.overrideWithValue(loadingSummary),
          ],
          child: const MaterialApp(home: DashboardScreen()),
        ),
      );

      await tester.pump();

      // Verify loading state UI
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(find.text('Memuat data...'), findsOneWidget);
      expect(find.text('Memuat biaya...'), findsOneWidget);

      // Verify false empty state or false Rp 0 are NOT shown
      expect(
        find.text('Belum ada jadwal perawatan aktif untuk motor ini.'),
        findsNothing,
      );
      expect(find.text('Rp 0'), findsNothing);

      await db.close();
    },
  );

  testWidgets('DashboardScreen displays error states with retry buttons', (
    WidgetTester tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());

    final errorSummary = DashboardSummary(
      activeMotorcycle: testMotorcycle,
      hasSchedulesError: true,
      hasRecordsError: true,
      hasExpenseError: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          motorcyclesStreamProvider.overrideWith(
            (ref) => Stream.value([testMotorcycle]),
          ),
          dashboardSummaryProvider.overrideWithValue(errorSummary),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Gagal memuat jadwal perawatan.'), findsOneWidget);
    expect(find.text('Gagal memuat servis terakhir.'), findsOneWidget);
    expect(find.text('Gagal memuat biaya'), findsOneWidget);
    expect(find.text('Coba Lagi'), findsOneWidget);
    expect(find.text('Coba lagi'), findsNWidgets(2));

    await db.close();
  });
}
