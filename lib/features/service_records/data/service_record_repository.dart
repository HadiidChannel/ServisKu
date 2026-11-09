import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/formatters/app_formatters.dart';
import '../../../core/services/attachment_storage_service.dart';
import '../../../core/validators/app_validators.dart';
import '../../../database/app_database.dart';
import '../../maintenance/application/notification_reconciler.dart';
import '../../maintenance/data/maintenance_repository.dart';
import '../domain/service_attachment.dart';
import '../domain/service_record.dart';
import '../domain/service_record_item.dart';

class CreateServiceRecordResult {
  final String recordId;
  final int totalPhotosRequested;
  final int photosSavedSuccessfully;
  final List<String> attachmentErrors;

  const CreateServiceRecordResult({
    required this.recordId,
    this.totalPhotosRequested = 0,
    this.photosSavedSuccessfully = 0,
    this.attachmentErrors = const [],
  });

  bool get allAttachmentsSaved =>
      totalPhotosRequested == photosSavedSuccessfully;
}

class UpdateServiceRecordResult {
  final String recordId;
  final int totalPhotosRequested;
  final int photosSavedSuccessfully;
  final List<String> attachmentErrors;

  const UpdateServiceRecordResult({
    required this.recordId,
    this.totalPhotosRequested = 0,
    this.photosSavedSuccessfully = 0,
    this.attachmentErrors = const [],
  });

  bool get allAttachmentsSaved =>
      totalPhotosRequested == photosSavedSuccessfully;
}

class ServiceRecordRepository {
  final AppDatabase db;
  final AttachmentStorageService attachmentService;
  final MaintenanceRepository maintenanceRepository;
  final NotificationReconciler? notificationReconciler;
  final _uuid = const Uuid();

  ServiceRecordRepository({
    required this.db,
    required this.attachmentService,
    required this.maintenanceRepository,
    this.notificationReconciler,
  });

  ServiceRecord _toDomain(
    ServiceRecordRow row,
    List<ServiceRecordItemRow> itemRows,
    List<ServiceAttachmentRow> attachmentRows,
  ) {
    return ServiceRecord(
      id: row.id,
      motorcycleId: row.motorcycleId,
      serviceDate: AppFormatters.parseDateBusiness(row.serviceDate),
      odometerKm: row.odometerKm,
      workshopName: row.workshopName,
      additionalCost: row.additionalCost,
      notes: row.notes,
      createdAt: DateTime.parse(row.createdAt),
      updatedAt: DateTime.parse(row.updatedAt),
      items: itemRows
          .map((i) => ServiceRecordItem(
                id: i.id,
                serviceRecordId: i.serviceRecordId,
                maintenanceScheduleId: i.maintenanceScheduleId,
                itemName: i.itemName,
                category: i.category,
                itemCost: i.itemCost,
                notes: i.notes,
              ))
          .toList(),
      attachments: attachmentRows
          .map((a) => ServiceAttachment(
                id: a.id,
                serviceRecordId: a.serviceRecordId,
                localPath: a.localPath,
                fileName: a.fileName,
                mimeType: a.mimeType,
                fileSize: a.fileSize,
                createdAt: DateTime.parse(a.createdAt),
              ))
          .toList(),
    );
  }

  Stream<List<ServiceRecord>> watchRecords({String? motorcycleId}) {
    return db
        .customSelect(
          'SELECT 1',
          readsFrom: {
            db.serviceRecords,
            db.serviceRecordItems,
            db.serviceAttachments,
          },
        )
        .watch()
        .asyncMap((_) => getRecords(motorcycleId: motorcycleId));
  }

  Future<List<ServiceRecord>> getRecords({String? motorcycleId}) async {
    var query = db.select(db.serviceRecords);
    if (motorcycleId != null) {
      query = query..where((tbl) => tbl.motorcycleId.equals(motorcycleId));
    }
    query = query
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.serviceDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ]);

    final rows = await query.get();
    final records = <ServiceRecord>[];
    for (final row in rows) {
      final items = await (db.select(db.serviceRecordItems)
            ..where((tbl) => tbl.serviceRecordId.equals(row.id)))
          .get();
      final attachments = await (db.select(db.serviceAttachments)
            ..where((tbl) => tbl.serviceRecordId.equals(row.id)))
          .get();
      records.add(_toDomain(row, items, attachments));
    }
    return records;
  }

  Future<ServiceRecord?> getById(String id) async {
    final query = db.select(db.serviceRecords)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final items = await (db.select(db.serviceRecordItems)
          ..where((tbl) => tbl.serviceRecordId.equals(row.id)))
        .get();
    final attachments = await (db.select(db.serviceAttachments)
          ..where((tbl) => tbl.serviceRecordId.equals(row.id)))
        .get();

    return _toDomain(row, items, attachments);
  }

  Future<CreateServiceRecordResult> createRecord({
    required String motorcycleId,
    required DateTime serviceDate,
    required int odometerKm,
    String? workshopName,
    int additionalCost = 0,
    String? notes,
    required List<Map<String, dynamic>> items,
    List<File>? photoFiles,
  }) async {
    AppValidators.validateServiceRecord(
      serviceDate: serviceDate,
      odometerKm: odometerKm,
      items: items,
      additionalCost: additionalCost,
    );

    // Validate that all referenced schedules belong to the motorcycle
    final affectedScheduleIds = <String>{};
    for (final item in items) {
      final scheduleId = item['maintenanceScheduleId'] as String?;
      if (scheduleId != null && scheduleId.isNotEmpty) {
        final schedule = await maintenanceRepository.getById(scheduleId);
        if (schedule == null || schedule.motorcycleId != motorcycleId) {
          throw const ValidationException(
            'SRV-004',
            'Jadwal yang dipilih tidak sesuai dengan kendaraan servis.',
          );
        }
        affectedScheduleIds.add(scheduleId);
      }
    }

    // Validate odometer chronology against existing readings for this motorcycle
    final existingOdoRows = await (db.select(db.odometerReadings)
          ..where((tbl) => tbl.motorcycleId.equals(motorcycleId)))
        .get();
    final chronologyItems = existingOdoRows
        .map((r) => OdometerChronologyItem(
              id: r.id,
              readingDate: AppFormatters.parseDateBusiness(r.readingDate),
              odometerKm: r.odometerKm,
              createdAt: DateTime.parse(r.createdAt),
              source: r.source,
            ))
        .toList();

    AppValidators.validateOdometerChronology(
      odometerKm: odometerKm,
      readingDate: serviceDate,
      existingReadings: chronologyItems,
    );

    final recordId = _uuid.v4();
    final nowIso = DateTime.now().toIso8601String();
    final serviceDateStr = AppFormatters.formatDateBusiness(serviceDate);

    // Save record, items, and linked odometer reading atomically in a transaction
    await db.transaction(() async {
      await db.into(db.serviceRecords).insert(
            ServiceRecordsCompanion.insert(
              id: recordId,
              motorcycleId: motorcycleId,
              serviceDate: serviceDateStr,
              odometerKm: odometerKm,
              workshopName: Value(workshopName?.trim()),
              additionalCost: Value(additionalCost),
              notes: Value(notes?.trim()),
              createdAt: nowIso,
              updatedAt: nowIso,
            ),
          );

      for (final item in items) {
        final itemId = _uuid.v4();
        await db.into(db.serviceRecordItems).insert(
              ServiceRecordItemsCompanion.insert(
                id: itemId,
                serviceRecordId: recordId,
                maintenanceScheduleId:
                    Value(item['maintenanceScheduleId'] as String?),
                itemName: (item['itemName'] as String).trim(),
                category: Value((item['category'] as String?)?.trim()),
                itemCost: Value(item['itemCost'] as int? ?? 0),
                notes: Value((item['notes'] as String?)?.trim()),
              ),
            );
      }

      // Record odometer reading from service with explicit link to serviceRecordId
      await db.into(db.odometerReadings).insert(
            OdometerReadingsCompanion.insert(
              id: _uuid.v4(),
              motorcycleId: motorcycleId,
              odometerKm: odometerKm,
              readingDate: serviceDateStr,
              source: AppConstants.odoSourceService,
              serviceRecordId: Value(recordId),
              notes: Value(workshopName != null && workshopName.isNotEmpty
                  ? 'Servis di $workshopName'
                  : 'Kunjungan servis'),
              createdAt: nowIso,
            ),
          );

      // Recalculate affected schedules without immediate reconciler triggers inside transaction
      for (final scheduleId in affectedScheduleIds) {
        await maintenanceRepository.recalculateSchedule(scheduleId,
            triggerReconcile: false);
      }
    });

    // Save attachments after database commit and track success/failures
    int photosSaved = 0;
    final totalPhotos = photoFiles?.length ?? 0;
    final attachmentErrors = <String>[];

    if (photoFiles != null && photoFiles.isNotEmpty) {
      for (final file in photoFiles) {
        StoredAttachmentResult? stored;
        try {
          stored = await attachmentService.saveAttachment(
            serviceRecordId: recordId,
            sourceFile: file,
            originalName: file.uri.pathSegments.last,
          );

          try {
            await db.into(db.serviceAttachments).insert(
                  ServiceAttachmentsCompanion.insert(
                    id: _uuid.v4(),
                    serviceRecordId: recordId,
                    localPath: stored.localPath,
                    fileName: stored.fileName,
                    mimeType: stored.mimeType,
                    fileSize: stored.fileSize,
                    createdAt: DateTime.now().toIso8601String(),
                  ),
                );
            photosSaved++;
          } catch (dbErr) {
            // Clean up copied physical file if metadata insertion fails
            await attachmentService.deleteAttachmentFile(stored.localPath);
            attachmentErrors.add('Gagal mencatat metadata foto kuitansi.');
          }
        } catch (storageErr) {
          attachmentErrors.add('Gagal memproses berkas foto kuitansi.');
        }
      }
    }

    if (notificationReconciler != null) {
      await notificationReconciler!.reconcileAll();
    }

    return CreateServiceRecordResult(
      recordId: recordId,
      totalPhotosRequested: totalPhotos,
      photosSavedSuccessfully: photosSaved,
      attachmentErrors: attachmentErrors,
    );
  }

  Future<UpdateServiceRecordResult> updateRecord({
    required String recordId,
    required String motorcycleId,
    required DateTime serviceDate,
    required int odometerKm,
    String? workshopName,
    int additionalCost = 0,
    String? notes,
    required List<Map<String, dynamic>> items,
    List<File>? newPhotoFiles,
    List<String>? deletedAttachmentIds,
  }) async {
    AppValidators.validateServiceRecord(
      serviceDate: serviceDate,
      odometerKm: odometerKm,
      items: items,
      additionalCost: additionalCost,
    );

    // Verify existing service record and protect motorcycle relationship invariant
    final existingRecord = await (db.select(db.serviceRecords)
          ..where((tbl) => tbl.id.equals(recordId)))
        .getSingleOrNull();
    if (existingRecord == null) {
      throw const ValidationException(
        'SRV-404',
        'Catatan servis tidak ditemukan.',
      );
    }
    if (existingRecord.motorcycleId != motorcycleId) {
      throw const ValidationException(
        'SRV-007',
        'Sepeda motor tidak dapat diubah pada catatan servis yang sudah tersimpan.',
      );
    }

    // Collect all schedule IDs that were previously linked
    final oldItems = await (db.select(db.serviceRecordItems)
          ..where((tbl) => tbl.serviceRecordId.equals(recordId)))
        .get();
    final affectedScheduleIds = <String>{};
    for (final oi in oldItems) {
      if (oi.maintenanceScheduleId != null) {
        affectedScheduleIds.add(oi.maintenanceScheduleId!);
      }
    }

    // Validate new item schedules
    for (final item in items) {
      final scheduleId = item['maintenanceScheduleId'] as String?;
      if (scheduleId != null && scheduleId.isNotEmpty) {
        final schedule = await maintenanceRepository.getById(scheduleId);
        if (schedule == null || schedule.motorcycleId != motorcycleId) {
          throw const ValidationException(
            'SRV-004',
            'Jadwal yang dipilih tidak sesuai dengan kendaraan servis.',
          );
        }
        affectedScheduleIds.add(scheduleId);
      }
    }

    // Find linked odometer reading and validate chronological integrity
    final existingOdo = await (db.select(db.odometerReadings)
          ..where((tbl) => tbl.serviceRecordId.equals(recordId)))
        .getSingleOrNull();

    final existingOdoRows = await (db.select(db.odometerReadings)
          ..where((tbl) => tbl.motorcycleId.equals(motorcycleId)))
        .get();
    final chronologyItems = existingOdoRows
        .map((r) => OdometerChronologyItem(
              id: r.id,
              readingDate: AppFormatters.parseDateBusiness(r.readingDate),
              odometerKm: r.odometerKm,
              createdAt: DateTime.parse(r.createdAt),
              source: r.source,
            ))
        .toList();

    AppValidators.validateOdometerChronology(
      odometerKm: odometerKm,
      readingDate: serviceDate,
      existingReadings: chronologyItems,
      currentReadingId: existingOdo?.id,
    );

    final nowIso = DateTime.now().toIso8601String();
    final serviceDateStr = AppFormatters.formatDateBusiness(serviceDate);

    await db.transaction(() async {
      await (db.update(db.serviceRecords)
            ..where((tbl) => tbl.id.equals(recordId)))
          .write(
        ServiceRecordsCompanion(
          serviceDate: Value(serviceDateStr),
          odometerKm: Value(odometerKm),
          workshopName: Value(workshopName?.trim()),
          additionalCost: Value(additionalCost),
          notes: Value(notes?.trim()),
          updatedAt: Value(nowIso),
        ),
      );

      // Update linked odometer reading
      final existingOdo = await (db.select(db.odometerReadings)
            ..where((tbl) => tbl.serviceRecordId.equals(recordId)))
          .getSingleOrNull();

      if (existingOdo != null) {
        await (db.update(db.odometerReadings)
              ..where((tbl) => tbl.id.equals(existingOdo.id)))
            .write(
          OdometerReadingsCompanion(
            odometerKm: Value(odometerKm),
            readingDate: Value(serviceDateStr),
            notes: Value(workshopName != null && workshopName.isNotEmpty
                ? 'Servis di $workshopName'
                : 'Kunjungan servis'),
          ),
        );
      } else {
        await db.into(db.odometerReadings).insert(
              OdometerReadingsCompanion.insert(
                id: _uuid.v4(),
                motorcycleId: motorcycleId,
                odometerKm: odometerKm,
                readingDate: serviceDateStr,
                source: AppConstants.odoSourceService,
                serviceRecordId: Value(recordId),
                notes: Value(workshopName != null && workshopName.isNotEmpty
                    ? 'Servis di $workshopName'
                    : 'Kunjungan servis'),
                createdAt: nowIso,
              ),
            );
      }

      // Replace items
      await (db.delete(db.serviceRecordItems)
            ..where((tbl) => tbl.serviceRecordId.equals(recordId)))
          .go();

      for (final item in items) {
        final itemId = _uuid.v4();
        await db.into(db.serviceRecordItems).insert(
              ServiceRecordItemsCompanion.insert(
                id: itemId,
                serviceRecordId: recordId,
                maintenanceScheduleId:
                    Value(item['maintenanceScheduleId'] as String?),
                itemName: (item['itemName'] as String).trim(),
                category: Value((item['category'] as String?)?.trim()),
                itemCost: Value(item['itemCost'] as int? ?? 0),
                notes: Value((item['notes'] as String?)?.trim()),
              ),
            );
      }

      // Recalculate all affected schedules without immediate reconciler triggers inside transaction
      for (final scheduleId in affectedScheduleIds) {
        await maintenanceRepository.recalculateSchedule(scheduleId,
            triggerReconcile: false);
      }
    });

    // Handle deleted attachments
    if (deletedAttachmentIds != null && deletedAttachmentIds.isNotEmpty) {
      for (final attId in deletedAttachmentIds) {
        await deleteAttachment(attId);
      }
    }

    // Handle new attachments and track failures
    int photosSaved = 0;
    final totalPhotos = newPhotoFiles?.length ?? 0;
    final attachmentErrors = <String>[];

    if (newPhotoFiles != null && newPhotoFiles.isNotEmpty) {
      for (final file in newPhotoFiles) {
        StoredAttachmentResult? stored;
        try {
          stored = await attachmentService.saveAttachment(
            serviceRecordId: recordId,
            sourceFile: file,
            originalName: file.uri.pathSegments.last,
          );

          try {
            await db.into(db.serviceAttachments).insert(
                  ServiceAttachmentsCompanion.insert(
                    id: _uuid.v4(),
                    serviceRecordId: recordId,
                    localPath: stored.localPath,
                    fileName: stored.fileName,
                    mimeType: stored.mimeType,
                    fileSize: stored.fileSize,
                    createdAt: DateTime.now().toIso8601String(),
                  ),
                );
            photosSaved++;
          } catch (dbErr) {
            await attachmentService.deleteAttachmentFile(stored.localPath);
            attachmentErrors.add('Gagal mencatat metadata foto kuitansi.');
          }
        } catch (storageErr) {
          attachmentErrors.add('Gagal memproses berkas foto kuitansi.');
        }
      }
    }

    if (notificationReconciler != null) {
      await notificationReconciler!.reconcileAll();
    }

    return UpdateServiceRecordResult(
      recordId: recordId,
      totalPhotosRequested: totalPhotos,
      photosSavedSuccessfully: photosSaved,
      attachmentErrors: attachmentErrors,
    );
  }

  Future<void> deleteRecord(String id) async {
    // 1. Get attachments and linked schedules before deletion
    final attachments = await (db.select(db.serviceAttachments)
          ..where((tbl) => tbl.serviceRecordId.equals(id)))
        .get();
    final items = await (db.select(db.serviceRecordItems)
          ..where((tbl) => tbl.serviceRecordId.equals(id)))
        .get();

    final affectedScheduleIds = <String>{};
    for (final item in items) {
      if (item.maintenanceScheduleId != null) {
        affectedScheduleIds.add(item.maintenanceScheduleId!);
      }
    }

    // 2. Delete database record and linked odometer reading in transaction
    await db.transaction(() async {
      await (db.delete(db.odometerReadings)
            ..where((tbl) => tbl.serviceRecordId.equals(id)))
          .go();

      await (db.delete(db.serviceRecords)..where((tbl) => tbl.id.equals(id)))
          .go();

      // Recalculate schedules and restore baselines without immediate reconciler triggers inside transaction
      for (final scheduleId in affectedScheduleIds) {
        await maintenanceRepository.recalculateSchedule(scheduleId,
            triggerReconcile: false);
      }
    });

    // 3. Delete physical files after transaction commits
    for (final att in attachments) {
      await attachmentService.deleteAttachmentFile(att.localPath);
    }
    await attachmentService.deleteRecordAttachmentsDirectory(id);

    if (notificationReconciler != null) {
      await notificationReconciler!.reconcileAll();
    }
  }

  Future<void> deleteAttachment(String attachmentId) async {
    final attRow = await (db.select(db.serviceAttachments)
          ..where((tbl) => tbl.id.equals(attachmentId)))
        .getSingleOrNull();

    if (attRow != null) {
      await (db.delete(db.serviceAttachments)
            ..where((tbl) => tbl.id.equals(attachmentId)))
          .go();
      await attachmentService.deleteAttachmentFile(attRow.localPath);
    }
  }
}
