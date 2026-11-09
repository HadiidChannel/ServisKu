class Motorcycle {
  final String id;
  final String nickname;
  final String brand;
  final String model;
  final String motorcycleType; // matic, bebek, sport
  final int? manufactureYear;
  final String? licensePlate;
  final String propulsionType; // gasoline, electric
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Derived current odometer from latest reading
  final int currentOdometerKm;
  final DateTime? lastOdometerUpdate;

  const Motorcycle({
    required this.id,
    required this.nickname,
    required this.brand,
    required this.model,
    required this.motorcycleType,
    this.manufactureYear,
    this.licensePlate,
    required this.propulsionType,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.currentOdometerKm = 0,
    this.lastOdometerUpdate,
  });

  String get typeLabel {
    switch (motorcycleType.toLowerCase()) {
      case 'matic':
        return 'Matic';
      case 'bebek':
        return 'Bebek';
      case 'sport':
        return 'Sport';
      default:
        return motorcycleType;
    }
  }

  String get propulsionLabel {
    switch (propulsionType.toLowerCase()) {
      case 'gasoline':
        return 'Bensin';
      case 'electric':
        return 'Listrik';
      default:
        return propulsionType;
    }
  }

  Motorcycle copyWith({
    String? id,
    String? nickname,
    String? brand,
    String? model,
    String? motorcycleType,
    int? manufactureYear,
    String? licensePlate,
    String? propulsionType,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? currentOdometerKm,
    DateTime? lastOdometerUpdate,
  }) {
    return Motorcycle(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      motorcycleType: motorcycleType ?? this.motorcycleType,
      manufactureYear: manufactureYear ?? this.manufactureYear,
      licensePlate: licensePlate ?? this.licensePlate,
      propulsionType: propulsionType ?? this.propulsionType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentOdometerKm: currentOdometerKm ?? this.currentOdometerKm,
      lastOdometerUpdate: lastOdometerUpdate ?? this.lastOdometerUpdate,
    );
  }
}
