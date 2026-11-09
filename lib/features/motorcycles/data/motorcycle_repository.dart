import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/services/attachment_storage_service.dart';
import '../../../database/app_database.dart';
import '../../maintenance/application/notification_reconciler.dart';
import '../domain/motorcycle.dart';

class MotorcycleDeletionResult {
  final bool databaseSuccess;
  final bool notificationsCancelled;
  final bool attachmentsCleaned;
  final int affectedServiceRecordsCount;
  final String? errorMessage;

  const MotorcycleDeletionResult({
    required this.databaseSuccess,
    this.notificationsCancelled = true,
    required this.attachmentsCleaned,
    required this.affectedServiceRecordsCount,
    this.errorMessage,
  });
}

class MotorcycleRepository {
  final AppDatabase db;
  final NotificationReconciler? notificationReconciler;
  final AttachmentStorageService? attachmentService;
  final _uuid = const Uuid();

  MotorcycleRepository(
    this.db, {
    this.notificationReconciler,
    this.attachmentService,
  });

  Motorcycle _toDomain(
    MotorcycleRow row, {
    int currentOdometerKm = 0,
    DateTime? lastOdometerUpdate,
  }) {
    return Motorcycle(
      id: row.id,
      nickname: row.nickname,
      brand: row.brand,
      model: row.model,
      motorcycleType: row.motorcycleType,
      manufactureYear: row.manufactureYear,
      licensePlate: row.licensePlate,
      propulsionType: row.propulsionType,
      notes: row.notes,
      createdAt: DateTime.parse(row.createdAt),
      updatedAt: DateTime.parse(row.updatedAt),
      currentOdometerKm: currentOdometerKm,
      lastOdometerUpdate: lastOdometerUpdate,
    );
  }

  Future<int> _getLatestOdometerKm(String motorcycleId) async {
    final query = db.select(db.odometerReadings)
      ..where((tbl) => tbl.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.readingDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ])
      ..limit(1);

    final reading = await query.getSingleOrNull();
    return reading?.odometerKm ?? 0;
  }

  Future<DateTime?> _getLatestOdometerDate(String motorcycleId) async {
    final query = db.select(db.odometerReadings)
      ..where((tbl) => tbl.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.readingDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ])
      ..limit(1);

    final reading = await query.getSingleOrNull();
    return reading != null
        ? AppFormatters.parseDateBusiness(reading.readingDate)
        : null;
  }

  /// Observes both motorcycles and odometerReadings tables to ensure
  /// motorcycle lists and current odometer stats react immediately to any odometer change.
  Stream<List<Motorcycle>> watchAll() {
    return db
        .customSelect(
          'SELECT 1',
          readsFrom: {db.motorcycles, db.odometerReadings},
        )
        .watch()
        .asyncMap((_) => getAll());
  }

  Stream<Motorcycle?> watchById(String id) {
    return db
        .customSelect(
          'SELECT 1',
          readsFrom: {db.motorcycles, db.odometerReadings},
        )
        .watch()
        .asyncMap((_) => getById(id));
  }

  Future<List<Motorcycle>> getAll() async {
    final rows = await db.select(db.motorcycles).get();
    final list = <Motorcycle>[];
    for (final row in rows) {
      final currentKm = await _getLatestOdometerKm(row.id);
      final lastUpdate = await _getLatestOdometerDate(row.id);
      list.add(
        _toDomain(
          row,
          currentOdometerKm: currentKm,
          lastOdometerUpdate: lastUpdate,
        ),
      );
    }
    return list;
  }

  Future<Motorcycle?> getById(String id) async {
    final query = db.select(db.motorcycles)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final currentKm = await _getLatestOdometerKm(row.id);
    final lastUpdate = await _getLatestOdometerDate(row.id);
    return _toDomain(
      row,
      currentOdometerKm: currentKm,
      lastOdometerUpdate: lastUpdate,
    );
  }

  Future<String> createMotorcycle({
    required String nickname,
    required String brand,
    required String model,
    required String motorcycleType,
    int? manufactureYear,
    String? licensePlate,
    String propulsionType = AppConstants.propulsionGasoline,
    int initialOdometerKm = 0,
    String? notes,
    DateTime? initialReadingDate,
  }) async {
    final motorcycleId = _uuid.v4();
    final odoId = _uuid.v4();
    final nowIso = DateTime.now().toIso8601String();
    final readingDateTime = initialReadingDate ?? DateTime.now();
    final todayStr = AppFormatters.formatDateBusiness(readingDateTime);

    await db.transaction(() async {
      await db
          .into(db.motorcycles)
          .insert(
            MotorcyclesCompanion.insert(
              id: motorcycleId,
              nickname: nickname.trim(),
              brand: brand.trim(),
              model: model.trim(),
              motorcycleType: motorcycleType,
              manufactureYear: Value(manufactureYear),
              licensePlate: Value(licensePlate?.trim()),
              propulsionType: propulsionType,
              notes: Value(notes?.trim()),
              createdAt: nowIso,
              updatedAt: nowIso,
            ),
          );

      await db
          .into(db.odometerReadings)
          .insert(
            OdometerReadingsCompanion.insert(
              id: odoId,
              motorcycleId: motorcycleId,
              odometerKm: initialOdometerKm,
              readingDate: todayStr,
              source: AppConstants.odoSourceInitial,
              notes: const Value('Odometer awal saat penambahan motor'),
              createdAt: nowIso,
            ),
          );

      final existingActive =
          await (db.select(db.appSettings)..where(
                (tbl) => tbl.key.equals(AppConstants.keyActiveMotorcycleId),
              ))
              .getSingleOrNull();

      if (existingActive == null || existingActive.value.isEmpty) {
        await db
            .into(db.appSettings)
            .insertOnConflictUpdate(
              AppSettingsCompanion.insert(
                key: AppConstants.keyActiveMotorcycleId,
                value: motorcycleId,
                updatedAt: nowIso,
              ),
            );
      }
    });

    return motorcycleId;
  }

  Future<void> updateMotorcycle(Motorcycle motorcycle) async {
    final nowIso = DateTime.now().toIso8601String();
    await (db.update(
      db.motorcycles,
    )..where((tbl) => tbl.id.equals(motorcycle.id))).write(
      MotorcyclesCompanion(
        nickname: Value(motorcycle.nickname.trim()),
        brand: Value(motorcycle.brand.trim()),
        model: Value(motorcycle.model.trim()),
        motorcycleType: Value(motorcycle.motorcycleType),
        manufactureYear: Value(motorcycle.manufactureYear),
        licensePlate: Value(motorcycle.licensePlate?.trim()),
        propulsionType: Value(motorcycle.propulsionType),
        notes: Value(motorcycle.notes?.trim()),
        updatedAt: Value(nowIso),
      ),
    );
  }

  Future<MotorcycleDeletionResult> deleteMotorcycle(String id) async {
    // 1. Cancel all notifications for all schedules of this motorcycle before deleting database records
    if (notificationReconciler != null) {
      final cancelResult = await notificationReconciler!
          .cancelJobsForMotorcycle(id);
      if (!cancelResult.isSuccess) {
        return MotorcycleDeletionResult(
          databaseSuccess: false,
          notificationsCancelled: false,
          attachmentsCleaned: false,
          affectedServiceRecordsCount: 0,
          errorMessage:
              'Gagal membatalkan pengingat di sistem Android: ${cancelResult.errorMessage ?? 'Kesalahan platform'}. Penghapusan motor dibatalkan.',
        );
      }
    }

    // 2. Query all service records and attachments before database cascade deletes them
    final records = await (db.select(
      db.serviceRecords,
    )..where((tbl) => tbl.motorcycleId.equals(id))).get();
    final recordIds = records.map((r) => r.id).toList();

    List<ServiceAttachmentRow> attachments = [];
    if (recordIds.isNotEmpty) {
      attachments = await (db.select(
        db.serviceAttachments,
      )..where((tbl) => tbl.serviceRecordId.isIn(recordIds))).get();
    }

    // 3. Delete motorcycle and cascade records in transaction
    await db.transaction(() async {
      await (db.delete(db.motorcycles)..where((tbl) => tbl.id.equals(id))).go();

      // If active motorcycle was deleted, update active setting
      final activeSetting =
          await (db.select(db.appSettings)..where(
                (tbl) => tbl.key.equals(AppConstants.keyActiveMotorcycleId),
              ))
              .getSingleOrNull();

      if (activeSetting?.value == id) {
        final remaining = await db.select(db.motorcycles).get();
        if (remaining.isNotEmpty) {
          await (db.update(db.appSettings)..where(
                (tbl) => tbl.key.equals(AppConstants.keyActiveMotorcycleId),
              ))
              .write(
                AppSettingsCompanion(
                  value: Value(remaining.first.id),
                  updatedAt: Value(DateTime.now().toIso8601String()),
                ),
              );
        } else {
          await (db.delete(db.appSettings)..where(
                (tbl) => tbl.key.equals(AppConstants.keyActiveMotorcycleId),
              ))
              .go();
        }
      }
    });

    // 4. Clean up physical attachment files and directories
    bool attachmentsCleaned = true;
    for (final att in attachments) {
      final res = await attachmentService?.deleteAttachmentFile(att.localPath);
      if (res != null && !res.isComplete) {
        attachmentsCleaned = false;
      }
    }
    for (final rId in recordIds) {
      final res = await attachmentService?.deleteRecordAttachmentsDirectory(
        rId,
      );
      if (res != null && !res.isComplete) {
        attachmentsCleaned = false;
      }
    }

    return MotorcycleDeletionResult(
      databaseSuccess: true,
      notificationsCancelled: true,
      attachmentsCleaned: attachmentsCleaned,
      affectedServiceRecordsCount: records.length,
    );
  }
}
