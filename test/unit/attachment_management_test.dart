import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:servis/core/constants/app_constants.dart';
import 'package:servis/core/services/attachment_storage_service.dart';
import 'package:servis/database/app_database.dart';
import 'package:servis/features/maintenance/data/maintenance_repository.dart';
import 'package:servis/features/motorcycles/data/motorcycle_repository.dart';
import 'package:servis/features/service_records/data/service_record_repository.dart';

void main() {
  late AppDatabase db;
  late AttachmentStorageService attachmentService;
  late MotorcycleRepository motorcycleRepo;
  late MaintenanceRepository maintenanceRepo;
  late ServiceRecordRepository serviceRepo;
  late Directory tempDir;

  late Directory sourceDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('servisku_test_att_');
    sourceDir = await Directory.systemTemp.createTemp('servisku_test_src_');
    db = AppDatabase(NativeDatabase.memory());
    attachmentService = AttachmentStorageService(baseDirectory: tempDir);
    motorcycleRepo = MotorcycleRepository(db);
    maintenanceRepo = MaintenanceRepository(db);
    serviceRepo = ServiceRecordRepository(
      db: db,
      attachmentService: attachmentService,
      maintenanceRepository: maintenanceRepo,
    );
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
    if (await sourceDir.exists()) {
      await sourceDir.delete(recursive: true);
    }
  });

  File createTestImageFile(String name, {bool isPng = false}) {
    final image = img.Image(width: 20, height: 20);
    img.fill(image, color: img.ColorRgba8(255, 128, 0, 255));
    final bytes = isPng ? img.encodePng(image) : img.encodeJpg(image);
    final file = File('${sourceDir.path}/$name');
    file.writeAsBytesSync(bytes);
    return file;
  }

  group('Attachment Storage & Validation Tests', () {
    test('Validates valid JPEG image file successfully', () {
      final file = createTestImageFile('test.jpg', isPng: false);
      final result = attachmentService.validateImageFile(file);

      expect(result.isValid, isTrue);
      expect(result.mimeType, 'image/jpeg');
    });

    test('Validates valid PNG image file successfully', () {
      final file = createTestImageFile('test.png', isPng: true);
      final result = attachmentService.validateImageFile(file);

      expect(result.isValid, isTrue);
      expect(result.mimeType, 'image/png');
    });

    test('Rejects invalid non-image file with unsupported format message', () {
      final file = File('${tempDir.path}/test.txt');
      file.writeAsStringSync('This is not an image');

      final result = attachmentService.validateImageFile(file);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('Format foto tidak didukung'));
    });

    test('Rejects corrupted image bytes', () {
      final file = File('${tempDir.path}/corrupt.jpg');
      // Valid JPEG magic header bytes followed by corrupted trash
      file.writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x00, 0x00]);

      final result = attachmentService.validateImageFile(file);
      expect(result.isValid, isFalse);
    });

    test('Derives thumbnail path deterministically', () {
      const originalPath = '/app_docs/attachments/rec123/att456.jpg';
      final thumbPath = AttachmentStorageService.getThumbnailPath(originalPath);

      expect(thumbPath, contains('att456_thumb.jpg'));
    });

    test('Creates service record with photo attachment and enables individual deletion', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      final photo = createTestImageFile('receipt.jpg');

      final createResult = await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: DateTime.now(),
        odometerKm: 2000,
        items: [
          {'itemName': 'Oli Mesin', 'itemCost': 70000},
        ],
        photoFiles: [photo],
      );

      expect(createResult.allAttachmentsSaved, isTrue);
      expect(createResult.photosSavedSuccessfully, 1);

      final record = await serviceRepo.getById(createResult.recordId);
      expect(record, isNotNull);
      expect(record!.attachments.length, 1);

      final attId = record.attachments.first.id;
      final localFilePath = record.attachments.first.localPath;
      expect(File(localFilePath).existsSync(), isTrue);

      // Delete individual attachment
      await serviceRepo.deleteAttachment(attId);

      final updatedRecord = await serviceRepo.getById(createResult.recordId);
      expect(updatedRecord!.attachments, isEmpty);
      expect(File(localFilePath).existsSync(), isFalse);
    });

    test(
      'Deleting non-existent or already removed file does not throw or crash',
      () async {
        await attachmentService.deleteAttachmentFile(
          '/non_existent/path/photo.jpg',
        );
        await serviceRepo.deleteAttachment('non-existent-id');
      },
    );

    test(
      'updateRecord returns UpdateServiceRecordResult and adds new attachments',
      () async {
        final motorId = await motorcycleRepo.createMotorcycle(
          nickname: 'Vario',
          brand: 'Honda',
          model: 'Vario 160',
          motorcycleType: AppConstants.typeMatic,
          initialOdometerKm: 1000,
        );

        final createResult = await serviceRepo.createRecord(
          motorcycleId: motorId,
          serviceDate: DateTime.now(),
          odometerKm: 2000,
          items: [
            {'itemName': 'Oli Mesin', 'itemCost': 70000},
          ],
        );

        final photo1 = createTestImageFile('receipt1.jpg');
        final updateResult = await serviceRepo.updateRecord(
          recordId: createResult.recordId,
          motorcycleId: motorId,
          serviceDate: DateTime.now(),
          odometerKm: 2050,
          items: [
            {'itemName': 'Oli Mesin & Busi', 'itemCost': 100000},
          ],
          newPhotoFiles: [photo1],
        );

        expect(updateResult.allAttachmentsSaved, isTrue);
        expect(updateResult.photosSavedSuccessfully, equals(1));
        expect(updateResult.attachmentErrors, isEmpty);

        final record = await serviceRepo.getById(createResult.recordId);
        expect(record!.attachments.length, equals(1));
        expect(File(record.attachments.first.localPath).existsSync(), isTrue);
      },
    );

    test('cleanupOrphanAttachments removes orphan files while keeping active files and thumbnails', () async {
      final motorId = await motorcycleRepo.createMotorcycle(
        nickname: 'Vario',
        brand: 'Honda',
        model: 'Vario 160',
        motorcycleType: AppConstants.typeMatic,
        initialOdometerKm: 1000,
      );

      final photo = createTestImageFile('active_receipt.jpg');
      final createResult = await serviceRepo.createRecord(
        motorcycleId: motorId,
        serviceDate: DateTime.now(),
        odometerKm: 2000,
        items: [
          {'itemName': 'Oli Mesin', 'itemCost': 70000},
        ],
        photoFiles: [photo],
      );

      final record = (await serviceRepo.getById(createResult.recordId))!;
      final activePath = record.attachments.first.localPath;
      final thumbPath = AttachmentStorageService.getThumbnailPath(activePath);

      // Create an orphan file in the same directory
      final orphanFile = File('${tempDir.path}/${record.id}/orphan_image.jpg');
      orphanFile.writeAsBytesSync(photo.readAsBytesSync());
      expect(orphanFile.existsSync(), isTrue);

      // Run cleanup with active paths
      final activeSet = {activePath};
      final cleanupResult = await attachmentService.cleanupOrphanAttachments(
        activeSet,
      );

      expect(cleanupResult.deletedCount, equals(1));
      expect(cleanupResult.isComplete, isTrue);
      expect(orphanFile.existsSync(), isFalse);
      expect(File(activePath).existsSync(), isTrue);
      if (File(thumbPath).existsSync()) {
        expect(File(thumbPath).existsSync(), isTrue);
      }
    });

    test(
      'validateImageFileAsync validates in background isolate correctly',
      () async {
        final validFile = createTestImageFile('async_valid.png', isPng: true);
        final validResult = await attachmentService.validateImageFileAsync(
          validFile,
        );
        expect(validResult.isValid, isTrue);
        expect(validResult.mimeType, equals('image/png'));

        final nonExistent = File('${tempDir.path}/does_not_exist.jpg');
        final missingResult = await attachmentService.validateImageFileAsync(
          nonExistent,
        );
        expect(missingResult.isValid, isFalse);
      },
    );

    test('Rejects sibling directory prefix path traversal', () async {
      final evilDir = Directory('${tempDir.path}_evil');
      await evilDir.create();
      final evilFile = File('${evilDir.path}/secret.jpg');
      await evilFile.writeAsBytes([1, 2, 3]);

      final cleanupResult = await attachmentService.deleteAttachmentFile(
        evilFile.path,
      );
      expect(cleanupResult.isComplete, isFalse);
      expect(cleanupResult.failedCount, 1);
      expect(evilFile.existsSync(), isTrue);
      await evilDir.delete(recursive: true);
    });

    test(
      'AttachmentCleanupResult accurately reflects deleted and missing counts',
      () async {
        final missingResult = await attachmentService.deleteAttachmentFile(
          '${tempDir.path}/missing.jpg',
        );
        expect(missingResult.alreadyMissingCount, 1);
        expect(missingResult.deletedCount, 0);
        expect(missingResult.isComplete, isTrue);
      },
    );

    test(
      'Large PNG converted to JPEG outputs .jpg extension and image/jpeg MIME',
      () async {
        final motorId = await motorcycleRepo.createMotorcycle(
          nickname: 'Vario',
          brand: 'Honda',
          model: 'Vario 160',
          motorcycleType: AppConstants.typeMatic,
          initialOdometerKm: 1000,
        );

        final largeImg = img.Image(width: 900, height: 900);
        final rng = Random(42);
        for (int y = 0; y < 900; y++) {
          for (int x = 0; x < 900; x++) {
            largeImg.setPixelRgba(
              x,
              y,
              rng.nextInt(256),
              rng.nextInt(256),
              rng.nextInt(256),
              255,
            );
          }
        }
        final pngBytes = img.encodePng(largeImg);
        expect(pngBytes.length, greaterThan(2 * 1024 * 1024));

        final pngFile = File('${sourceDir.path}/large_receipt.png');
        pngFile.writeAsBytesSync(pngBytes);

        final createResult = await serviceRepo.createRecord(
          motorcycleId: motorId,
          serviceDate: DateTime.now(),
          odometerKm: 2000,
          items: [
            {'itemName': 'Servis Besar', 'itemCost': 200000},
          ],
          photoFiles: [pngFile],
        );

        final record = (await serviceRepo.getById(createResult.recordId))!;
        final att = record.attachments.first;
        expect(att.mimeType, 'image/jpeg');
        expect(att.localPath.endsWith('.jpg'), isTrue);
        expect(att.fileSize, lessThanOrEqualTo(2 * 1024 * 1024));
      },
    );
  });
}
