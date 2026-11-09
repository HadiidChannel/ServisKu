class OdometerReading {
  final String id;
  final String motorcycleId;
  final int odometerKm;
  final DateTime readingDate;
  final String source; // manual, service, initial, correction
  final String? notes;
  final DateTime createdAt;
  final String? serviceRecordId;

  const OdometerReading({
    required this.id,
    required this.motorcycleId,
    required this.odometerKm,
    required this.readingDate,
    required this.source,
    this.notes,
    required this.createdAt,
    this.serviceRecordId,
  });

  String get sourceLabel {
    switch (source) {
      case 'manual':
        return 'Manual';
      case 'service':
        return 'Servis';
      case 'initial':
        return 'Awal';
      case 'correction':
        return 'Koreksi';
      default:
        return source;
    }
  }

  bool get isCorrection => source == 'correction';
}
