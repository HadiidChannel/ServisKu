import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

enum MaintenanceStatus {
  aman,
  segera,
  terlambat,
  belumDiatur;

  String get label {
    switch (this) {
      case MaintenanceStatus.aman:
        return AppConstants.statusAman;
      case MaintenanceStatus.segera:
        return AppConstants.statusSegera;
      case MaintenanceStatus.terlambat:
        return AppConstants.statusTerlambat;
      case MaintenanceStatus.belumDiatur:
        return AppConstants.statusBelumDiatur;
    }
  }

  Color get color {
    switch (this) {
      case MaintenanceStatus.aman:
        return AppColors.statusAman;
      case MaintenanceStatus.segera:
        return AppColors.statusSegera;
      case MaintenanceStatus.terlambat:
        return AppColors.statusTerlambat;
      case MaintenanceStatus.belumDiatur:
        return AppColors.statusBelumDiatur;
    }
  }

  Color get containerColor {
    switch (this) {
      case MaintenanceStatus.aman:
        return AppColors.statusAmanContainer;
      case MaintenanceStatus.segera:
        return AppColors.statusSegeraContainer;
      case MaintenanceStatus.terlambat:
        return AppColors.statusTerlambatContainer;
      case MaintenanceStatus.belumDiatur:
        return AppColors.statusBelumDiaturContainer;
    }
  }

  IconData get icon {
    switch (this) {
      case MaintenanceStatus.aman:
        return Icons.check_circle_outline_rounded;
      case MaintenanceStatus.segera:
        return Icons.warning_amber_rounded;
      case MaintenanceStatus.terlambat:
        return Icons.error_outline_rounded;
      case MaintenanceStatus.belumDiatur:
        return Icons.help_outline_rounded;
    }
  }

  int get priority {
    switch (this) {
      case MaintenanceStatus.terlambat:
        return 1;
      case MaintenanceStatus.segera:
        return 2;
      case MaintenanceStatus.aman:
        return 3;
      case MaintenanceStatus.belumDiatur:
        return 4;
    }
  }
}

class MaintenanceSchedule {
  final String id;
  final String motorcycleId;
  final String name;
  final String? category;
  final int? intervalKm;
  final int? intervalMonths;
  final int? lastDoneKm;
  final DateTime? lastDoneDate;
  final int? manualLastDoneKm;
  final DateTime? manualLastDoneDate;
  final int? reminderLeadKm;
  final int? reminderLeadDays;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MaintenanceSchedule({
    required this.id,
    required this.motorcycleId,
    required this.name,
    this.category,
    this.intervalKm,
    this.intervalMonths,
    this.lastDoneKm,
    this.lastDoneDate,
    this.manualLastDoneKm,
    this.manualLastDoneDate,
    this.reminderLeadKm,
    this.reminderLeadDays,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  MaintenanceSchedule copyWith({
    String? id,
    String? motorcycleId,
    String? name,
    String? category,
    int? intervalKm,
    int? intervalMonths,
    int? lastDoneKm,
    DateTime? lastDoneDate,
    int? manualLastDoneKm,
    DateTime? manualLastDoneDate,
    int? reminderLeadKm,
    int? reminderLeadDays,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaintenanceSchedule(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      name: name ?? this.name,
      category: category ?? this.category,
      intervalKm: intervalKm ?? this.intervalKm,
      intervalMonths: intervalMonths ?? this.intervalMonths,
      lastDoneKm: lastDoneKm ?? this.lastDoneKm,
      lastDoneDate: lastDoneDate ?? this.lastDoneDate,
      manualLastDoneKm: manualLastDoneKm ?? this.manualLastDoneKm,
      manualLastDoneDate: manualLastDoneDate ?? this.manualLastDoneDate,
      reminderLeadKm: reminderLeadKm ?? this.reminderLeadKm,
      reminderLeadDays: reminderLeadDays ?? this.reminderLeadDays,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
