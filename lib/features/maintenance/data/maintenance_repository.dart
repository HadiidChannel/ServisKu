import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/validators/app_validators.dart';
import '../../../database/app_database.dart';
import '../application/notification_reconciler.dart';
import '../domain/maintenance_schedule.dart';

class MaintenanceRepository {
  final AppDatabase db;
  final NotificationReconciler? notificationReconciler;
  final _uuid = const Uuid();

  MaintenanceRepository(this.db, {this.notificationReconciler});

  MaintenanceSchedule _toDomain(MaintenanceScheduleRow row) {
    return MaintenanceSchedule(
      id: row.id,
      motorcycleId: row.motorcycleId,
      name: row.name,
      category: row.category,
      intervalKm: row.intervalKm,
      intervalMonths: row.intervalMonths,
      lastDoneKm: row.lastDoneKm,
      lastDoneDate: row.lastDoneDate != null
          ? AppFormatters.parseDateBusiness(row.lastDoneDate!)
          : null,
      manualLastDoneKm: row.manualLastDoneKm,
      manualLastDoneDate: row.manualLastDoneDate != null
          ? AppFormatters.parseDateBusiness(row.manualLastDoneDate!)
          : null,
      reminderLeadKm: row.reminderLeadKm,
      reminderLeadDays: row.reminderLeadDays,
      isActive: row.isActive,
      createdAt: DateTime.parse(row.createdAt),
      updatedAt: DateTime.parse(row.updatedAt),
    );
  }

  Stream<List<MaintenanceSchedule>> watchSchedules(String motorcycleId) {
    final query = db.select(db.maintenanceSchedules)
      ..where((tbl) => tbl.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.isActive),
        (tbl) => OrderingTerm.asc(tbl.name),
      ]);

    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<MaintenanceSchedule>> getSchedules(String motorcycleId) async {
    final query = db.select(db.maintenanceSchedules)
      ..where((tbl) => tbl.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.isActive),
        (tbl) => OrderingTerm.asc(tbl.name),
      ]);

    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  Future<MaintenanceSchedule?> getById(String id) async {
    final query = db.select(db.maintenanceSchedules)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toDomain(row) : null;
  }

  Future<String> createSchedule({
    required String motorcycleId,
    required String name,
    String? category,
    int? intervalKm,
    int? intervalMonths,
    int? lastDoneKm,
    DateTime? lastDoneDate,
    int? reminderLeadKm,
    int? reminderLeadDays,
    bool isActive = true,
  }) async {
    AppValidators.validateMaintenanceSchedule(
      name: name,
      intervalKm: intervalKm,
      intervalMonths: intervalMonths,
      lastDoneKm: lastDoneKm,
      lastDoneDate: lastDoneDate,
      reminderLeadKm: reminderLeadKm,
      reminderLeadDays: reminderLeadDays,
    );

    final scheduleId = _uuid.v4();
    final nowIso = DateTime.now().toIso8601String();
    final lastDoneDateStr = lastDoneDate != null
        ? AppFormatters.formatDateBusiness(lastDoneDate)
        : null;

    await db
        .into(db.maintenanceSchedules)
        .insert(
          MaintenanceSchedulesCompanion.insert(
            id: scheduleId,
            motorcycleId: motorcycleId,
            name: name.trim(),
            category: Value(category?.trim()),
            intervalKm: Value(intervalKm),
            intervalMonths: Value(intervalMonths),
            lastDoneKm: Value(lastDoneKm),
            lastDoneDate: Value(lastDoneDateStr),
            manualLastDoneKm: Value(lastDoneKm),
            manualLastDoneDate: Value(lastDoneDateStr),
            reminderLeadKm: Value(reminderLeadKm),
            reminderLeadDays: Value(reminderLeadDays),
            isActive: Value(isActive),
            createdAt: nowIso,
            updatedAt: nowIso,
          ),
        );

    if (notificationReconciler != null) {
      await notificationReconciler!.reconcileAll();
    }

    return scheduleId;
  }

  Future<void> updateSchedule(MaintenanceSchedule schedule) async {
    AppValidators.validateMaintenanceSchedule(
      name: schedule.name,
      intervalKm: schedule.intervalKm,
      intervalMonths: schedule.intervalMonths,
      lastDoneKm: schedule.lastDoneKm,
      lastDoneDate: schedule.lastDoneDate,
      reminderLeadKm: schedule.reminderLeadKm,
      reminderLeadDays: schedule.reminderLeadDays,
    );

    final nowIso = DateTime.now().toIso8601String();
    final lastDoneDateStr = schedule.lastDoneDate != null
        ? AppFormatters.formatDateBusiness(schedule.lastDoneDate!)
        : null;
    final manualDateStr = schedule.manualLastDoneDate != null
        ? AppFormatters.formatDateBusiness(schedule.manualLastDoneDate!)
        : null;

    await (db.update(
      db.maintenanceSchedules,
    )..where((tbl) => tbl.id.equals(schedule.id))).write(
      MaintenanceSchedulesCompanion(
        name: Value(schedule.name.trim()),
        category: Value(schedule.category?.trim()),
        intervalKm: Value(schedule.intervalKm),
        intervalMonths: Value(schedule.intervalMonths),
        lastDoneKm: Value(schedule.lastDoneKm),
        lastDoneDate: Value(lastDoneDateStr),
        manualLastDoneKm: Value(schedule.manualLastDoneKm),
        manualLastDoneDate: Value(manualDateStr),
        reminderLeadKm: Value(schedule.reminderLeadKm),
        reminderLeadDays: Value(schedule.reminderLeadDays),
        isActive: Value(schedule.isActive),
        updatedAt: Value(nowIso),
      ),
    );

    if (notificationReconciler != null) {
      await notificationReconciler!.reconcileAll();
    }
  }

  Future<void> toggleActive(String id, bool isActive) async {
    if (!isActive && notificationReconciler != null) {
      final cancelResult = await notificationReconciler!.cancelJobsForSchedule(
        id,
      );
      if (!cancelResult.isSuccess) {
        throw NotificationException(
          'NOT-002',
          'Gagal membatalkan pengingat di sistem Android: ${cancelResult.errorMessage ?? 'Kesalahan platform'}. Status jadwal tidak diubah.',
        );
      }
    }

    final nowIso = DateTime.now().toIso8601String();
    await (db.update(
      db.maintenanceSchedules,
    )..where((tbl) => tbl.id.equals(id))).write(
      MaintenanceSchedulesCompanion(
        isActive: Value(isActive),
        updatedAt: Value(nowIso),
      ),
    );

    if (isActive && notificationReconciler != null) {
      await notificationReconciler!.reconcileAll();
    }
  }

  Future<void> deleteSchedule(String id) async {
    // Cancel platform notifications and remove jobs before deleting database record
    if (notificationReconciler != null) {
      final cancelResult = await notificationReconciler!.cancelJobsForSchedule(
        id,
      );
      if (!cancelResult.isSuccess) {
        throw NotificationException(
          'NOT-002',
          'Gagal membatalkan pengingat di sistem Android: ${cancelResult.errorMessage ?? 'Kesalahan platform'}. Jadwal dipertahankan demi konsistensi data.',
        );
      }
    }

    await (db.delete(
      db.maintenanceSchedules,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Recalculates `lastDoneKm` and `lastDoneDate` for a schedule using its manual baseline
  /// and any valid service record items still linked to it.
  Future<void> recalculateSchedule(
    String scheduleId, {
    bool triggerReconcile = true,
  }) async {
    final scheduleRow = await (db.select(
      db.maintenanceSchedules,
    )..where((tbl) => tbl.id.equals(scheduleId))).getSingleOrNull();

    if (scheduleRow == null) return;

    // Find linked service items and their corresponding service records
    final query =
        db.select(db.serviceRecordItems).join([
            innerJoin(
              db.serviceRecords,
              db.serviceRecords.id.equalsExp(
                db.serviceRecordItems.serviceRecordId,
              ),
            ),
          ])
          ..where(
            db.serviceRecordItems.maintenanceScheduleId.equals(scheduleId),
          )
          ..orderBy([
            OrderingTerm.desc(db.serviceRecords.serviceDate),
            OrderingTerm.desc(db.serviceRecords.odometerKm),
          ]);

    final results = await query.get();

    int? resolvedKm = scheduleRow.manualLastDoneKm;
    String? resolvedDateStr = scheduleRow.manualLastDoneDate;

    if (results.isNotEmpty) {
      final latestRecord = results.first.readTable(db.serviceRecords);
      final recordDate = AppFormatters.parseDateBusiness(
        latestRecord.serviceDate,
      );
      final manualDate = resolvedDateStr != null
          ? AppFormatters.parseDateBusiness(resolvedDateStr)
          : null;

      // If service record is newer than or same as manual date, use it
      if (manualDate == null || !recordDate.isBefore(manualDate)) {
        resolvedKm = latestRecord.odometerKm;
        resolvedDateStr = latestRecord.serviceDate;
      }
    }

    final nowIso = DateTime.now().toIso8601String();
    await (db.update(
      db.maintenanceSchedules,
    )..where((tbl) => tbl.id.equals(scheduleId))).write(
      MaintenanceSchedulesCompanion(
        lastDoneKm: Value(resolvedKm),
        lastDoneDate: Value(resolvedDateStr),
        updatedAt: Value(nowIso),
      ),
    );

    if (triggerReconcile && notificationReconciler != null) {
      await notificationReconciler!.reconcileAll();
    }
  }
}
