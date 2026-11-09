import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/validators/app_validators.dart';
import '../../../database/app_database.dart';
import '../../maintenance/application/notification_reconciler.dart';
import '../domain/odometer_reading.dart';

class OdometerRepository {
  final AppDatabase db;
  final NotificationReconciler? notificationReconciler;
  final _uuid = const Uuid();

  OdometerRepository(this.db, {this.notificationReconciler});

  OdometerReading _toDomain(OdometerReadingRow row) {
    return OdometerReading(
      id: row.id,
      motorcycleId: row.motorcycleId,
      odometerKm: row.odometerKm,
      readingDate: AppFormatters.parseDateBusiness(row.readingDate),
      source: row.source,
      notes: row.notes,
      createdAt: DateTime.parse(row.createdAt),
      serviceRecordId: row.serviceRecordId,
    );
  }

  Stream<List<OdometerReading>> watchReadings(String motorcycleId) {
    final query = db.select(db.odometerReadings)
      ..where((tbl) => tbl.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.readingDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ]);

    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<OdometerReading>> getReadings(String motorcycleId) async {
    final query = db.select(db.odometerReadings)
      ..where((tbl) => tbl.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.readingDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ]);

    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  Future<OdometerReading?> getLatestReading(String motorcycleId) async {
    final query = db.select(db.odometerReadings)
      ..where((tbl) => tbl.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.readingDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ])
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row != null ? _toDomain(row) : null;
  }

  Future<void> addReading({
    required String motorcycleId,
    required int odometerKm,
    required DateTime readingDate,
    String source = AppConstants.odoSourceManual,
    String? notes,
    bool isCorrection = false,
  }) async {
    final existingReadings = await getReadings(motorcycleId);
    final chronologyItems = existingReadings
        .map((r) => OdometerChronologyItem(
              id: r.id,
              readingDate: r.readingDate,
              odometerKm: r.odometerKm,
              createdAt: r.createdAt,
              source: r.source,
            ))
        .toList();

    AppValidators.validateOdometerChronology(
      odometerKm: odometerKm,
      readingDate: readingDate,
      existingReadings: chronologyItems,
      isCorrection: isCorrection,
      correctionReason: notes,
    );

    final nowIso = DateTime.now().toIso8601String();
    final readingDateStr = AppFormatters.formatDateBusiness(readingDate);
    final readingSource =
        isCorrection ? AppConstants.odoSourceCorrection : source;

    await db.into(db.odometerReadings).insert(
          OdometerReadingsCompanion.insert(
            id: _uuid.v4(),
            motorcycleId: motorcycleId,
            odometerKm: odometerKm,
            readingDate: readingDateStr,
            source: readingSource,
            notes: Value(notes?.trim()),
            createdAt: nowIso,
          ),
        );

    // Reconcile notifications after odometer update
    if (notificationReconciler != null) {
      await notificationReconciler!.reconcileAll();
    }
  }
}
