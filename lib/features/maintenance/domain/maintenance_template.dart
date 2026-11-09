class MaintenanceTemplate {
  final String name;
  final String category;
  final int? defaultIntervalKm;
  final int? defaultIntervalMonths;
  final int defaultLeadKm;
  final int defaultLeadDays;
  final List<String> applicableMotorcycleTypes; // matic, bebek, sport, all
  final bool applicableForElectric;

  const MaintenanceTemplate({
    required this.name,
    required this.category,
    this.defaultIntervalKm,
    this.defaultIntervalMonths,
    this.defaultLeadKm = 500,
    this.defaultLeadDays = 7,
    this.applicableMotorcycleTypes = const ['matic', 'bebek', 'sport'],
    this.applicableForElectric = false,
  });

  static const List<MaintenanceTemplate> templates = [
    MaintenanceTemplate(
      name: 'Oli Mesin',
      category: 'Pelumasan',
      defaultIntervalKm: 2500,
      defaultIntervalMonths: 3,
      defaultLeadKm: 300,
      defaultLeadDays: 7,
      applicableMotorcycleTypes: ['matic', 'bebek', 'sport'],
      applicableForElectric: false,
    ),
    MaintenanceTemplate(
      name: 'Oli Gardan',
      category: 'Pelumasan',
      defaultIntervalKm: 8000,
      defaultIntervalMonths: 6,
      defaultLeadKm: 500,
      defaultLeadDays: 7,
      applicableMotorcycleTypes: ['matic'],
      applicableForElectric: false,
    ),
    MaintenanceTemplate(
      name: 'Filter Udara',
      category: 'Mesin',
      defaultIntervalKm: 12000,
      defaultIntervalMonths: 12,
      defaultLeadKm: 500,
      defaultLeadDays: 14,
      applicableMotorcycleTypes: ['matic', 'bebek', 'sport'],
      applicableForElectric: false,
    ),
    MaintenanceTemplate(
      name: 'Busi',
      category: 'Pengapian',
      defaultIntervalKm: 8000,
      defaultIntervalMonths: 6,
      defaultLeadKm: 500,
      defaultLeadDays: 7,
      applicableMotorcycleTypes: ['matic', 'bebek', 'sport'],
      applicableForElectric: false,
    ),
    MaintenanceTemplate(
      name: 'Kampas Rem',
      category: 'Pengereman',
      defaultIntervalKm: 10000,
      defaultIntervalMonths: 12,
      defaultLeadKm: 500,
      defaultLeadDays: 14,
      applicableMotorcycleTypes: ['matic', 'bebek', 'sport'],
      applicableForElectric: true,
    ),
    MaintenanceTemplate(
      name: 'Minyak Rem',
      category: 'Pengereman',
      defaultIntervalKm: 20000,
      defaultIntervalMonths: 24,
      defaultLeadKm: 1000,
      defaultLeadDays: 14,
      applicableMotorcycleTypes: ['matic', 'bebek', 'sport'],
      applicableForElectric: true,
    ),
    MaintenanceTemplate(
      name: 'Cairan Pendingin (Radiator)',
      category: 'Pendingin',
      defaultIntervalKm: 12000,
      defaultIntervalMonths: 12,
      defaultLeadKm: 500,
      defaultLeadDays: 14,
      applicableMotorcycleTypes: ['matic', 'bebek', 'sport'],
      applicableForElectric: false,
    ),
    MaintenanceTemplate(
      name: 'Servis CVT dan Roller',
      category: 'Transmisi',
      defaultIntervalKm: 10000,
      defaultIntervalMonths: 6,
      defaultLeadKm: 500,
      defaultLeadDays: 7,
      applicableMotorcycleTypes: ['matic'],
      applicableForElectric: false,
    ),
    MaintenanceTemplate(
      name: 'Rantai dan Gear',
      category: 'Transmisi',
      defaultIntervalKm: 15000,
      defaultIntervalMonths: 12,
      defaultLeadKm: 500,
      defaultLeadDays: 14,
      applicableMotorcycleTypes: ['bebek', 'sport'],
      applicableForElectric: false,
    ),
    MaintenanceTemplate(
      name: 'Ban Luar',
      category: 'Roda',
      defaultIntervalKm: 20000,
      defaultIntervalMonths: 24,
      defaultLeadKm: 1000,
      defaultLeadDays: 14,
      applicableMotorcycleTypes: ['matic', 'bebek', 'sport'],
      applicableForElectric: true,
    ),
    MaintenanceTemplate(
      name: 'Aki',
      category: 'Kelistrikan',
      defaultIntervalKm: null,
      defaultIntervalMonths: 24,
      defaultLeadKm: 0,
      defaultLeadDays: 14,
      applicableMotorcycleTypes: ['matic', 'bebek', 'sport'],
      applicableForElectric: true,
    ),
    MaintenanceTemplate(
      name: 'Pemeriksaan Umum',
      category: 'Umum',
      defaultIntervalKm: 4000,
      defaultIntervalMonths: 4,
      defaultLeadKm: 300,
      defaultLeadDays: 7,
      applicableMotorcycleTypes: ['matic', 'bebek', 'sport'],
      applicableForElectric: true,
    ),
  ];

  static List<MaintenanceTemplate> getTemplatesForMotorcycle({
    required String motorcycleType,
    required String propulsionType,
  }) {
    final isElectric = propulsionType.toLowerCase() == 'electric';
    return templates.where((t) {
      if (isElectric && !t.applicableForElectric) {
        return false;
      }
      return t.applicableMotorcycleTypes.contains(motorcycleType.toLowerCase());
    }).toList();
  }
}
