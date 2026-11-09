import 'package:drift/drift.dart';
import 'motorcycles_table.dart';

@DataClassName('MaintenanceScheduleRow')
class MaintenanceSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get motorcycleId => text().references(
        Motorcycles,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get name => text()();
  TextColumn get category => text().nullable()();
  IntColumn get intervalKm => integer().nullable()();
  IntColumn get intervalMonths => integer().nullable()();
  IntColumn get lastDoneKm => integer().nullable()();
  TextColumn get lastDoneDate => text().nullable()(); // YYYY-MM-DD
  IntColumn get manualLastDoneKm => integer().nullable()();
  TextColumn get manualLastDoneDate => text().nullable()(); // YYYY-MM-DD
  IntColumn get reminderLeadKm => integer().nullable()();
  IntColumn get reminderLeadDays => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
