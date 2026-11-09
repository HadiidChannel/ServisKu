import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/app_settings_table.dart';
import 'tables/maintenance_schedules_table.dart';
import 'tables/motorcycles_table.dart';
import 'tables/notification_jobs_table.dart';
import 'tables/odometer_readings_table.dart';
import 'tables/service_attachments_table.dart';
import 'tables/service_record_items_table.dart';
import 'tables/service_records_table.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'servisku.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [
  Motorcycles,
  OdometerReadings,
  MaintenanceSchedules,
  ServiceRecords,
  ServiceRecordItems,
  ServiceAttachments,
  AppSettings,
  NotificationJobs,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.addColumn(odometerReadings, odometerReadings.serviceRecordId);
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_odometer_service_record ON odometer_readings (service_record_id);',
          );
          // Safe transactional backfill of service_record_id on legacy odometer_readings
          // where source = 'service' and the matching service_record is strictly unambiguous.
          // Ambiguous matches (multiple candidates) and non-service records remain NULL.
          await customStatement('''
            UPDATE odometer_readings
            SET service_record_id = (
              SELECT sr.id FROM service_records sr
              WHERE sr.motorcycle_id = odometer_readings.motorcycle_id
                AND sr.service_date = odometer_readings.reading_date
                AND sr.odometer_km = odometer_readings.odometer_km
            )
            WHERE source = 'service'
              AND (
                SELECT COUNT(*) FROM service_records sr
                WHERE sr.motorcycle_id = odometer_readings.motorcycle_id
                  AND sr.service_date = odometer_readings.reading_date
                  AND sr.odometer_km = odometer_readings.odometer_km
              ) = 1
              AND (
                SELECT COUNT(*) FROM odometer_readings o2
                WHERE o2.motorcycle_id = odometer_readings.motorcycle_id
                  AND o2.reading_date = odometer_readings.reading_date
                  AND o2.odometer_km = odometer_readings.odometer_km
                  AND o2.source = 'service'
              ) = 1;
          ''');
        }
      },
      onCreate: (m) async {
        await m.createAll();
        // Create indexes defined in FSD section 9.11 and schema v2
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_odometer_motorcycle_date ON odometer_readings (motorcycle_id, reading_date, created_at);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_odometer_service_record ON odometer_readings (service_record_id);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_maint_motorcycle_active ON maintenance_schedules (motorcycle_id, is_active);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_service_motorcycle_date ON service_records (motorcycle_id, service_date);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_items_service_record ON service_record_items (service_record_id);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_items_maintenance_schedule ON service_record_items (maintenance_schedule_id);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_attachments_service_record ON service_attachments (service_record_id);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_jobs_schedule_cycle ON notification_jobs (maintenance_schedule_id, cycle_key);',
        );
      },
    );
  }
}
