import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servis/core/constants/app_constants.dart';
import 'package:servis/core/services/attachment_storage_service.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/maintenance/data/maintenance_repository.dart';
import 'package:servis/features/motorcycles/data/motorcycle_repository.dart';
import 'package:servis/features/reports/data/report_repository.dart';
import 'package:servis/features/reports/domain/expense_summary.dart';
import 'package:servis/features/service_records/data/service_record_repository.dart';

void main() {
  late AppDatabase db;
  late MotorcycleRepository motorcycleRepo;
  late MaintenanceRepository maintenanceRepo;
  late ServiceRecordRepository serviceRepo;
  late ReportRepository reportRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    motorcycleRepo = MotorcycleRepository(db);
    maintenanceRepo = MaintenanceRepository(db);
    serviceRepo = ServiceRecordRepository(
      db: db,
      attachmentService: AttachmentStorageService(),
      maintenanceRepository: maintenanceRepo,
    );
    reportRepo = ReportRepository(db: db, serviceRecordRepository: serviceRepo);
  });

  tearDown(() async {
    await db.close();
  });

  group('ReportRepository Unit Tests', () {
    test(
      'Calculates report summary, category breakdown, and date filtering',
      () async {
        final motorId = await motorcycleRepo.createMotorcycle(
          nickname: 'Vario',
          brand: 'Honda',
          model: 'Vario',
          motorcycleType: 'matic',
          propulsionType: 'gasoline',
          initialOdometerKm: 1000,
          initialReadingDate: DateTime(2026, 1, 1),
        );

        // Record 1: May 15, 2026
        await serviceRepo.createRecord(
          motorcycleId: motorId,
          serviceDate: DateTime(2026, 5, 15),
          odometerKm: 2000,
          workshopName: 'AHASS',
          additionalCost: 10000,
          items: [
            {
              'itemName': 'Oli Mesin',
              'category': 'Pelumasan',
              'itemCost': 60000,
            },
            {'itemName': 'Busi', 'category': 'Pengapian', 'itemCost': 30000},
          ],
        );

        // Record 2: June 20, 2026
        await serviceRepo.createRecord(
          motorcycleId: motorId,
          serviceDate: DateTime(2026, 6, 20),
          odometerKm: 4000,
          workshopName: 'Mandiri Motor',
          additionalCost: 5000,
          items: [
            {
              'itemName': 'Kampas Rem',
              'category': 'Pengereman',
              'itemCost': 55000,
            },
          ],
        );

        // Custom report encompassing both
        final summary = await reportRepo.getReportSummary(
          motorcycleId: motorId,
          period: ReportPeriod.custom,
          customStartDate: DateTime(2026, 5, 1),
          customEndDate: DateTime(2026, 6, 30),
        );

        // Total: (60000 + 30000 + 10000) + (55000 + 5000) = 100000 + 60000 = 160000
        expect(summary.totalCost, 160000);
        expect(summary.serviceCount, 2);

        // Categories should include Pelumasan, Pengapian, Pengereman, and Biaya tambahan
        final categories = summary.categoryBreakdown
            .map((c) => c.category)
            .toList();
        expect(categories, contains('Pelumasan'));
        expect(categories, contains('Pengapian'));
        expect(categories, contains('Pengereman'));
        expect(categories, contains(AppConstants.categoryAdditionalCost));

        final addCostCat = summary.categoryBreakdown.firstWhere(
          (c) => c.category == AppConstants.categoryAdditionalCost,
        );
        expect(addCostCat.totalCost, 15000); // 10000 + 5000

        // Inclusive start date test: start exactly on May 15
        final summaryMay15 = await reportRepo.getReportSummary(
          motorcycleId: motorId,
          period: ReportPeriod.custom,
          customStartDate: DateTime(2026, 5, 15),
          customEndDate: DateTime(2026, 5, 15),
        );
        expect(summaryMay15.serviceCount, 1);
        expect(summaryMay15.totalCost, 100000);
      },
    );
  });
}
