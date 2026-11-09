import 'package:drift/drift.dart';

import 'motorcycles_table.dart';

@DataClassName('ServiceRecordRow')
class ServiceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get motorcycleId =>
      text().references(Motorcycles, #id, onDelete: KeyAction.cascade)();
  TextColumn get serviceDate => text()(); // YYYY-MM-DD
  IntColumn get odometerKm => integer()();
  TextColumn get workshopName => text().nullable()();
  IntColumn get additionalCost => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
