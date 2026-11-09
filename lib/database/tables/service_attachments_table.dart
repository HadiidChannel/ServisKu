import 'package:drift/drift.dart';

import 'service_records_table.dart';

@DataClassName('ServiceAttachmentRow')
class ServiceAttachments extends Table {
  TextColumn get id => text()();
  TextColumn get serviceRecordId =>
      text().references(ServiceRecords, #id, onDelete: KeyAction.cascade)();
  TextColumn get localPath => text()();
  TextColumn get fileName => text()();
  TextColumn get mimeType => text()();
  IntColumn get fileSize => integer()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
