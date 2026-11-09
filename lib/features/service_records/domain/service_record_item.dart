class ServiceRecordItem {
  final String id;
  final String serviceRecordId;
  final String? maintenanceScheduleId;
  final String itemName;
  final String? category;
  final int itemCost;
  final String? notes;

  const ServiceRecordItem({
    required this.id,
    required this.serviceRecordId,
    this.maintenanceScheduleId,
    required this.itemName,
    this.category,
    required this.itemCost,
    this.notes,
  });

  ServiceRecordItem copyWith({
    String? id,
    String? serviceRecordId,
    String? maintenanceScheduleId,
    String? itemName,
    String? category,
    int? itemCost,
    String? notes,
  }) {
    return ServiceRecordItem(
      id: id ?? this.id,
      serviceRecordId: serviceRecordId ?? this.serviceRecordId,
      maintenanceScheduleId:
          maintenanceScheduleId ?? this.maintenanceScheduleId,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      itemCost: itemCost ?? this.itemCost,
      notes: notes ?? this.notes,
    );
  }
}
