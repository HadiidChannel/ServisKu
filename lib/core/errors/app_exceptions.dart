class AppException implements Exception {
  final String code;
  final String message;

  const AppException(this.code, this.message);

  @override
  String toString() => '$code: $message';
}

class ValidationException extends AppException {
  const ValidationException(super.code, super.message);
}

class DatabaseException extends AppException {
  const DatabaseException(super.code, super.message);
}

class AttachmentException extends AppException {
  const AttachmentException(super.code, super.message);
}

class NotificationException extends AppException {
  const NotificationException(super.code, super.message);
}
