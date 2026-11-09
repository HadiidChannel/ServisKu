import 'package:drift/drift.dart';

import 'maintenance_schedules_table.dart';

@DataClassName('NotificationJobRow')
class NotificationJobs extends Table {
  TextColumn get id => text()();
  TextColumn get maintenanceScheduleId => text().references(
    MaintenanceSchedules,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get cycleKey => text()();
  TextColumn get triggerType => text()(); // date_due, km_soon, km_overdue
  IntColumn get platformNotificationId => integer()();
  TextColumn get plannedAt => text().nullable()(); // ISO 8601
  TextColumn get state => text()(); // scheduled, delivered, cancelled
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {maintenanceScheduleId, cycleKey, triggerType},
  ];
}
