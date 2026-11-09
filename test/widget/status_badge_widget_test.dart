import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/core/widgets/status_badge.dart';
import 'package:servis/features/maintenance/domain/maintenance_schedule.dart';

void main() {
  testWidgets(
    'StatusBadge displays text and icons for all statuses (not color alone)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StatusBadge(status: MaintenanceStatus.aman),
                StatusBadge(status: MaintenanceStatus.segera),
                StatusBadge(status: MaintenanceStatus.terlambat),
                StatusBadge(status: MaintenanceStatus.belumDiatur),
              ],
            ),
          ),
        ),
      );

      // Verify text labels
      expect(find.text('Aman'), findsOneWidget);
      expect(find.text('Segera'), findsOneWidget);
      expect(find.text('Terlambat'), findsOneWidget);
      expect(find.text('Belum diatur'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.help_outline_rounded), findsOneWidget);
    },
  );
}
