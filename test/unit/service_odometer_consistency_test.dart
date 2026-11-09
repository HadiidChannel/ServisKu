import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/core/constants/app_constants.dart';
import 'package:servis/core/errors/app_exceptions.dart';
import 'package:servis/core/services/attachment_storage_service.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/maintenance/data/maintenance_repository.dart';
import 'package:servis/features/motorcycles/data/motorcycle_repository.dart';
import 'package:servis/features/odometer/data/odometer_repository.dart';
import 'package:servis/features/service_records/data/service_record_repository.dart';

void main() {
  late AppDatabase db;
  late MotorcycleRepository motorcycleRepo;
  late OdometerRepository odoRepo;
  late MaintenanceRepository maintenanceRepo;
  late ServiceRecordRepository serviceRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    motorcycleRepo = MotorcycleRepository(db);
    odoRepo = OdometerRepository(db);
    maintenanceRepo = MaintenanceRepository(db);
    serviceRepo = ServiceRecordRepository(
      db: db,
      attachmentService: AttachmentStorageService(),
      maintenanceRepository: maintenanceRepo,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Service Odometer Data Consistency Tests', () {
    test('Creating service record links odometer reading and updates latest odometer', () async {
      final today = DateTime.now();
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      final result = await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: today,
        odometerKm: 2500,
        workshopName: 'AHASS Pusat',
        items: [
          {'itemName': 'Ganti Oli', 'itemCost': 50000},
        ],
      );

      final readings = await odoRepo.getReadings(motorId);
      expect(readings.length, 2);

      final serviceReading = readings.firstWhere(
        (r) => r.serviceRecordId == result.recordId,
      );
      expect(serviceReading.odometerKm, 2500);
      expect(serviceReading.source, AppConstants.odoSourceService);
      expect(serviceReading.serviceRecordId, result.recordId);

      final motor = await motorcycleRepo.getById(motorId);
      expect(motor?.currentOdometerKm, 2500);
    });

    test('Editing service record updates linked odometer reading without creating duplicates', () async {
      final today = DateTime.now();
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      final result = await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: today,
        odometerKm: 2500,
        workshopName: 'AHASS',
        items: [
          {'itemName': 'Ganti Oli', 'itemCost': 50000},
        ],
      );

      // Update service record to 2800 km
      await serviceRepo.updateRecord(
        recordId: result.recordId,
        motorcycleId: motorId,
        serviceDate: today,
        odometerKm: 2800,
        workshopName: 'AHASS Bintang',
        items: [
          {'itemName': 'Ganti Oli Plus', 'itemCost': 60000},
        ],
      );

      final readings = await odoRepo.getReadings(motorId);
      expect(readings.length, 2); // Initial and updated service reading

      final updatedReading = readings.firstWhere(
        (r) => r.serviceRecordId == result.recordId,
      );
      expect(updatedReading.odometerKm, 2800);

      final motor = await motorcycleRepo.getById(motorId);
      expect(motor?.currentOdometerKm, 2800);
    });

    test('Deleting service record removes linked odometer reading and restores prior odometer', () async {
      final today = DateTime.now();
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      // Add manual reading at 1500 km
      await odoRepo.addReading(
        motorcycleId: motorId,
        odometerKm: 1500,
        readingDate: today,
      );

      // Add service record at 3000 km
      final result = await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: today,
        odometerKm: 3000,
        items: [
          {'itemName': 'Servis Rutin', 'itemCost': 100000},
        ],
      );

      var motor = await motorcycleRepo.getById(motorId);
      expect(motor?.currentOdometerKm, 3000);

      // Delete service record
      await serviceRepo.deleteRecord(result.recordId);

      // Odometer reading for service should be deleted
      final readings = await odoRepo.getReadings(motorId);
      expect(readings.length, 2); // Only initial (1000) and manual (1500)
      expect(
        readings.any((r) => r.serviceRecordId == result.recordId),
        isFalse,
      );

      // Current odometer reverts to latest manual reading (1500)
      motor = await motorcycleRepo.getById(motorId);
      expect(motor?.currentOdometerKm, 1500);
    });

    test('Historical service record does not overwrite newer manual reading', () async {
      final today = DateTime.now();
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
        initialReadingDate: twoDaysAgo,
      );

      // Manual reading today with 5000 km
      await odoRepo.addReading(
        motorcycleId: motorId,
        odometerKm: 5000,
        readingDate: today,
      );

      // User enters backlog/historical service visit from yesterday at 4200 km
      final yesterday = today.subtract(const Duration(days: 1));
      await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: yesterday,
        odometerKm: 4200,
        items: [
          {'itemName': 'Servis Lampau', 'itemCost': 50000},
        ],
      );

      // Latest chronological odometer must remain 5000 km from today
      final motor = await motorcycleRepo.getById(motorId);
      expect(motor?.currentOdometerKm, 5000);
    });

    test('Historical service record higher than subsequent initial reading is rejected', () async {
      final today = DateTime.now();
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 5000,
        initialReadingDate: today,
      );

      final yesterday = today.subtract(const Duration(days: 1));
      // Entering 6000 km on yesterday when today initial reading is 5000 km must be rejected
      expect(
        () => serviceRepo.createRecord(
          motorcycleId: motorId,
          serviceDate: yesterday,
          odometerKm: 6000,
          items: [
            {'itemName': 'Servis Lampau', 'itemCost': 50000},
          ],
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
