import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:servis/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  group('Database Migration v1 to v2 Tests', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('servisku_mig_');
      dbFile = File(p.join(tempDir.path, 'test_v1.sqlite'));
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
        'Safely migrates schema and backfills unambiguous service records while preserving ambiguous and manual readings',
        () async {
      // 1. Create a SQLite database file with schema version 1 using sqlite3 directly
      final rawDb = sqlite3.open(dbFile.path);

      // Create v1 tables manually (schema v1 had NO service_record_id column on odometer_readings)
      rawDb.execute('''
        CREATE TABLE motorcycles (
          id TEXT NOT NULL PRIMARY KEY,
          nickname TEXT NOT NULL,
          brand TEXT NOT NULL,
          model TEXT NOT NULL,
          motorcycle_type TEXT NOT NULL,
          propulsion_type TEXT NOT NULL DEFAULT 'gasoline',
          manufacture_year INTEGER,
          license_plate TEXT,
          notes TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      rawDb.execute('''
        CREATE TABLE odometer_readings (
          id TEXT NOT NULL PRIMARY KEY,
          motorcycle_id TEXT NOT NULL REFERENCES motorcycles(id) ON DELETE CASCADE,
          odometer_km INTEGER NOT NULL,
          reading_date TEXT NOT NULL,
          source TEXT NOT NULL DEFAULT 'manual',
          notes TEXT,
          created_at TEXT NOT NULL
        );
      ''');

      rawDb.execute('''
        CREATE TABLE service_records (
          id TEXT NOT NULL PRIMARY KEY,
          motorcycle_id TEXT NOT NULL REFERENCES motorcycles(id) ON DELETE CASCADE,
          service_date TEXT NOT NULL,
          odometer_km INTEGER NOT NULL,
          workshop_name TEXT,
          additional_cost INTEGER NOT NULL DEFAULT 0,
          notes TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      rawDb.execute('''
        CREATE TABLE maintenance_schedules (
          id TEXT NOT NULL PRIMARY KEY,
          motorcycle_id TEXT NOT NULL REFERENCES motorcycles(id) ON DELETE CASCADE,
          name TEXT NOT NULL,
          category TEXT,
          interval_km INTEGER,
          interval_months INTEGER,
          last_done_km INTEGER,
          last_done_date TEXT,
          manual_last_done_km INTEGER,
          manual_last_done_date TEXT,
          reminder_lead_km INTEGER,
          reminder_lead_days INTEGER,
          is_active INTEGER NOT NULL DEFAULT 1,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      rawDb.execute('''
        CREATE TABLE service_record_items (
          id TEXT NOT NULL PRIMARY KEY,
          service_record_id TEXT NOT NULL REFERENCES service_records(id) ON DELETE CASCADE,
          maintenance_schedule_id TEXT REFERENCES maintenance_schedules(id) ON DELETE SET NULL,
          item_name TEXT NOT NULL,
          category TEXT,
          item_cost INTEGER NOT NULL DEFAULT 0,
          notes TEXT
        );
      ''');

      rawDb.execute('''
        CREATE TABLE service_attachments (
          id TEXT NOT NULL PRIMARY KEY,
          service_record_id TEXT NOT NULL REFERENCES service_records(id) ON DELETE CASCADE,
          local_path TEXT NOT NULL,
          file_name TEXT NOT NULL,
          mime_type TEXT NOT NULL,
          file_size INTEGER NOT NULL,
          created_at TEXT NOT NULL
        );
      ''');

      rawDb.execute('''
        CREATE TABLE app_settings (
          key TEXT NOT NULL PRIMARY KEY,
          value TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      rawDb.execute('''
        CREATE TABLE notification_jobs (
          id TEXT NOT NULL PRIMARY KEY,
          maintenance_schedule_id TEXT NOT NULL REFERENCES maintenance_schedules(id) ON DELETE CASCADE,
          cycle_key TEXT NOT NULL,
          trigger_type TEXT NOT NULL,
          platform_notification_id INTEGER NOT NULL,
          planned_at TEXT,
          state TEXT NOT NULL DEFAULT 'scheduled',
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      // Set user_version to 1
      rawDb.execute('PRAGMA user_version = 1;');

      // 2. Insert test data into v1 database
      final nowStr = DateTime.now().toIso8601String();

      // Motorcycle
      rawDb.execute('''
        INSERT INTO motorcycles (id, nickname, brand, model, motorcycle_type, created_at, updated_at)
        VALUES ('motor-1', 'Vario Hitam', 'Honda', 'Vario 160', 'matic', '$nowStr', '$nowStr');
      ''');

      // Case A: Unambiguous Service Record (1 service record, 1 odometer reading on same date & km)
      rawDb.execute('''
        INSERT INTO service_records (id, motorcycle_id, service_date, odometer_km, workshop_name, created_at, updated_at)
        VALUES ('sr-unambiguous', 'motor-1', '2026-03-01', 5000, 'AHASS 001', '$nowStr', '$nowStr');
      ''');
      rawDb.execute('''
        INSERT INTO odometer_readings (id, motorcycle_id, odometer_km, reading_date, source, created_at)
        VALUES ('odo-unambiguous', 'motor-1', 5000, '2026-03-01', 'service', '$nowStr');
      ''');

      // Case B: Ambiguous Service Records (2 service records with exact same motorcycle, date & km)
      rawDb.execute('''
        INSERT INTO service_records (id, motorcycle_id, service_date, odometer_km, workshop_name, created_at, updated_at)
        VALUES ('sr-ambiguous-1', 'motor-1', '2026-03-15', 5500, 'Bengkel A', '$nowStr', '$nowStr');
      ''');
      rawDb.execute('''
        INSERT INTO service_records (id, motorcycle_id, service_date, odometer_km, workshop_name, created_at, updated_at)
        VALUES ('sr-ambiguous-2', 'motor-1', '2026-03-15', 5500, 'Bengkel B', '$nowStr', '$nowStr');
      ''');
      rawDb.execute('''
        INSERT INTO odometer_readings (id, motorcycle_id, odometer_km, reading_date, source, created_at)
        VALUES ('odo-ambiguous', 'motor-1', 5500, '2026-03-15', 'service', '$nowStr');
      ''');

      // Case C: Manual Odometer Reading (source = 'manual', should never be backfilled)
      rawDb.execute('''
        INSERT INTO odometer_readings (id, motorcycle_id, odometer_km, reading_date, source, created_at)
        VALUES ('odo-manual', 'motor-1', 6000, '2026-03-20', 'manual', '$nowStr');
      ''');

      rawDb.close();

      // 3. Open AppDatabase on the file to trigger onUpgrade (from 1 to 2)
      final appDb = AppDatabase(NativeDatabase(dbFile));
      await appDb.customSelect('SELECT COUNT(*) FROM motorcycles;').get();

      // Verify schema version is upgraded to 2
      final versionResult =
          await appDb.customSelect('PRAGMA user_version;').getSingle();
      expect(versionResult.read<int>('user_version'), equals(2));

      // 4. Verify backfill results
      final rows = await appDb
          .customSelect(
              'SELECT id, service_record_id, source FROM odometer_readings ORDER BY id;')
          .get();

      final odoMap = {for (var r in rows) r.read<String>('id'): r};

      // Unambiguous service record: successfully backfilled!
      expect(
        odoMap['odo-unambiguous']!.read<String?>('service_record_id'),
        equals('sr-unambiguous'),
      );

      // Ambiguous service record: left NULL because multiple candidate service records exist
      expect(
        odoMap['odo-ambiguous']!.read<String?>('service_record_id'),
        null,
      );

      // Manual reading: left NULL because source is manual
      expect(
        odoMap['odo-manual']!.read<String?>('service_record_id'),
        null,
      );

      // Verify index on service_record_id exists
      final indexCheck = await appDb
          .customSelect(
              "SELECT name FROM sqlite_master WHERE type='index' AND name='idx_odometer_service_record';")
          .get();
      expect(indexCheck, isNotEmpty);

      await appDb.close();
    });
  });
}
