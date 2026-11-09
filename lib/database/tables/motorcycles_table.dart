import 'package:drift/drift.dart';

@DataClassName('MotorcycleRow')
class Motorcycles extends Table {
  TextColumn get id => text()();
  TextColumn get nickname => text()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  TextColumn get motorcycleType => text()(); // matic, bebek, sport
  IntColumn get manufactureYear => integer().nullable()();
  TextColumn get licensePlate => text().nullable()();
  TextColumn get propulsionType => text()(); // gasoline, electric
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
