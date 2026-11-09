import 'package:flutter_test/flutter_test.dart';
import 'package:servis/features/maintenance/domain/maintenance_calculator.dart';
import 'package:servis/features/maintenance/domain/maintenance_schedule.dart';

void main() {
  group('MaintenanceCalculator Unit Tests', () {
    test('Kilometer-based schedule status evaluation', () {
      final schedule = MaintenanceSchedule(
        id: 's1',
        motorcycleId: 'm1',
        name: 'Oli Mesin',
        intervalKm: 2000,
        lastDoneKm: 10000,
        reminderLeadKm: 500,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Safe (Aman)
      final resSafe = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 11000,
      );
      expect(resSafe.status, MaintenanceStatus.aman);
      expect(resSafe.dueKm, 12000);
      expect(resSafe.remainingKm, 1000);
      expect(resSafe.reason, contains('1.000 km'));

      // Soon (Segera)
      final resSoon = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 11600,
      );
      expect(resSoon.status, MaintenanceStatus.segera);
      expect(resSoon.remainingKm, 400);
      expect(resSoon.reason, contains('400 km'));

      // Overdue (Terlambat) exactly at due
      final resDue = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 12000,
      );
      expect(resDue.status, MaintenanceStatus.terlambat);

      // Overdue past due
      final resOverdue = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 12150,
      );
      expect(resOverdue.status, MaintenanceStatus.terlambat);
      expect(resOverdue.reason, contains('150 km'));
    });

    test('Date-based schedule status evaluation', () {
      final schedule = MaintenanceSchedule(
        id: 's2',
        motorcycleId: 'm1',
        name: 'Servis Berkala',
        intervalMonths: 3,
        lastDoneDate: DateTime(2026, 1, 1),
        reminderLeadDays: 7,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Due date is April 1, 2026
      // March 1 -> Aman
      final resSafe = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 0,
        today: DateTime(2026, 3, 1),
      );
      expect(resSafe.status, MaintenanceStatus.aman);

      // March 26 (6 days before April 1) -> Segera
      final resSoon = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 0,
        today: DateTime(2026, 3, 26),
      );
      expect(resSoon.status, MaintenanceStatus.segera);
      expect(resSoon.reason, contains('6 hari'));

      // April 1 (due date) -> Terlambat
      final resDue = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 0,
        today: DateTime(2026, 4, 1),
      );
      expect(resDue.status, MaintenanceStatus.terlambat);

      // April 6 -> Terlambat 5 hari
      final resOverdue = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 0,
        today: DateTime(2026, 4, 6),
      );
      expect(resOverdue.status, MaintenanceStatus.terlambat);
      expect(resOverdue.reason, contains('5 hari'));
    });

    test('Combined schedule prioritizes most urgent status', () {
      final schedule = MaintenanceSchedule(
        id: 's3',
        motorcycleId: 'm1',
        name: 'Oli & Filter',
        intervalKm: 2000,
        lastDoneKm: 10000,
        reminderLeadKm: 300,
        intervalMonths: 3,
        lastDoneDate: DateTime(2026, 1, 1),
        reminderLeadDays: 7,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // KM is Aman (10500 km), Date is Terlambat (April 5) -> Terlambat
      final res1 = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 10500,
        today: DateTime(2026, 4, 5),
      );
      expect(res1.status, MaintenanceStatus.terlambat);

      // KM is Segera (11800 km), Date is Aman (Feb 1) -> Segera
      final res2 = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 11800,
        today: DateTime(2026, 2, 1),
      );
      expect(res2.status, MaintenanceStatus.segera);

      // Both are Aman -> Aman
      final res3 = MaintenanceCalculator.calculate(
        schedule: schedule,
        currentOdometerKm: 10500,
        today: DateTime(2026, 2, 1),
      );
      expect(res3.status, MaintenanceStatus.aman);
    });

    test(
        'Incomplete baseline gives Belum diatur unless other boundary is overdue',
        () {
      final incompleteSchedule = MaintenanceSchedule(
        id: 's4',
        motorcycleId: 'm1',
        name: 'Busi',
        intervalKm: 8000,
        lastDoneKm: null, // missing km baseline!
        intervalMonths: 6,
        lastDoneDate: DateTime(2026, 1, 1),
        reminderLeadDays: 7,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Date is not overdue yet (Feb 1), but km baseline is missing -> Belum diatur
      final res1 = MaintenanceCalculator.calculate(
        schedule: incompleteSchedule,
        currentOdometerKm: 5000,
        today: DateTime(2026, 2, 1),
      );
      expect(res1.status, MaintenanceStatus.belumDiatur);
      expect(res1.reason, contains('Kilometer terakhir belum diisi'));

      // If date is overdue (August 1) -> Terlambat!
      final res2 = MaintenanceCalculator.calculate(
        schedule: incompleteSchedule,
        currentOdometerKm: 5000,
        today: DateTime(2026, 8, 1),
      );
      expect(res2.status, MaintenanceStatus.terlambat);
    });

    test('Cycle key generation changes when baseline changes', () {
      final sched1 = MaintenanceSchedule(
        id: 's1',
        motorcycleId: 'm1',
        name: 'Oli',
        intervalKm: 2000,
        lastDoneKm: 5000,
        lastDoneDate: DateTime(2026, 1, 1),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final key1 = MaintenanceCalculator.generateCycleKey(sched1);

      final sched2 = sched1.copyWith(
        lastDoneKm: 7000,
        lastDoneDate: DateTime(2026, 3, 1),
      );

      final key2 = MaintenanceCalculator.generateCycleKey(sched2);

      expect(key1, isNot(equals(key2)));
      expect(key1, contains('5000'));
      expect(key2, contains('7000'));
    });
  });
}
