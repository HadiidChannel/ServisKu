import '../errors/app_exceptions.dart';
import '../extensions/date_extensions.dart';

class OdometerChronologyItem {
  final String id;
  final DateTime readingDate;
  final int odometerKm;
  final DateTime createdAt;
  final String? source;

  const OdometerChronologyItem({
    required this.id,
    required this.readingDate,
    required this.odometerKm,
    required this.createdAt,
    this.source,
  });
}

class AppValidators {
  static void validateMotorcycle({
    required String nickname,
    required String brand,
    required String model,
    required String motorcycleType,
    required String propulsionType,
    int? manufactureYear,
    int? currentOdometer,
  }) {
    if (nickname.trim().isEmpty) {
      throw const ValidationException('VEH-001', 'Nama motor wajib diisi.');
    }
    if (brand.trim().isEmpty) {
      throw const ValidationException('VEH-002', 'Merek motor wajib diisi.');
    }
    if (model.trim().isEmpty) {
      throw const ValidationException('VEH-002', 'Model motor wajib diisi.');
    }
    if (manufactureYear != null) {
      final currentYear = DateTime.now().year;
      if (manufactureYear < 1950 || manufactureYear > currentYear) {
        throw const ValidationException(
            'VEH-003', 'Periksa kembali tahun produksi.');
      }
    }
    if (currentOdometer != null && currentOdometer < 0) {
      throw const ValidationException(
          'ODO-001', 'Masukkan kilometer yang valid.');
    }
  }

  static void validateOdometerReading({
    required int odometerKm,
    required DateTime readingDate,
    int? latestKm,
    bool isCorrection = false,
    String? correctionReason,
  }) {
    if (odometerKm < 0) {
      throw const ValidationException(
          'ODO-001', 'Masukkan kilometer yang valid.');
    }

    final today = DateTime.now().toDateOnly();
    if (readingDate.toDateOnly().isAfter(today)) {
      throw const ValidationException(
          'ODO-003', 'Tanggal pembacaan tidak boleh di masa depan.');
    }

    if (latestKm != null && odometerKm < latestKm && !isCorrection) {
      throw const ValidationException(
        'ODO-002',
        'Kilometer lebih rendah dari pembacaan terakhir. Periksa kembali atau gunakan koreksi odometer.',
      );
    }

    if (isCorrection &&
        (correctionReason == null || correctionReason.trim().isEmpty)) {
      throw const ValidationException('ODO-004', 'Alasan koreksi wajib diisi.');
    }
  }

  static void validateOdometerChronology({
    required int odometerKm,
    required DateTime readingDate,
    required List<OdometerChronologyItem> existingReadings,
    String? currentReadingId,
    bool isCorrection = false,
    String? correctionReason,
  }) {
    if (odometerKm < 0) {
      throw const ValidationException(
          'ODO-001', 'Masukkan kilometer yang valid.');
    }

    final today = DateTime.now().toDateOnly();
    if (readingDate.toDateOnly().isAfter(today)) {
      throw const ValidationException(
          'ODO-003', 'Tanggal pembacaan tidak boleh di masa depan.');
    }

    if (isCorrection) {
      if (correctionReason == null || correctionReason.trim().isEmpty) {
        throw const ValidationException(
            'ODO-004', 'Alasan koreksi wajib diisi.');
      }
      return;
    }

    final targetDate = readingDate.toDateOnly();

    final relevant = existingReadings
        .where((r) => currentReadingId == null || r.id != currentReadingId)
        .toList();

    // Group all readings by date without artificial source exemptions so
    // initial registration odometer acts as a valid chronological boundary.
    final readingsByDate = <DateTime, List<OdometerChronologyItem>>{};
    for (final item in relevant) {
      final itemDate = item.readingDate.toDateOnly();
      readingsByDate.putIfAbsent(itemDate, () => []).add(item);
    }

    for (final entry in readingsByDate.entries) {
      final itemDate = entry.key;
      final maxKmOnDate =
          entry.value.map((r) => r.odometerKm).reduce((a, b) => a > b ? a : b);
      final minKmOnDate =
          entry.value.map((r) => r.odometerKm).reduce((a, b) => a < b ? a : b);

      if (itemDate == targetDate) {
        if (odometerKm < maxKmOnDate) {
          throw const ValidationException(
            'ODO-002',
            'Kilometer lebih rendah dari pembacaan lain pada tanggal yang sama. Periksa kembali atau gunakan koreksi odometer.',
          );
        }
      } else if (itemDate.isBefore(targetDate)) {
        if (odometerKm < maxKmOnDate) {
          throw const ValidationException(
            'ODO-002',
            'Kilometer lebih rendah dari pembacaan pada tanggal sebelumnya. Periksa kembali atau gunakan koreksi odometer.',
          );
        }
      } else if (itemDate.isAfter(targetDate)) {
        if (odometerKm > minKmOnDate) {
          throw const ValidationException(
            'ODO-005',
            'Kilometer riwayat tidak boleh lebih besar dari pembacaan pada tanggal setelahnya.',
          );
        }
      }
    }
  }

  static void validateMaintenanceSchedule({
    required String name,
    int? intervalKm,
    int? intervalMonths,
    int? lastDoneKm,
    DateTime? lastDoneDate,
    int? reminderLeadKm,
    int? reminderLeadDays,
  }) {
    if (name.trim().isEmpty) {
      throw const ValidationException('MNT-004', 'Nama perawatan wajib diisi.');
    }

    final hasKm = intervalKm != null;
    final hasMonths = intervalMonths != null;

    if (!hasKm && !hasMonths) {
      throw const ValidationException(
        'MNT-001',
        'Isi interval kilometer, interval waktu, atau keduanya.',
      );
    }

    if (hasKm && intervalKm <= 0) {
      throw const ValidationException(
          'MNT-002', 'Interval kilometer harus lebih besar dari nol.');
    }

    if (hasMonths && intervalMonths <= 0) {
      throw const ValidationException(
          'MNT-002', 'Interval bulan harus lebih besar dari nol.');
    }

    if (lastDoneKm != null && lastDoneKm < 0) {
      throw const ValidationException(
          'MNT-005', 'Kilometer terakhir tidak boleh negatif.');
    }

    if (lastDoneDate != null) {
      final today = DateTime.now().toDateOnly();
      if (lastDoneDate.toDateOnly().isAfter(today)) {
        throw const ValidationException(
            'MNT-006', 'Tanggal terakhir dilakukan tidak boleh di masa depan.');
      }
    }

    if (reminderLeadKm != null && reminderLeadKm < 0) {
      throw const ValidationException(
          'MNT-007', 'Pengingat kilometer tidak boleh negatif.');
    }

    if (reminderLeadDays != null && reminderLeadDays < 0) {
      throw const ValidationException(
          'MNT-008', 'Pengingat hari tidak boleh negatif.');
    }
  }

  static void validateServiceRecord({
    required DateTime serviceDate,
    required int odometerKm,
    required List<Map<String, dynamic>> items,
    int additionalCost = 0,
  }) {
    final today = DateTime.now().toDateOnly();
    if (serviceDate.toDateOnly().isAfter(today)) {
      throw const ValidationException(
          'SRV-003', 'Tanggal servis tidak boleh berada di masa depan.');
    }

    if (odometerKm < 0) {
      throw const ValidationException(
          'ODO-001', 'Masukkan kilometer yang valid.');
    }

    if (items.isEmpty) {
      throw const ValidationException(
          'SRV-001', 'Tambahkan minimal satu pekerjaan servis.');
    }

    if (additionalCost < 0) {
      throw const ValidationException(
          'SRV-002', 'Biaya tidak boleh bernilai negatif.');
    }

    final Set<String> linkedScheduleIds = {};

    for (final item in items) {
      final name = (item['itemName'] as String?)?.trim() ?? '';
      if (name.isEmpty) {
        throw const ValidationException(
            'SRV-005', 'Nama pekerjaan servis wajib diisi.');
      }

      final cost = item['itemCost'] as int? ?? 0;
      if (cost < 0) {
        throw const ValidationException(
            'SRV-002', 'Biaya tidak boleh bernilai negatif.');
      }

      final scheduleId = item['maintenanceScheduleId'] as String?;
      if (scheduleId != null && scheduleId.isNotEmpty) {
        if (linkedScheduleIds.contains(scheduleId)) {
          throw const ValidationException(
            'SRV-006',
            'Satu jadwal perawatan tidak boleh dipilih lebih dari sekali dalam satu kunjungan servis.',
          );
        }
        linkedScheduleIds.add(scheduleId);
      }
    }
  }
}
