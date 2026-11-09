import 'package:drift/drift.dart';
import 'maintenance_schedules_table.dart';
import 'service_records_table.dart';

@DataClassName('ServiceRecordItemRow')
class ServiceRecordItems extends Table {
  TextColumn get id => text()();
  TextColumn get serviceRecordId => text().references(
        ServiceRecords,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get maintenanceScheduleId => text().nullable().references(
        MaintenanceSchedules,
        #id,
        onDelete: KeyAction.setNull,
      )();
  TextColumn get itemName => text()();
  TextColumn get category => text().nullable()();
  IntColumn get itemCost => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
