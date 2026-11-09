class ServiceAttachment {
  final String id;
  final String serviceRecordId;
  final String localPath;
  final String fileName;
  final String mimeType;
  final int fileSize;
  final DateTime createdAt;

  const ServiceAttachment({
    required this.id,
    required this.serviceRecordId,
    required this.localPath,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
    required this.createdAt,
  });
}
