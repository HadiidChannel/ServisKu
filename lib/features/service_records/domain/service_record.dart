import 'service_attachment.dart';
import 'service_record_item.dart';

class ServiceRecord {
  final String id;
  final String motorcycleId;
  final DateTime serviceDate;
  final int odometerKm;
  final String? workshopName;
  final int additionalCost;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ServiceRecordItem> items;
  final List<ServiceAttachment> attachments;

  const ServiceRecord({
    required this.id,
    required this.motorcycleId,
    required this.serviceDate,
    required this.odometerKm,
    this.workshopName,
    this.additionalCost = 0,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
    this.attachments = const [],
  });

  int get itemsTotalCost {
    return items.fold<int>(0, (sum, item) => sum + item.itemCost);
  }

  int get totalCost {
    return itemsTotalCost + additionalCost;
  }

  String get itemsSummary {
    if (items.isEmpty) return 'Tidak ada pekerjaan';
    if (items.length == 1) return items.first.itemName;
    if (items.length == 2) {
      return '${items[0].itemName}, ${items[1].itemName}';
    }
    return '${items[0].itemName}, ${items[1].itemName} (+${items.length - 2} lainnya)';
  }

  ServiceRecord copyWith({
    String? id,
    String? motorcycleId,
    DateTime? serviceDate,
    int? odometerKm,
    String? workshopName,
    int? additionalCost,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ServiceRecordItem>? items,
    List<ServiceAttachment>? attachments,
  }) {
    return ServiceRecord(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      serviceDate: serviceDate ?? this.serviceDate,
      odometerKm: odometerKm ?? this.odometerKm,
      workshopName: workshopName ?? this.workshopName,
      additionalCost: additionalCost ?? this.additionalCost,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
      attachments: attachments ?? this.attachments,
    );
  }
}
