import 'package:drift/drift.dart';
import 'motorcycles_table.dart';
import 'service_records_table.dart';

@DataClassName('OdometerReadingRow')
class OdometerReadings extends Table {
  TextColumn get id => text()();
  TextColumn get motorcycleId => text().references(
        Motorcycles,
        #id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get odometerKm => integer()();
  TextColumn get readingDate => text()(); // YYYY-MM-DD
  TextColumn get source => text()(); // manual, service, initial, correction
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get serviceRecordId => text().nullable().references(
        ServiceRecords,
        #id,
        onDelete: KeyAction.cascade,
      )();

  @override
  Set<Column> get primaryKey => {id};
}
