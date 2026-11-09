import 'package:flutter_test/flutter_test.dart';
import 'package:servis/core/constants/app_constants.dart';
import 'package:servis/core/errors/app_exceptions.dart';
import 'package:servis/core/validators/app_validators.dart';

void main() {
  group('Motorcycle Validation Tests', () {
    test('Empty nickname throws VEH-001', () {
      expect(
        () => AppValidators.validateMotorcycle(
          nickname: '   ',
          brand: 'Honda',
          model: 'Vario',
          motorcycleType: AppConstants.typeMatic,
          propulsionType: AppConstants.propulsionGasoline,
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'VEH-001'),
        ),
      );
    });

    test('Empty brand throws VEH-002', () {
      expect(
        () => AppValidators.validateMotorcycle(
          nickname: 'Vario',
          brand: '',
          model: '160',
          motorcycleType: AppConstants.typeMatic,
          propulsionType: AppConstants.propulsionGasoline,
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'VEH-002'),
        ),
      );
    });

    test('Future year throws VEH-003', () {
      expect(
        () => AppValidators.validateMotorcycle(
          nickname: 'Vario',
          brand: 'Honda',
          model: '160',
          motorcycleType: AppConstants.typeMatic,
          propulsionType: AppConstants.propulsionGasoline,
          manufactureYear: DateTime.now().year + 5,
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'VEH-003'),
        ),
      );
    });

    test('Negative initial odometer throws ODO-001', () {
      expect(
        () => AppValidators.validateMotorcycle(
          nickname: 'Vario',
          brand: 'Honda',
          model: '160',
          motorcycleType: AppConstants.typeMatic,
          propulsionType: AppConstants.propulsionGasoline,
          currentOdometer: -10,
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'ODO-001'),
        ),
      );
    });

    test('Valid motorcycle passes', () {
      expect(
        () => AppValidators.validateMotorcycle(
          nickname: 'Si Merah',
          brand: 'Honda',
          model: 'Vario 160',
          motorcycleType: AppConstants.typeMatic,
          propulsionType: AppConstants.propulsionGasoline,
          manufactureYear: 2022,
          currentOdometer: 12000,
        ),
        returnsNormally,
      );
    });
  });

  group('Odometer Validation Tests', () {
    test('Negative odometer throws ODO-001', () {
      expect(
        () => AppValidators.validateOdometerReading(
          odometerKm: -1,
          readingDate: DateTime.now(),
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'ODO-001'),
        ),
      );
    });

    test('Future reading date throws ODO-003', () {
      expect(
        () => AppValidators.validateOdometerReading(
          odometerKm: 5000,
          readingDate: DateTime.now().add(const Duration(days: 2)),
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'ODO-003'),
        ),
      );
    });

    test('Lower odometer than latest without correction throws ODO-002', () {
      expect(
        () => AppValidators.validateOdometerReading(
          odometerKm: 4000,
          readingDate: DateTime.now(),
          latestKm: 5000,
          isCorrection: false,
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'ODO-002'),
        ),
      );
    });

    test('Lower odometer with correction and reason succeeds', () {
      expect(
        () => AppValidators.validateOdometerReading(
          odometerKm: 4000,
          readingDate: DateTime.now(),
          latestKm: 5000,
          isCorrection: true,
          correctionReason: 'Salah catat angka sebelumnya',
        ),
        returnsNormally,
      );
    });

    test('Correction without reason throws ODO-004', () {
      expect(
        () => AppValidators.validateOdometerReading(
          odometerKm: 4000,
          readingDate: DateTime.now(),
          latestKm: 5000,
          isCorrection: true,
          correctionReason: '   ',
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'ODO-004'),
        ),
      );
    });
  });

  group('Maintenance Schedule Validation Tests', () {
    test('Empty name throws MNT-004', () {
      expect(
        () => AppValidators.validateMaintenanceSchedule(
          name: '',
          intervalKm: 2000,
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'MNT-004'),
        ),
      );
    });

    test('No intervals provided throws MNT-001', () {
      expect(
        () => AppValidators.validateMaintenanceSchedule(
          name: 'Oli Mesin',
          intervalKm: null,
          intervalMonths: null,
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'MNT-001'),
        ),
      );
    });

    test('Interval <= 0 throws MNT-002', () {
      expect(
        () => AppValidators.validateMaintenanceSchedule(
          name: 'Oli Mesin',
          intervalKm: 0,
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'MNT-002'),
        ),
      );
    });
  });

  group('Service Record Validation Tests', () {
    test('Future service date throws SRV-003', () {
      expect(
        () => AppValidators.validateServiceRecord(
          serviceDate: DateTime.now().add(const Duration(days: 3)),
          odometerKm: 10000,
          items: [
            {'itemName': 'Ganti Oli', 'itemCost': 50000},
          ],
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'SRV-003'),
        ),
      );
    });

    test('Empty items throws SRV-001', () {
      expect(
        () => AppValidators.validateServiceRecord(
          serviceDate: DateTime.now(),
          odometerKm: 10000,
          items: [],
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'SRV-001'),
        ),
      );
    });

    test('Negative item cost throws SRV-002', () {
      expect(
        () => AppValidators.validateServiceRecord(
          serviceDate: DateTime.now(),
          odometerKm: 10000,
          items: [
            {'itemName': 'Ganti Oli', 'itemCost': -5000},
          ],
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'SRV-002'),
        ),
      );
    });

    test('Duplicate linked schedule ID throws SRV-006', () {
      expect(
        () => AppValidators.validateServiceRecord(
          serviceDate: DateTime.now(),
          odometerKm: 10000,
          items: [
            {
              'itemName': 'Ganti Oli Mesin Bagian 1',
              'itemCost': 50000,
              'maintenanceScheduleId': 'sched_1',
            },
            {
              'itemName': 'Ganti Oli Mesin Bagian 2',
              'itemCost': 30000,
              'maintenanceScheduleId': 'sched_1',
            },
          ],
        ),
        throwsA(
          isA<ValidationException>().having((e) => e.code, 'code', 'SRV-006'),
        ),
      );
    });
  });
}
