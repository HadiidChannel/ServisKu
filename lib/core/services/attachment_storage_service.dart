import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../errors/app_exceptions.dart';

class AttachmentValidationResult {
  final bool isValid;
  final String? mimeType;
  final String? errorMessage;

  const AttachmentValidationResult({
    required this.isValid,
    this.mimeType,
    this.errorMessage,
  });
}

class StoredAttachmentResult {
  final String localPath;
  final String fileName;
  final String mimeType;
  final int fileSize;

  const StoredAttachmentResult({
    required this.localPath,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
  });
}

class AttachmentCleanupResult {
  final int deletedCount;
  final int alreadyMissingCount;
  final int failedCount;
  final List<String> failedPaths;

  const AttachmentCleanupResult({
    this.deletedCount = 0,
    this.alreadyMissingCount = 0,
    this.failedCount = 0,
    this.failedPaths = const [],
  });

  static const empty = AttachmentCleanupResult();

  bool get isComplete => failedCount == 0;
  bool get hasDeletions => deletedCount > 0;

  AttachmentCleanupResult merge(AttachmentCleanupResult other) {
    return AttachmentCleanupResult(
      deletedCount: deletedCount + other.deletedCount,
      alreadyMissingCount: alreadyMissingCount + other.alreadyMissingCount,
      failedCount: failedCount + other.failedCount,
      failedPaths: [...failedPaths, ...other.failedPaths],
    );
  }
}

class _ValidationPayload {
  final bool isValid;
  final String? mimeType;
  final String? errorMessage;

  const _ValidationPayload({
    required this.isValid,
    this.mimeType,
    this.errorMessage,
  });
}

_ValidationPayload _validateImageIsolate(Uint8List bytes) {
  if (bytes.length < 4) {
    return const _ValidationPayload(
      isValid: false,
      errorMessage: 'Format foto tidak dapat digunakan.',
    );
  }

  String? mimeType;
  if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
    mimeType = 'image/jpeg';
  } else if (bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47) {
    mimeType = 'image/png';
  } else {
    return const _ValidationPayload(
      isValid: false,
      errorMessage: 'Format foto tidak didukung. Gunakan format JPG atau PNG.',
    );
  }

  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    return const _ValidationPayload(
      isValid: false,
      errorMessage: 'Foto rusak atau tidak dapat didekode.',
    );
  }

  return _ValidationPayload(
    isValid: true,
    mimeType: mimeType,
  );
}

class _ProcessImageRequest {
  final Uint8List imageBytes;
  final String mimeType;
  final int maxDimension;
  final int maxOutputBytes;

  const _ProcessImageRequest({
    required this.imageBytes,
    required this.mimeType,
    required this.maxDimension,
    required this.maxOutputBytes,
  });
}

class _ProcessImageResult {
  final Uint8List processedBytes;
  final Uint8List? thumbBytes;
  final String outputMimeType;
  final String outputExtension;

  const _ProcessImageResult({
    required this.processedBytes,
    this.thumbBytes,
    required this.outputMimeType,
    required this.outputExtension,
  });
}

_ProcessImageResult _processImageIsolate(_ProcessImageRequest request) {
  final decoded = img.decodeImage(request.imageBytes);
  if (decoded == null) {
    final ext = request.mimeType == 'image/png' ? '.png' : '.jpg';
    return _ProcessImageResult(
      processedBytes: request.imageBytes,
      outputMimeType: request.mimeType,
      outputExtension: ext,
    );
  }

  img.Image working = decoded;
  final int maxDim = request.maxDimension;
  if (working.width > maxDim || working.height > maxDim) {
    if (working.width >= working.height) {
      working = img.copyResize(working, width: maxDim);
    } else {
      working = img.copyResize(working, height: maxDim);
    }
  }

  Uint8List outBytes;
  String outMime = request.mimeType;
  String outExt = request.mimeType == 'image/png' ? '.png' : '.jpg';

  if (request.mimeType == 'image/png') {
    outBytes = Uint8List.fromList(img.encodePng(working));
    if (outBytes.length > request.maxOutputBytes) {
      outMime = 'image/jpeg';
      outExt = '.jpg';
      int quality = 85;
      outBytes = Uint8List.fromList(img.encodeJpg(working, quality: quality));
      while (outBytes.length > request.maxOutputBytes && quality > 40) {
        quality -= 15;
        outBytes = Uint8List.fromList(img.encodeJpg(working, quality: quality));
      }
    }
  } else {
    int quality = 85;
    outBytes = Uint8List.fromList(img.encodeJpg(working, quality: quality));
    while (outBytes.length > request.maxOutputBytes && quality > 40) {
      quality -= 15;
      outBytes = Uint8List.fromList(img.encodeJpg(working, quality: quality));
    }
  }

  // Strict enforcement: if still exceeds maxOutputBytes, iteratively downscale
  while (outBytes.length > request.maxOutputBytes &&
      working.width > 400 &&
      working.height > 400) {
    final newWidth = (working.width * 0.8).round();
    final newHeight = (working.height * 0.8).round();
    working = img.copyResize(working, width: newWidth, height: newHeight);
    outMime = 'image/jpeg';
    outExt = '.jpg';
    outBytes = Uint8List.fromList(img.encodeJpg(working, quality: 50));
  }

  Uint8List? thumbBytes;
  try {
    final thumb = img.copyResize(working, width: 300);
    if (outMime == 'image/png') {
      thumbBytes = Uint8List.fromList(img.encodePng(thumb));
    } else {
      thumbBytes = Uint8List.fromList(img.encodeJpg(thumb, quality: 75));
    }
  } catch (_) {}

  return _ProcessImageResult(
    processedBytes: outBytes,
    thumbBytes: thumbBytes,
    outputMimeType: outMime,
    outputExtension: outExt,
  );
}

class AttachmentStorageService {
  final Directory? _customBaseDir;
  final _uuid = const Uuid();

  static const int maxSourceSizeBytes = 15 * 1024 * 1024; // 15MB
  static const int maxOutputSizeBytes = 2 * 1024 * 1024; // 2MB
  static const int maxDimensionPixels = 1920;

  static bool _isCleanupRunning = false;

  AttachmentStorageService({Directory? baseDirectory})
      : _customBaseDir = baseDirectory;

  static String getThumbnailPath(String localPath) {
    final dir = p.dirname(localPath);
    final ext = p.extension(localPath);
    final base = p.basenameWithoutExtension(localPath);
    return p.join(dir, '${base}_thumb$ext');
  }

  bool _isSafePath(String targetPath, Directory baseDir) {
    final normTarget = p.normalize(p.absolute(targetPath));
    final normBase = p.normalize(p.absolute(baseDir.path));
    return p.equals(normBase, normTarget) || p.isWithin(normBase, normTarget);
  }

  Future<Directory> _getAttachmentsBaseDir() async {
    final custom = _customBaseDir;
    if (custom != null) {
      if (!await custom.exists()) {
        await custom.create(recursive: true);
      }
      return custom;
    }
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docsDir.path, 'attachments'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<AttachmentValidationResult> validateImageFileAsync(File file) async {
    if (!await file.exists()) {
      return const AttachmentValidationResult(
        isValid: false,
        errorMessage: 'Foto tidak dapat dibuka. Pilih foto lain.',
      );
    }

    try {
      final length = await file.length();
      if (length > maxSourceSizeBytes) {
        return const AttachmentValidationResult(
          isValid: false,
          errorMessage:
              'Ukuran foto maksimal 15MB. Pilih foto yang lebih kecil.',
        );
      }

      final bytes = await file.readAsBytes();
      final payload = await compute(_validateImageIsolate, bytes);
      return AttachmentValidationResult(
        isValid: payload.isValid,
        mimeType: payload.mimeType,
        errorMessage: payload.errorMessage,
      );
    } catch (_) {
      return const AttachmentValidationResult(
        isValid: false,
        errorMessage: 'Gagal memvalidasi foto.',
      );
    }
  }

  AttachmentValidationResult validateImageFile(File file) {
    if (!file.existsSync()) {
      return const AttachmentValidationResult(
        isValid: false,
        errorMessage: 'Foto tidak dapat dibuka. Pilih foto lain.',
      );
    }

    try {
      final length = file.lengthSync();
      if (length > maxSourceSizeBytes) {
        return const AttachmentValidationResult(
          isValid: false,
          errorMessage:
              'Ukuran foto maksimal 15MB. Pilih foto yang lebih kecil.',
        );
      }

      final bytes = file.readAsBytesSync();
      final payload = _validateImageIsolate(bytes);
      return AttachmentValidationResult(
        isValid: payload.isValid,
        mimeType: payload.mimeType,
        errorMessage: payload.errorMessage,
      );
    } catch (e) {
      return const AttachmentValidationResult(
        isValid: false,
        errorMessage: 'Gagal memvalidasi foto.',
      );
    }
  }

  Future<StoredAttachmentResult> saveAttachment({
    required String serviceRecordId,
    required File sourceFile,
    required String originalName,
  }) async {
    final validation = await validateImageFileAsync(sourceFile);
    if (!validation.isValid) {
      throw AttachmentException(
          'ATT-001', validation.errorMessage ?? 'Format foto tidak valid.');
    }

    try {
      final baseDir = await _getAttachmentsBaseDir();
      final recordDir = Directory(p.join(baseDir.path, serviceRecordId));
      if (!_isSafePath(recordDir.path, baseDir)) {
        throw const AttachmentException(
            'ATT-004', 'Lokasi penyimpanan tidak aman.');
      }
      if (!await recordDir.exists()) {
        await recordDir.create(recursive: true);
      }

      final sourceBytes = await sourceFile.readAsBytes();
      final processResult = await compute(
        _processImageIsolate,
        _ProcessImageRequest(
          imageBytes: sourceBytes,
          mimeType: validation.mimeType!,
          maxDimension: maxDimensionPixels,
          maxOutputBytes: maxOutputSizeBytes,
        ),
      );

      if (processResult.processedBytes.length > maxOutputSizeBytes) {
        throw const AttachmentException(
          'ATT-002',
          'Ukuran berkas foto melebihi batas 2MB setelah kompresi.',
        );
      }

      final attachmentId = _uuid.v4();
      final ext = processResult.outputExtension;
      final targetPath = p.join(recordDir.path, '$attachmentId$ext');

      if (!_isSafePath(targetPath, baseDir)) {
        throw const AttachmentException(
            'ATT-004', 'Lokasi penyimpanan tidak aman.');
      }

      final savedFile = File(targetPath);
      await savedFile.writeAsBytes(processResult.processedBytes);
      final fileSize = processResult.processedBytes.length;

      if (processResult.thumbBytes != null) {
        final thumbPath = p.join(recordDir.path, '${attachmentId}_thumb$ext');
        if (_isSafePath(thumbPath, baseDir)) {
          try {
            await File(thumbPath).writeAsBytes(processResult.thumbBytes!);
          } catch (_) {}
        }
      }

      return StoredAttachmentResult(
        localPath: targetPath,
        fileName:
            originalName.isNotEmpty ? originalName : 'Nota_$attachmentId$ext',
        mimeType: processResult.outputMimeType,
        fileSize: fileSize,
      );
    } catch (e) {
      if (e is AttachmentException) rethrow;
      throw const AttachmentException(
          'ATT-003', 'Gagal menyalin foto ke penyimpanan.');
    }
  }

  Future<AttachmentCleanupResult> deleteAttachmentFile(String localPath) async {
    int deleted = 0;
    int missing = 0;
    int failed = 0;
    final failedList = <String>[];

    try {
      final baseDir = await _getAttachmentsBaseDir();
      if (!_isSafePath(localPath, baseDir)) {
        return AttachmentCleanupResult(
          failedCount: 1,
          failedPaths: [localPath],
        );
      }
      final file = File(localPath);
      if (await file.exists()) {
        try {
          await file.delete();
          deleted++;
        } catch (_) {
          failed++;
          failedList.add(localPath);
        }
      } else {
        missing++;
      }

      // Also delete thumbnail if exists
      final dir = p.dirname(localPath);
      final ext = p.extension(localPath);
      final base = p.basenameWithoutExtension(localPath);
      final thumbPath = p.join(dir, '${base}_thumb$ext');
      if (_isSafePath(thumbPath, baseDir)) {
        final thumbFile = File(thumbPath);
        if (await thumbFile.exists()) {
          try {
            await thumbFile.delete();
            deleted++;
          } catch (_) {
            failed++;
            failedList.add(thumbPath);
          }
        }
      }
    } catch (_) {
      failed++;
      failedList.add(localPath);
    }

    return AttachmentCleanupResult(
      deletedCount: deleted,
      alreadyMissingCount: missing,
      failedCount: failed,
      failedPaths: failedList,
    );
  }

  Future<AttachmentCleanupResult> deleteRecordAttachmentsDirectory(
      String serviceRecordId) async {
    try {
      final baseDir = await _getAttachmentsBaseDir();
      final recordDir = Directory(p.join(baseDir.path, serviceRecordId));
      if (!_isSafePath(recordDir.path, baseDir)) {
        return AttachmentCleanupResult(
          failedCount: 1,
          failedPaths: [recordDir.path],
        );
      }
      if (await recordDir.exists()) {
        try {
          await recordDir.delete(recursive: true);
          return const AttachmentCleanupResult(deletedCount: 1);
        } catch (_) {
          return AttachmentCleanupResult(
            failedCount: 1,
            failedPaths: [recordDir.path],
          );
        }
      }
      return const AttachmentCleanupResult(alreadyMissingCount: 1);
    } catch (_) {
      return AttachmentCleanupResult(
        failedCount: 1,
        failedPaths: [serviceRecordId],
      );
    }
  }

  /// Thread-safe wrapper for running orphan cleanup during startup/lifecycle.
  Future<AttachmentCleanupResult> runStartupOrphanCleanup(
      Set<String> activePaths) async {
    if (_isCleanupRunning) return AttachmentCleanupResult.empty;
    _isCleanupRunning = true;
    try {
      return await cleanupOrphanAttachments(activePaths);
    } finally {
      _isCleanupRunning = false;
    }
  }

  /// Scans attachments directory and removes files that are not referenced in `activePaths`
  /// or corresponding active thumbnails. Also removes empty directories.
  Future<AttachmentCleanupResult> cleanupOrphanAttachments(
      Set<String> activePaths) async {
    int deletedCount = 0;
    int failedCount = 0;
    final failedPaths = <String>[];

    try {
      final baseDir = await _getAttachmentsBaseDir();
      if (!await baseDir.exists()) return AttachmentCleanupResult.empty;

      final normalizedActivePaths =
          activePaths.map((pStr) => p.normalize(pStr)).toSet();

      final entities = await baseDir.list(recursive: true).toList();
      for (final entity in entities) {
        if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          if (ext != '.jpg' && ext != '.png' && ext != '.jpeg') continue;

          final normalized = p.normalize(entity.path);
          final isDirectActive = normalizedActivePaths.contains(normalized);

          // Check if this file is a thumbnail of an active path
          bool isThumbnailOfActive = false;
          if (normalized.contains('_thumb')) {
            final baseName = p.basenameWithoutExtension(normalized);
            final origBaseName = baseName.replaceAll('_thumb', '');
            final origExt = p.extension(normalized);
            final expectedOrigPath =
                p.join(p.dirname(normalized), '$origBaseName$origExt');
            isThumbnailOfActive =
                normalizedActivePaths.contains(p.normalize(expectedOrigPath));
          }

          if (!isDirectActive && !isThumbnailOfActive) {
            try {
              await entity.delete();
              deletedCount++;
            } catch (_) {
              failedCount++;
              failedPaths.add(entity.path);
            }
          }
        }
      }

      // Clean up empty directories
      final dirs = await baseDir.list().toList();
      for (final dir in dirs) {
        if (dir is Directory) {
          final contents = await dir.list().toList();
          if (contents.isEmpty) {
            try {
              await dir.delete();
            } catch (_) {}
          }
        }
      }
    } catch (_) {
      failedCount++;
    }

    return AttachmentCleanupResult(
      deletedCount: deletedCount,
      failedCount: failedCount,
      failedPaths: failedPaths,
    );
  }

  Future<AttachmentCleanupResult> cleanupAllAttachments() async {
    try {
      final baseDir = await _getAttachmentsBaseDir();
      if (await baseDir.exists()) {
        try {
          await baseDir.delete(recursive: true);
          return const AttachmentCleanupResult(deletedCount: 1);
        } catch (_) {
          return AttachmentCleanupResult(
            failedCount: 1,
            failedPaths: [baseDir.path],
          );
        }
      }
      return const AttachmentCleanupResult(alreadyMissingCount: 1);
    } catch (_) {
      return const AttachmentCleanupResult(failedCount: 1);
    }
  }
}
