// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MotorcyclesTable extends Motorcycles
    with TableInfo<$MotorcyclesTable, MotorcycleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MotorcyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _motorcycleTypeMeta =
      const VerificationMeta('motorcycleType');
  @override
  late final GeneratedColumn<String> motorcycleType = GeneratedColumn<String>(
      'motorcycle_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _manufactureYearMeta =
      const VerificationMeta('manufactureYear');
  @override
  late final GeneratedColumn<int> manufactureYear = GeneratedColumn<int>(
      'manufacture_year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _licensePlateMeta =
      const VerificationMeta('licensePlate');
  @override
  late final GeneratedColumn<String> licensePlate = GeneratedColumn<String>(
      'license_plate', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _propulsionTypeMeta =
      const VerificationMeta('propulsionType');
  @override
  late final GeneratedColumn<String> propulsionType = GeneratedColumn<String>(
      'propulsion_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nickname,
        brand,
        model,
        motorcycleType,
        manufactureYear,
        licensePlate,
        propulsionType,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'motorcycles';
  @override
  VerificationContext validateIntegrity(Insertable<MotorcycleRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('motorcycle_type')) {
      context.handle(
          _motorcycleTypeMeta,
          motorcycleType.isAcceptableOrUnknown(
              data['motorcycle_type']!, _motorcycleTypeMeta));
    } else if (isInserting) {
      context.missing(_motorcycleTypeMeta);
    }
    if (data.containsKey('manufacture_year')) {
      context.handle(
          _manufactureYearMeta,
          manufactureYear.isAcceptableOrUnknown(
              data['manufacture_year']!, _manufactureYearMeta));
    }
    if (data.containsKey('license_plate')) {
      context.handle(
          _licensePlateMeta,
          licensePlate.isAcceptableOrUnknown(
              data['license_plate']!, _licensePlateMeta));
    }
    if (data.containsKey('propulsion_type')) {
      context.handle(
          _propulsionTypeMeta,
          propulsionType.isAcceptableOrUnknown(
              data['propulsion_type']!, _propulsionTypeMeta));
    } else if (isInserting) {
      context.missing(_propulsionTypeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MotorcycleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MotorcycleRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      motorcycleType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}motorcycle_type'])!,
      manufactureYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}manufacture_year']),
      licensePlate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license_plate']),
      propulsionType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}propulsion_type'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MotorcyclesTable createAlias(String alias) {
    return $MotorcyclesTable(attachedDatabase, alias);
  }
}

class MotorcycleRow extends DataClass implements Insertable<MotorcycleRow> {
  final String id;
  final String nickname;
  final String brand;
  final String model;
  final String motorcycleType;
  final int? manufactureYear;
  final String? licensePlate;
  final String propulsionType;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  const MotorcycleRow(
      {required this.id,
      required this.nickname,
      required this.brand,
      required this.model,
      required this.motorcycleType,
      this.manufactureYear,
      this.licensePlate,
      required this.propulsionType,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nickname'] = Variable<String>(nickname);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['motorcycle_type'] = Variable<String>(motorcycleType);
    if (!nullToAbsent || manufactureYear != null) {
      map['manufacture_year'] = Variable<int>(manufactureYear);
    }
    if (!nullToAbsent || licensePlate != null) {
      map['license_plate'] = Variable<String>(licensePlate);
    }
    map['propulsion_type'] = Variable<String>(propulsionType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  MotorcyclesCompanion toCompanion(bool nullToAbsent) {
    return MotorcyclesCompanion(
      id: Value(id),
      nickname: Value(nickname),
      brand: Value(brand),
      model: Value(model),
      motorcycleType: Value(motorcycleType),
      manufactureYear: manufactureYear == null && nullToAbsent
          ? const Value.absent()
          : Value(manufactureYear),
      licensePlate: licensePlate == null && nullToAbsent
          ? const Value.absent()
          : Value(licensePlate),
      propulsionType: Value(propulsionType),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MotorcycleRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MotorcycleRow(
      id: serializer.fromJson<String>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      motorcycleType: serializer.fromJson<String>(json['motorcycleType']),
      manufactureYear: serializer.fromJson<int?>(json['manufactureYear']),
      licensePlate: serializer.fromJson<String?>(json['licensePlate']),
      propulsionType: serializer.fromJson<String>(json['propulsionType']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nickname': serializer.toJson<String>(nickname),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'motorcycleType': serializer.toJson<String>(motorcycleType),
      'manufactureYear': serializer.toJson<int?>(manufactureYear),
      'licensePlate': serializer.toJson<String?>(licensePlate),
      'propulsionType': serializer.toJson<String>(propulsionType),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  MotorcycleRow copyWith(
          {String? id,
          String? nickname,
          String? brand,
          String? model,
          String? motorcycleType,
          Value<int?> manufactureYear = const Value.absent(),
          Value<String?> licensePlate = const Value.absent(),
          String? propulsionType,
          Value<String?> notes = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      MotorcycleRow(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        motorcycleType: motorcycleType ?? this.motorcycleType,
        manufactureYear: manufactureYear.present
            ? manufactureYear.value
            : this.manufactureYear,
        licensePlate:
            licensePlate.present ? licensePlate.value : this.licensePlate,
        propulsionType: propulsionType ?? this.propulsionType,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MotorcycleRow copyWithCompanion(MotorcyclesCompanion data) {
    return MotorcycleRow(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      motorcycleType: data.motorcycleType.present
          ? data.motorcycleType.value
          : this.motorcycleType,
      manufactureYear: data.manufactureYear.present
          ? data.manufactureYear.value
          : this.manufactureYear,
      licensePlate: data.licensePlate.present
          ? data.licensePlate.value
          : this.licensePlate,
      propulsionType: data.propulsionType.present
          ? data.propulsionType.value
          : this.propulsionType,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MotorcycleRow(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('motorcycleType: $motorcycleType, ')
          ..write('manufactureYear: $manufactureYear, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('propulsionType: $propulsionType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nickname,
      brand,
      model,
      motorcycleType,
      manufactureYear,
      licensePlate,
      propulsionType,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MotorcycleRow &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.motorcycleType == this.motorcycleType &&
          other.manufactureYear == this.manufactureYear &&
          other.licensePlate == this.licensePlate &&
          other.propulsionType == this.propulsionType &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MotorcyclesCompanion extends UpdateCompanion<MotorcycleRow> {
  final Value<String> id;
  final Value<String> nickname;
  final Value<String> brand;
  final Value<String> model;
  final Value<String> motorcycleType;
  final Value<int?> manufactureYear;
  final Value<String?> licensePlate;
  final Value<String> propulsionType;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const MotorcyclesCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.motorcycleType = const Value.absent(),
    this.manufactureYear = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.propulsionType = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MotorcyclesCompanion.insert({
    required String id,
    required String nickname,
    required String brand,
    required String model,
    required String motorcycleType,
    this.manufactureYear = const Value.absent(),
    this.licensePlate = const Value.absent(),
    required String propulsionType,
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nickname = Value(nickname),
        brand = Value(brand),
        model = Value(model),
        motorcycleType = Value(motorcycleType),
        propulsionType = Value(propulsionType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MotorcycleRow> custom({
    Expression<String>? id,
    Expression<String>? nickname,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<String>? motorcycleType,
    Expression<int>? manufactureYear,
    Expression<String>? licensePlate,
    Expression<String>? propulsionType,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (motorcycleType != null) 'motorcycle_type': motorcycleType,
      if (manufactureYear != null) 'manufacture_year': manufactureYear,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (propulsionType != null) 'propulsion_type': propulsionType,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MotorcyclesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nickname,
      Value<String>? brand,
      Value<String>? model,
      Value<String>? motorcycleType,
      Value<int?>? manufactureYear,
      Value<String?>? licensePlate,
      Value<String>? propulsionType,
      Value<String?>? notes,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return MotorcyclesCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (motorcycleType.present) {
      map['motorcycle_type'] = Variable<String>(motorcycleType.value);
    }
    if (manufactureYear.present) {
      map['manufacture_year'] = Variable<int>(manufactureYear.value);
    }
    if (licensePlate.present) {
      map['license_plate'] = Variable<String>(licensePlate.value);
    }
    if (propulsionType.present) {
      map['propulsion_type'] = Variable<String>(propulsionType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MotorcyclesCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('motorcycleType: $motorcycleType, ')
          ..write('manufactureYear: $manufactureYear, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('propulsionType: $propulsionType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceRecordsTable extends ServiceRecords
    with TableInfo<$ServiceRecordsTable, ServiceRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<String> motorcycleId = GeneratedColumn<String>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES motorcycles (id) ON DELETE CASCADE'));
  static const VerificationMeta _serviceDateMeta =
      const VerificationMeta('serviceDate');
  @override
  late final GeneratedColumn<String> serviceDate = GeneratedColumn<String>(
      'service_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _odometerKmMeta =
      const VerificationMeta('odometerKm');
  @override
  late final GeneratedColumn<int> odometerKm = GeneratedColumn<int>(
      'odometer_km', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _workshopNameMeta =
      const VerificationMeta('workshopName');
  @override
  late final GeneratedColumn<String> workshopName = GeneratedColumn<String>(
      'workshop_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _additionalCostMeta =
      const VerificationMeta('additionalCost');
  @override
  late final GeneratedColumn<int> additionalCost = GeneratedColumn<int>(
      'additional_cost', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        serviceDate,
        odometerKm,
        workshopName,
        additionalCost,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_records';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceRecordRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('service_date')) {
      context.handle(
          _serviceDateMeta,
          serviceDate.isAcceptableOrUnknown(
              data['service_date']!, _serviceDateMeta));
    } else if (isInserting) {
      context.missing(_serviceDateMeta);
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
          _odometerKmMeta,
          odometerKm.isAcceptableOrUnknown(
              data['odometer_km']!, _odometerKmMeta));
    } else if (isInserting) {
      context.missing(_odometerKmMeta);
    }
    if (data.containsKey('workshop_name')) {
      context.handle(
          _workshopNameMeta,
          workshopName.isAcceptableOrUnknown(
              data['workshop_name']!, _workshopNameMeta));
    }
    if (data.containsKey('additional_cost')) {
      context.handle(
          _additionalCostMeta,
          additionalCost.isAcceptableOrUnknown(
              data['additional_cost']!, _additionalCostMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceRecordRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motorcycle_id'])!,
      serviceDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_date'])!,
      odometerKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}odometer_km'])!,
      workshopName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workshop_name']),
      additionalCost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}additional_cost'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ServiceRecordsTable createAlias(String alias) {
    return $ServiceRecordsTable(attachedDatabase, alias);
  }
}

class ServiceRecordRow extends DataClass
    implements Insertable<ServiceRecordRow> {
  final String id;
  final String motorcycleId;
  final String serviceDate;
  final int odometerKm;
  final String? workshopName;
  final int additionalCost;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  const ServiceRecordRow(
      {required this.id,
      required this.motorcycleId,
      required this.serviceDate,
      required this.odometerKm,
      this.workshopName,
      required this.additionalCost,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['motorcycle_id'] = Variable<String>(motorcycleId);
    map['service_date'] = Variable<String>(serviceDate);
    map['odometer_km'] = Variable<int>(odometerKm);
    if (!nullToAbsent || workshopName != null) {
      map['workshop_name'] = Variable<String>(workshopName);
    }
    map['additional_cost'] = Variable<int>(additionalCost);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ServiceRecordsCompanion toCompanion(bool nullToAbsent) {
    return ServiceRecordsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      serviceDate: Value(serviceDate),
      odometerKm: Value(odometerKm),
      workshopName: workshopName == null && nullToAbsent
          ? const Value.absent()
          : Value(workshopName),
      additionalCost: Value(additionalCost),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ServiceRecordRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceRecordRow(
      id: serializer.fromJson<String>(json['id']),
      motorcycleId: serializer.fromJson<String>(json['motorcycleId']),
      serviceDate: serializer.fromJson<String>(json['serviceDate']),
      odometerKm: serializer.fromJson<int>(json['odometerKm']),
      workshopName: serializer.fromJson<String?>(json['workshopName']),
      additionalCost: serializer.fromJson<int>(json['additionalCost']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'motorcycleId': serializer.toJson<String>(motorcycleId),
      'serviceDate': serializer.toJson<String>(serviceDate),
      'odometerKm': serializer.toJson<int>(odometerKm),
      'workshopName': serializer.toJson<String?>(workshopName),
      'additionalCost': serializer.toJson<int>(additionalCost),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ServiceRecordRow copyWith(
          {String? id,
          String? motorcycleId,
          String? serviceDate,
          int? odometerKm,
          Value<String?> workshopName = const Value.absent(),
          int? additionalCost,
          Value<String?> notes = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      ServiceRecordRow(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        serviceDate: serviceDate ?? this.serviceDate,
        odometerKm: odometerKm ?? this.odometerKm,
        workshopName:
            workshopName.present ? workshopName.value : this.workshopName,
        additionalCost: additionalCost ?? this.additionalCost,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ServiceRecordRow copyWithCompanion(ServiceRecordsCompanion data) {
    return ServiceRecordRow(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      serviceDate:
          data.serviceDate.present ? data.serviceDate.value : this.serviceDate,
      odometerKm:
          data.odometerKm.present ? data.odometerKm.value : this.odometerKm,
      workshopName: data.workshopName.present
          ? data.workshopName.value
          : this.workshopName,
      additionalCost: data.additionalCost.present
          ? data.additionalCost.value
          : this.additionalCost,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecordRow(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('serviceDate: $serviceDate, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('workshopName: $workshopName, ')
          ..write('additionalCost: $additionalCost, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, motorcycleId, serviceDate, odometerKm,
      workshopName, additionalCost, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceRecordRow &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.serviceDate == this.serviceDate &&
          other.odometerKm == this.odometerKm &&
          other.workshopName == this.workshopName &&
          other.additionalCost == this.additionalCost &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServiceRecordsCompanion extends UpdateCompanion<ServiceRecordRow> {
  final Value<String> id;
  final Value<String> motorcycleId;
  final Value<String> serviceDate;
  final Value<int> odometerKm;
  final Value<String?> workshopName;
  final Value<int> additionalCost;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const ServiceRecordsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.serviceDate = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.workshopName = const Value.absent(),
    this.additionalCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceRecordsCompanion.insert({
    required String id,
    required String motorcycleId,
    required String serviceDate,
    required int odometerKm,
    this.workshopName = const Value.absent(),
    this.additionalCost = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        motorcycleId = Value(motorcycleId),
        serviceDate = Value(serviceDate),
        odometerKm = Value(odometerKm),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ServiceRecordRow> custom({
    Expression<String>? id,
    Expression<String>? motorcycleId,
    Expression<String>? serviceDate,
    Expression<int>? odometerKm,
    Expression<String>? workshopName,
    Expression<int>? additionalCost,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (serviceDate != null) 'service_date': serviceDate,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (workshopName != null) 'workshop_name': workshopName,
      if (additionalCost != null) 'additional_cost': additionalCost,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? motorcycleId,
      Value<String>? serviceDate,
      Value<int>? odometerKm,
      Value<String?>? workshopName,
      Value<int>? additionalCost,
      Value<String?>? notes,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return ServiceRecordsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      serviceDate: serviceDate ?? this.serviceDate,
      odometerKm: odometerKm ?? this.odometerKm,
      workshopName: workshopName ?? this.workshopName,
      additionalCost: additionalCost ?? this.additionalCost,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<String>(motorcycleId.value);
    }
    if (serviceDate.present) {
      map['service_date'] = Variable<String>(serviceDate.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<int>(odometerKm.value);
    }
    if (workshopName.present) {
      map['workshop_name'] = Variable<String>(workshopName.value);
    }
    if (additionalCost.present) {
      map['additional_cost'] = Variable<int>(additionalCost.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('serviceDate: $serviceDate, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('workshopName: $workshopName, ')
          ..write('additionalCost: $additionalCost, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OdometerReadingsTable extends OdometerReadings
    with TableInfo<$OdometerReadingsTable, OdometerReadingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OdometerReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<String> motorcycleId = GeneratedColumn<String>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES motorcycles (id) ON DELETE CASCADE'));
  static const VerificationMeta _odometerKmMeta =
      const VerificationMeta('odometerKm');
  @override
  late final GeneratedColumn<int> odometerKm = GeneratedColumn<int>(
      'odometer_km', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _readingDateMeta =
      const VerificationMeta('readingDate');
  @override
  late final GeneratedColumn<String> readingDate = GeneratedColumn<String>(
      'reading_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serviceRecordIdMeta =
      const VerificationMeta('serviceRecordId');
  @override
  late final GeneratedColumn<String> serviceRecordId = GeneratedColumn<String>(
      'service_record_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES service_records (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        odometerKm,
        readingDate,
        source,
        notes,
        createdAt,
        serviceRecordId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'odometer_readings';
  @override
  VerificationContext validateIntegrity(Insertable<OdometerReadingRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
          _odometerKmMeta,
          odometerKm.isAcceptableOrUnknown(
              data['odometer_km']!, _odometerKmMeta));
    } else if (isInserting) {
      context.missing(_odometerKmMeta);
    }
    if (data.containsKey('reading_date')) {
      context.handle(
          _readingDateMeta,
          readingDate.isAcceptableOrUnknown(
              data['reading_date']!, _readingDateMeta));
    } else if (isInserting) {
      context.missing(_readingDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('service_record_id')) {
      context.handle(
          _serviceRecordIdMeta,
          serviceRecordId.isAcceptableOrUnknown(
              data['service_record_id']!, _serviceRecordIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OdometerReadingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OdometerReadingRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motorcycle_id'])!,
      odometerKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}odometer_km'])!,
      readingDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reading_date'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      serviceRecordId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}service_record_id']),
    );
  }

  @override
  $OdometerReadingsTable createAlias(String alias) {
    return $OdometerReadingsTable(attachedDatabase, alias);
  }
}

class OdometerReadingRow extends DataClass
    implements Insertable<OdometerReadingRow> {
  final String id;
  final String motorcycleId;
  final int odometerKm;
  final String readingDate;
  final String source;
  final String? notes;
  final String createdAt;
  final String? serviceRecordId;
  const OdometerReadingRow(
      {required this.id,
      required this.motorcycleId,
      required this.odometerKm,
      required this.readingDate,
      required this.source,
      this.notes,
      required this.createdAt,
      this.serviceRecordId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['motorcycle_id'] = Variable<String>(motorcycleId);
    map['odometer_km'] = Variable<int>(odometerKm);
    map['reading_date'] = Variable<String>(readingDate);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || serviceRecordId != null) {
      map['service_record_id'] = Variable<String>(serviceRecordId);
    }
    return map;
  }

  OdometerReadingsCompanion toCompanion(bool nullToAbsent) {
    return OdometerReadingsCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      odometerKm: Value(odometerKm),
      readingDate: Value(readingDate),
      source: Value(source),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      serviceRecordId: serviceRecordId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceRecordId),
    );
  }

  factory OdometerReadingRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OdometerReadingRow(
      id: serializer.fromJson<String>(json['id']),
      motorcycleId: serializer.fromJson<String>(json['motorcycleId']),
      odometerKm: serializer.fromJson<int>(json['odometerKm']),
      readingDate: serializer.fromJson<String>(json['readingDate']),
      source: serializer.fromJson<String>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      serviceRecordId: serializer.fromJson<String?>(json['serviceRecordId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'motorcycleId': serializer.toJson<String>(motorcycleId),
      'odometerKm': serializer.toJson<int>(odometerKm),
      'readingDate': serializer.toJson<String>(readingDate),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'serviceRecordId': serializer.toJson<String?>(serviceRecordId),
    };
  }

  OdometerReadingRow copyWith(
          {String? id,
          String? motorcycleId,
          int? odometerKm,
          String? readingDate,
          String? source,
          Value<String?> notes = const Value.absent(),
          String? createdAt,
          Value<String?> serviceRecordId = const Value.absent()}) =>
      OdometerReadingRow(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        odometerKm: odometerKm ?? this.odometerKm,
        readingDate: readingDate ?? this.readingDate,
        source: source ?? this.source,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        serviceRecordId: serviceRecordId.present
            ? serviceRecordId.value
            : this.serviceRecordId,
      );
  OdometerReadingRow copyWithCompanion(OdometerReadingsCompanion data) {
    return OdometerReadingRow(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      odometerKm:
          data.odometerKm.present ? data.odometerKm.value : this.odometerKm,
      readingDate:
          data.readingDate.present ? data.readingDate.value : this.readingDate,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      serviceRecordId: data.serviceRecordId.present
          ? data.serviceRecordId.value
          : this.serviceRecordId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OdometerReadingRow(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('readingDate: $readingDate, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('serviceRecordId: $serviceRecordId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, motorcycleId, odometerKm, readingDate,
      source, notes, createdAt, serviceRecordId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OdometerReadingRow &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.odometerKm == this.odometerKm &&
          other.readingDate == this.readingDate &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.serviceRecordId == this.serviceRecordId);
}

class OdometerReadingsCompanion extends UpdateCompanion<OdometerReadingRow> {
  final Value<String> id;
  final Value<String> motorcycleId;
  final Value<int> odometerKm;
  final Value<String> readingDate;
  final Value<String> source;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String?> serviceRecordId;
  final Value<int> rowid;
  const OdometerReadingsCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.readingDate = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.serviceRecordId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OdometerReadingsCompanion.insert({
    required String id,
    required String motorcycleId,
    required int odometerKm,
    required String readingDate,
    required String source,
    this.notes = const Value.absent(),
    required String createdAt,
    this.serviceRecordId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        motorcycleId = Value(motorcycleId),
        odometerKm = Value(odometerKm),
        readingDate = Value(readingDate),
        source = Value(source),
        createdAt = Value(createdAt);
  static Insertable<OdometerReadingRow> custom({
    Expression<String>? id,
    Expression<String>? motorcycleId,
    Expression<int>? odometerKm,
    Expression<String>? readingDate,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? serviceRecordId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (readingDate != null) 'reading_date': readingDate,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (serviceRecordId != null) 'service_record_id': serviceRecordId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OdometerReadingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? motorcycleId,
      Value<int>? odometerKm,
      Value<String>? readingDate,
      Value<String>? source,
      Value<String?>? notes,
      Value<String>? createdAt,
      Value<String?>? serviceRecordId,
      Value<int>? rowid}) {
    return OdometerReadingsCompanion(
      id: id ?? this.id,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      odometerKm: odometerKm ?? this.odometerKm,
      readingDate: readingDate ?? this.readingDate,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      serviceRecordId: serviceRecordId ?? this.serviceRecordId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<String>(motorcycleId.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<int>(odometerKm.value);
    }
    if (readingDate.present) {
      map['reading_date'] = Variable<String>(readingDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (serviceRecordId.present) {
      map['service_record_id'] = Variable<String>(serviceRecordId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OdometerReadingsCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('readingDate: $readingDate, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('serviceRecordId: $serviceRecordId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceSchedulesTable extends MaintenanceSchedules
    with TableInfo<$MaintenanceSchedulesTable, MaintenanceScheduleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _motorcycleIdMeta =
      const VerificationMeta('motorcycleId');
  @override
  late final GeneratedColumn<String> motorcycleId = GeneratedColumn<String>(
      'motorcycle_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES motorcycles (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _intervalKmMeta =
      const VerificationMeta('intervalKm');
  @override
  late final GeneratedColumn<int> intervalKm = GeneratedColumn<int>(
      'interval_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _intervalMonthsMeta =
      const VerificationMeta('intervalMonths');
  @override
  late final GeneratedColumn<int> intervalMonths = GeneratedColumn<int>(
      'interval_months', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastDoneKmMeta =
      const VerificationMeta('lastDoneKm');
  @override
  late final GeneratedColumn<int> lastDoneKm = GeneratedColumn<int>(
      'last_done_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastDoneDateMeta =
      const VerificationMeta('lastDoneDate');
  @override
  late final GeneratedColumn<String> lastDoneDate = GeneratedColumn<String>(
      'last_done_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _manualLastDoneKmMeta =
      const VerificationMeta('manualLastDoneKm');
  @override
  late final GeneratedColumn<int> manualLastDoneKm = GeneratedColumn<int>(
      'manual_last_done_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _manualLastDoneDateMeta =
      const VerificationMeta('manualLastDoneDate');
  @override
  late final GeneratedColumn<String> manualLastDoneDate =
      GeneratedColumn<String>('manual_last_done_date', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderLeadKmMeta =
      const VerificationMeta('reminderLeadKm');
  @override
  late final GeneratedColumn<int> reminderLeadKm = GeneratedColumn<int>(
      'reminder_lead_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _reminderLeadDaysMeta =
      const VerificationMeta('reminderLeadDays');
  @override
  late final GeneratedColumn<int> reminderLeadDays = GeneratedColumn<int>(
      'reminder_lead_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        motorcycleId,
        name,
        category,
        intervalKm,
        intervalMonths,
        lastDoneKm,
        lastDoneDate,
        manualLastDoneKm,
        manualLastDoneDate,
        reminderLeadKm,
        reminderLeadDays,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_schedules';
  @override
  VerificationContext validateIntegrity(
      Insertable<MaintenanceScheduleRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('motorcycle_id')) {
      context.handle(
          _motorcycleIdMeta,
          motorcycleId.isAcceptableOrUnknown(
              data['motorcycle_id']!, _motorcycleIdMeta));
    } else if (isInserting) {
      context.missing(_motorcycleIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('interval_km')) {
      context.handle(
          _intervalKmMeta,
          intervalKm.isAcceptableOrUnknown(
              data['interval_km']!, _intervalKmMeta));
    }
    if (data.containsKey('interval_months')) {
      context.handle(
          _intervalMonthsMeta,
          intervalMonths.isAcceptableOrUnknown(
              data['interval_months']!, _intervalMonthsMeta));
    }
    if (data.containsKey('last_done_km')) {
      context.handle(
          _lastDoneKmMeta,
          lastDoneKm.isAcceptableOrUnknown(
              data['last_done_km']!, _lastDoneKmMeta));
    }
    if (data.containsKey('last_done_date')) {
      context.handle(
          _lastDoneDateMeta,
          lastDoneDate.isAcceptableOrUnknown(
              data['last_done_date']!, _lastDoneDateMeta));
    }
    if (data.containsKey('manual_last_done_km')) {
      context.handle(
          _manualLastDoneKmMeta,
          manualLastDoneKm.isAcceptableOrUnknown(
              data['manual_last_done_km']!, _manualLastDoneKmMeta));
    }
    if (data.containsKey('manual_last_done_date')) {
      context.handle(
          _manualLastDoneDateMeta,
          manualLastDoneDate.isAcceptableOrUnknown(
              data['manual_last_done_date']!, _manualLastDoneDateMeta));
    }
    if (data.containsKey('reminder_lead_km')) {
      context.handle(
          _reminderLeadKmMeta,
          reminderLeadKm.isAcceptableOrUnknown(
              data['reminder_lead_km']!, _reminderLeadKmMeta));
    }
    if (data.containsKey('reminder_lead_days')) {
      context.handle(
          _reminderLeadDaysMeta,
          reminderLeadDays.isAcceptableOrUnknown(
              data['reminder_lead_days']!, _reminderLeadDaysMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceScheduleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceScheduleRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      motorcycleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motorcycle_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      intervalKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_km']),
      intervalMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_months']),
      lastDoneKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_done_km']),
      lastDoneDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_done_date']),
      manualLastDoneKm: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}manual_last_done_km']),
      manualLastDoneDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}manual_last_done_date']),
      reminderLeadKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminder_lead_km']),
      reminderLeadDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminder_lead_days']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MaintenanceSchedulesTable createAlias(String alias) {
    return $MaintenanceSchedulesTable(attachedDatabase, alias);
  }
}

class MaintenanceScheduleRow extends DataClass
    implements Insertable<MaintenanceScheduleRow> {
  final String id;
  final String motorcycleId;
  final String name;
  final String? category;
  final int? intervalKm;
  final int? intervalMonths;
  final int? lastDoneKm;
  final String? lastDoneDate;
  final int? manualLastDoneKm;
  final String? manualLastDoneDate;
  final int? reminderLeadKm;
  final int? reminderLeadDays;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  const MaintenanceScheduleRow(
      {required this.id,
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
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['motorcycle_id'] = Variable<String>(motorcycleId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || intervalKm != null) {
      map['interval_km'] = Variable<int>(intervalKm);
    }
    if (!nullToAbsent || intervalMonths != null) {
      map['interval_months'] = Variable<int>(intervalMonths);
    }
    if (!nullToAbsent || lastDoneKm != null) {
      map['last_done_km'] = Variable<int>(lastDoneKm);
    }
    if (!nullToAbsent || lastDoneDate != null) {
      map['last_done_date'] = Variable<String>(lastDoneDate);
    }
    if (!nullToAbsent || manualLastDoneKm != null) {
      map['manual_last_done_km'] = Variable<int>(manualLastDoneKm);
    }
    if (!nullToAbsent || manualLastDoneDate != null) {
      map['manual_last_done_date'] = Variable<String>(manualLastDoneDate);
    }
    if (!nullToAbsent || reminderLeadKm != null) {
      map['reminder_lead_km'] = Variable<int>(reminderLeadKm);
    }
    if (!nullToAbsent || reminderLeadDays != null) {
      map['reminder_lead_days'] = Variable<int>(reminderLeadDays);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  MaintenanceSchedulesCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceSchedulesCompanion(
      id: Value(id),
      motorcycleId: Value(motorcycleId),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      intervalKm: intervalKm == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalKm),
      intervalMonths: intervalMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalMonths),
      lastDoneKm: lastDoneKm == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneKm),
      lastDoneDate: lastDoneDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneDate),
      manualLastDoneKm: manualLastDoneKm == null && nullToAbsent
          ? const Value.absent()
          : Value(manualLastDoneKm),
      manualLastDoneDate: manualLastDoneDate == null && nullToAbsent
          ? const Value.absent()
          : Value(manualLastDoneDate),
      reminderLeadKm: reminderLeadKm == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderLeadKm),
      reminderLeadDays: reminderLeadDays == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderLeadDays),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MaintenanceScheduleRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceScheduleRow(
      id: serializer.fromJson<String>(json['id']),
      motorcycleId: serializer.fromJson<String>(json['motorcycleId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      intervalKm: serializer.fromJson<int?>(json['intervalKm']),
      intervalMonths: serializer.fromJson<int?>(json['intervalMonths']),
      lastDoneKm: serializer.fromJson<int?>(json['lastDoneKm']),
      lastDoneDate: serializer.fromJson<String?>(json['lastDoneDate']),
      manualLastDoneKm: serializer.fromJson<int?>(json['manualLastDoneKm']),
      manualLastDoneDate:
          serializer.fromJson<String?>(json['manualLastDoneDate']),
      reminderLeadKm: serializer.fromJson<int?>(json['reminderLeadKm']),
      reminderLeadDays: serializer.fromJson<int?>(json['reminderLeadDays']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'motorcycleId': serializer.toJson<String>(motorcycleId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'intervalKm': serializer.toJson<int?>(intervalKm),
      'intervalMonths': serializer.toJson<int?>(intervalMonths),
      'lastDoneKm': serializer.toJson<int?>(lastDoneKm),
      'lastDoneDate': serializer.toJson<String?>(lastDoneDate),
      'manualLastDoneKm': serializer.toJson<int?>(manualLastDoneKm),
      'manualLastDoneDate': serializer.toJson<String?>(manualLastDoneDate),
      'reminderLeadKm': serializer.toJson<int?>(reminderLeadKm),
      'reminderLeadDays': serializer.toJson<int?>(reminderLeadDays),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  MaintenanceScheduleRow copyWith(
          {String? id,
          String? motorcycleId,
          String? name,
          Value<String?> category = const Value.absent(),
          Value<int?> intervalKm = const Value.absent(),
          Value<int?> intervalMonths = const Value.absent(),
          Value<int?> lastDoneKm = const Value.absent(),
          Value<String?> lastDoneDate = const Value.absent(),
          Value<int?> manualLastDoneKm = const Value.absent(),
          Value<String?> manualLastDoneDate = const Value.absent(),
          Value<int?> reminderLeadKm = const Value.absent(),
          Value<int?> reminderLeadDays = const Value.absent(),
          bool? isActive,
          String? createdAt,
          String? updatedAt}) =>
      MaintenanceScheduleRow(
        id: id ?? this.id,
        motorcycleId: motorcycleId ?? this.motorcycleId,
        name: name ?? this.name,
        category: category.present ? category.value : this.category,
        intervalKm: intervalKm.present ? intervalKm.value : this.intervalKm,
        intervalMonths:
            intervalMonths.present ? intervalMonths.value : this.intervalMonths,
        lastDoneKm: lastDoneKm.present ? lastDoneKm.value : this.lastDoneKm,
        lastDoneDate:
            lastDoneDate.present ? lastDoneDate.value : this.lastDoneDate,
        manualLastDoneKm: manualLastDoneKm.present
            ? manualLastDoneKm.value
            : this.manualLastDoneKm,
        manualLastDoneDate: manualLastDoneDate.present
            ? manualLastDoneDate.value
            : this.manualLastDoneDate,
        reminderLeadKm:
            reminderLeadKm.present ? reminderLeadKm.value : this.reminderLeadKm,
        reminderLeadDays: reminderLeadDays.present
            ? reminderLeadDays.value
            : this.reminderLeadDays,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MaintenanceScheduleRow copyWithCompanion(MaintenanceSchedulesCompanion data) {
    return MaintenanceScheduleRow(
      id: data.id.present ? data.id.value : this.id,
      motorcycleId: data.motorcycleId.present
          ? data.motorcycleId.value
          : this.motorcycleId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      intervalKm:
          data.intervalKm.present ? data.intervalKm.value : this.intervalKm,
      intervalMonths: data.intervalMonths.present
          ? data.intervalMonths.value
          : this.intervalMonths,
      lastDoneKm:
          data.lastDoneKm.present ? data.lastDoneKm.value : this.lastDoneKm,
      lastDoneDate: data.lastDoneDate.present
          ? data.lastDoneDate.value
          : this.lastDoneDate,
      manualLastDoneKm: data.manualLastDoneKm.present
          ? data.manualLastDoneKm.value
          : this.manualLastDoneKm,
      manualLastDoneDate: data.manualLastDoneDate.present
          ? data.manualLastDoneDate.value
          : this.manualLastDoneDate,
      reminderLeadKm: data.reminderLeadKm.present
          ? data.reminderLeadKm.value
          : this.reminderLeadKm,
      reminderLeadDays: data.reminderLeadDays.present
          ? data.reminderLeadDays.value
          : this.reminderLeadDays,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceScheduleRow(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('lastDoneKm: $lastDoneKm, ')
          ..write('lastDoneDate: $lastDoneDate, ')
          ..write('manualLastDoneKm: $manualLastDoneKm, ')
          ..write('manualLastDoneDate: $manualLastDoneDate, ')
          ..write('reminderLeadKm: $reminderLeadKm, ')
          ..write('reminderLeadDays: $reminderLeadDays, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      motorcycleId,
      name,
      category,
      intervalKm,
      intervalMonths,
      lastDoneKm,
      lastDoneDate,
      manualLastDoneKm,
      manualLastDoneDate,
      reminderLeadKm,
      reminderLeadDays,
      isActive,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceScheduleRow &&
          other.id == this.id &&
          other.motorcycleId == this.motorcycleId &&
          other.name == this.name &&
          other.category == this.category &&
          other.intervalKm == this.intervalKm &&
          other.intervalMonths == this.intervalMonths &&
          other.lastDoneKm == this.lastDoneKm &&
          other.lastDoneDate == this.lastDoneDate &&
          other.manualLastDoneKm == this.manualLastDoneKm &&
          other.manualLastDoneDate == this.manualLastDoneDate &&
          other.reminderLeadKm == this.reminderLeadKm &&
          other.reminderLeadDays == this.reminderLeadDays &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MaintenanceSchedulesCompanion
    extends UpdateCompanion<MaintenanceScheduleRow> {
  final Value<String> id;
  final Value<String> motorcycleId;
  final Value<String> name;
  final Value<String?> category;
  final Value<int?> intervalKm;
  final Value<int?> intervalMonths;
  final Value<int?> lastDoneKm;
  final Value<String?> lastDoneDate;
  final Value<int?> manualLastDoneKm;
  final Value<String?> manualLastDoneDate;
  final Value<int?> reminderLeadKm;
  final Value<int?> reminderLeadDays;
  final Value<bool> isActive;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const MaintenanceSchedulesCompanion({
    this.id = const Value.absent(),
    this.motorcycleId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.intervalKm = const Value.absent(),
    this.intervalMonths = const Value.absent(),
    this.lastDoneKm = const Value.absent(),
    this.lastDoneDate = const Value.absent(),
    this.manualLastDoneKm = const Value.absent(),
    this.manualLastDoneDate = const Value.absent(),
    this.reminderLeadKm = const Value.absent(),
    this.reminderLeadDays = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceSchedulesCompanion.insert({
    required String id,
    required String motorcycleId,
    required String name,
    this.category = const Value.absent(),
    this.intervalKm = const Value.absent(),
    this.intervalMonths = const Value.absent(),
    this.lastDoneKm = const Value.absent(),
    this.lastDoneDate = const Value.absent(),
    this.manualLastDoneKm = const Value.absent(),
    this.manualLastDoneDate = const Value.absent(),
    this.reminderLeadKm = const Value.absent(),
    this.reminderLeadDays = const Value.absent(),
    this.isActive = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        motorcycleId = Value(motorcycleId),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MaintenanceScheduleRow> custom({
    Expression<String>? id,
    Expression<String>? motorcycleId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? intervalKm,
    Expression<int>? intervalMonths,
    Expression<int>? lastDoneKm,
    Expression<String>? lastDoneDate,
    Expression<int>? manualLastDoneKm,
    Expression<String>? manualLastDoneDate,
    Expression<int>? reminderLeadKm,
    Expression<int>? reminderLeadDays,
    Expression<bool>? isActive,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motorcycleId != null) 'motorcycle_id': motorcycleId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (intervalKm != null) 'interval_km': intervalKm,
      if (intervalMonths != null) 'interval_months': intervalMonths,
      if (lastDoneKm != null) 'last_done_km': lastDoneKm,
      if (lastDoneDate != null) 'last_done_date': lastDoneDate,
      if (manualLastDoneKm != null) 'manual_last_done_km': manualLastDoneKm,
      if (manualLastDoneDate != null)
        'manual_last_done_date': manualLastDoneDate,
      if (reminderLeadKm != null) 'reminder_lead_km': reminderLeadKm,
      if (reminderLeadDays != null) 'reminder_lead_days': reminderLeadDays,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceSchedulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? motorcycleId,
      Value<String>? name,
      Value<String?>? category,
      Value<int?>? intervalKm,
      Value<int?>? intervalMonths,
      Value<int?>? lastDoneKm,
      Value<String?>? lastDoneDate,
      Value<int?>? manualLastDoneKm,
      Value<String?>? manualLastDoneDate,
      Value<int?>? reminderLeadKm,
      Value<int?>? reminderLeadDays,
      Value<bool>? isActive,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return MaintenanceSchedulesCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (motorcycleId.present) {
      map['motorcycle_id'] = Variable<String>(motorcycleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (intervalKm.present) {
      map['interval_km'] = Variable<int>(intervalKm.value);
    }
    if (intervalMonths.present) {
      map['interval_months'] = Variable<int>(intervalMonths.value);
    }
    if (lastDoneKm.present) {
      map['last_done_km'] = Variable<int>(lastDoneKm.value);
    }
    if (lastDoneDate.present) {
      map['last_done_date'] = Variable<String>(lastDoneDate.value);
    }
    if (manualLastDoneKm.present) {
      map['manual_last_done_km'] = Variable<int>(manualLastDoneKm.value);
    }
    if (manualLastDoneDate.present) {
      map['manual_last_done_date'] = Variable<String>(manualLastDoneDate.value);
    }
    if (reminderLeadKm.present) {
      map['reminder_lead_km'] = Variable<int>(reminderLeadKm.value);
    }
    if (reminderLeadDays.present) {
      map['reminder_lead_days'] = Variable<int>(reminderLeadDays.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('motorcycleId: $motorcycleId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('lastDoneKm: $lastDoneKm, ')
          ..write('lastDoneDate: $lastDoneDate, ')
          ..write('manualLastDoneKm: $manualLastDoneKm, ')
          ..write('manualLastDoneDate: $manualLastDoneDate, ')
          ..write('reminderLeadKm: $reminderLeadKm, ')
          ..write('reminderLeadDays: $reminderLeadDays, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceRecordItemsTable extends ServiceRecordItems
    with TableInfo<$ServiceRecordItemsTable, ServiceRecordItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceRecordItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serviceRecordIdMeta =
      const VerificationMeta('serviceRecordId');
  @override
  late final GeneratedColumn<String> serviceRecordId = GeneratedColumn<String>(
      'service_record_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES service_records (id) ON DELETE CASCADE'));
  static const VerificationMeta _maintenanceScheduleIdMeta =
      const VerificationMeta('maintenanceScheduleId');
  @override
  late final GeneratedColumn<String> maintenanceScheduleId =
      GeneratedColumn<String>('maintenance_schedule_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES maintenance_schedules (id) ON DELETE SET NULL'));
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _itemCostMeta =
      const VerificationMeta('itemCost');
  @override
  late final GeneratedColumn<int> itemCost = GeneratedColumn<int>(
      'item_cost', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serviceRecordId,
        maintenanceScheduleId,
        itemName,
        category,
        itemCost,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_record_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<ServiceRecordItemRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('service_record_id')) {
      context.handle(
          _serviceRecordIdMeta,
          serviceRecordId.isAcceptableOrUnknown(
              data['service_record_id']!, _serviceRecordIdMeta));
    } else if (isInserting) {
      context.missing(_serviceRecordIdMeta);
    }
    if (data.containsKey('maintenance_schedule_id')) {
      context.handle(
          _maintenanceScheduleIdMeta,
          maintenanceScheduleId.isAcceptableOrUnknown(
              data['maintenance_schedule_id']!, _maintenanceScheduleIdMeta));
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('item_cost')) {
      context.handle(_itemCostMeta,
          itemCost.isAcceptableOrUnknown(data['item_cost']!, _itemCostMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceRecordItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceRecordItemRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      serviceRecordId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}service_record_id'])!,
      maintenanceScheduleId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}maintenance_schedule_id']),
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      itemCost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_cost'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $ServiceRecordItemsTable createAlias(String alias) {
    return $ServiceRecordItemsTable(attachedDatabase, alias);
  }
}

class ServiceRecordItemRow extends DataClass
    implements Insertable<ServiceRecordItemRow> {
  final String id;
  final String serviceRecordId;
  final String? maintenanceScheduleId;
  final String itemName;
  final String? category;
  final int itemCost;
  final String? notes;
  const ServiceRecordItemRow(
      {required this.id,
      required this.serviceRecordId,
      this.maintenanceScheduleId,
      required this.itemName,
      this.category,
      required this.itemCost,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['service_record_id'] = Variable<String>(serviceRecordId);
    if (!nullToAbsent || maintenanceScheduleId != null) {
      map['maintenance_schedule_id'] = Variable<String>(maintenanceScheduleId);
    }
    map['item_name'] = Variable<String>(itemName);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['item_cost'] = Variable<int>(itemCost);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ServiceRecordItemsCompanion toCompanion(bool nullToAbsent) {
    return ServiceRecordItemsCompanion(
      id: Value(id),
      serviceRecordId: Value(serviceRecordId),
      maintenanceScheduleId: maintenanceScheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(maintenanceScheduleId),
      itemName: Value(itemName),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      itemCost: Value(itemCost),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory ServiceRecordItemRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceRecordItemRow(
      id: serializer.fromJson<String>(json['id']),
      serviceRecordId: serializer.fromJson<String>(json['serviceRecordId']),
      maintenanceScheduleId:
          serializer.fromJson<String?>(json['maintenanceScheduleId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      category: serializer.fromJson<String?>(json['category']),
      itemCost: serializer.fromJson<int>(json['itemCost']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serviceRecordId': serializer.toJson<String>(serviceRecordId),
      'maintenanceScheduleId':
          serializer.toJson<String?>(maintenanceScheduleId),
      'itemName': serializer.toJson<String>(itemName),
      'category': serializer.toJson<String?>(category),
      'itemCost': serializer.toJson<int>(itemCost),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ServiceRecordItemRow copyWith(
          {String? id,
          String? serviceRecordId,
          Value<String?> maintenanceScheduleId = const Value.absent(),
          String? itemName,
          Value<String?> category = const Value.absent(),
          int? itemCost,
          Value<String?> notes = const Value.absent()}) =>
      ServiceRecordItemRow(
        id: id ?? this.id,
        serviceRecordId: serviceRecordId ?? this.serviceRecordId,
        maintenanceScheduleId: maintenanceScheduleId.present
            ? maintenanceScheduleId.value
            : this.maintenanceScheduleId,
        itemName: itemName ?? this.itemName,
        category: category.present ? category.value : this.category,
        itemCost: itemCost ?? this.itemCost,
        notes: notes.present ? notes.value : this.notes,
      );
  ServiceRecordItemRow copyWithCompanion(ServiceRecordItemsCompanion data) {
    return ServiceRecordItemRow(
      id: data.id.present ? data.id.value : this.id,
      serviceRecordId: data.serviceRecordId.present
          ? data.serviceRecordId.value
          : this.serviceRecordId,
      maintenanceScheduleId: data.maintenanceScheduleId.present
          ? data.maintenanceScheduleId.value
          : this.maintenanceScheduleId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      category: data.category.present ? data.category.value : this.category,
      itemCost: data.itemCost.present ? data.itemCost.value : this.itemCost,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecordItemRow(')
          ..write('id: $id, ')
          ..write('serviceRecordId: $serviceRecordId, ')
          ..write('maintenanceScheduleId: $maintenanceScheduleId, ')
          ..write('itemName: $itemName, ')
          ..write('category: $category, ')
          ..write('itemCost: $itemCost, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serviceRecordId, maintenanceScheduleId,
      itemName, category, itemCost, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceRecordItemRow &&
          other.id == this.id &&
          other.serviceRecordId == this.serviceRecordId &&
          other.maintenanceScheduleId == this.maintenanceScheduleId &&
          other.itemName == this.itemName &&
          other.category == this.category &&
          other.itemCost == this.itemCost &&
          other.notes == this.notes);
}

class ServiceRecordItemsCompanion
    extends UpdateCompanion<ServiceRecordItemRow> {
  final Value<String> id;
  final Value<String> serviceRecordId;
  final Value<String?> maintenanceScheduleId;
  final Value<String> itemName;
  final Value<String?> category;
  final Value<int> itemCost;
  final Value<String?> notes;
  final Value<int> rowid;
  const ServiceRecordItemsCompanion({
    this.id = const Value.absent(),
    this.serviceRecordId = const Value.absent(),
    this.maintenanceScheduleId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.category = const Value.absent(),
    this.itemCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceRecordItemsCompanion.insert({
    required String id,
    required String serviceRecordId,
    this.maintenanceScheduleId = const Value.absent(),
    required String itemName,
    this.category = const Value.absent(),
    this.itemCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        serviceRecordId = Value(serviceRecordId),
        itemName = Value(itemName);
  static Insertable<ServiceRecordItemRow> custom({
    Expression<String>? id,
    Expression<String>? serviceRecordId,
    Expression<String>? maintenanceScheduleId,
    Expression<String>? itemName,
    Expression<String>? category,
    Expression<int>? itemCost,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceRecordId != null) 'service_record_id': serviceRecordId,
      if (maintenanceScheduleId != null)
        'maintenance_schedule_id': maintenanceScheduleId,
      if (itemName != null) 'item_name': itemName,
      if (category != null) 'category': category,
      if (itemCost != null) 'item_cost': itemCost,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceRecordItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? serviceRecordId,
      Value<String?>? maintenanceScheduleId,
      Value<String>? itemName,
      Value<String?>? category,
      Value<int>? itemCost,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return ServiceRecordItemsCompanion(
      id: id ?? this.id,
      serviceRecordId: serviceRecordId ?? this.serviceRecordId,
      maintenanceScheduleId:
          maintenanceScheduleId ?? this.maintenanceScheduleId,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      itemCost: itemCost ?? this.itemCost,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serviceRecordId.present) {
      map['service_record_id'] = Variable<String>(serviceRecordId.value);
    }
    if (maintenanceScheduleId.present) {
      map['maintenance_schedule_id'] =
          Variable<String>(maintenanceScheduleId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (itemCost.present) {
      map['item_cost'] = Variable<int>(itemCost.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecordItemsCompanion(')
          ..write('id: $id, ')
          ..write('serviceRecordId: $serviceRecordId, ')
          ..write('maintenanceScheduleId: $maintenanceScheduleId, ')
          ..write('itemName: $itemName, ')
          ..write('category: $category, ')
          ..write('itemCost: $itemCost, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceAttachmentsTable extends ServiceAttachments
    with TableInfo<$ServiceAttachmentsTable, ServiceAttachmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serviceRecordIdMeta =
      const VerificationMeta('serviceRecordId');
  @override
  late final GeneratedColumn<String> serviceRecordId = GeneratedColumn<String>(
      'service_record_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES service_records (id) ON DELETE CASCADE'));
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, serviceRecordId, localPath, fileName, mimeType, fileSize, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_attachments';
  @override
  VerificationContext validateIntegrity(
      Insertable<ServiceAttachmentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('service_record_id')) {
      context.handle(
          _serviceRecordIdMeta,
          serviceRecordId.isAcceptableOrUnknown(
              data['service_record_id']!, _serviceRecordIdMeta));
    } else if (isInserting) {
      context.missing(_serviceRecordIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceAttachmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceAttachmentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      serviceRecordId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}service_record_id'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ServiceAttachmentsTable createAlias(String alias) {
    return $ServiceAttachmentsTable(attachedDatabase, alias);
  }
}

class ServiceAttachmentRow extends DataClass
    implements Insertable<ServiceAttachmentRow> {
  final String id;
  final String serviceRecordId;
  final String localPath;
  final String fileName;
  final String mimeType;
  final int fileSize;
  final String createdAt;
  const ServiceAttachmentRow(
      {required this.id,
      required this.serviceRecordId,
      required this.localPath,
      required this.fileName,
      required this.mimeType,
      required this.fileSize,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['service_record_id'] = Variable<String>(serviceRecordId);
    map['local_path'] = Variable<String>(localPath);
    map['file_name'] = Variable<String>(fileName);
    map['mime_type'] = Variable<String>(mimeType);
    map['file_size'] = Variable<int>(fileSize);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  ServiceAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return ServiceAttachmentsCompanion(
      id: Value(id),
      serviceRecordId: Value(serviceRecordId),
      localPath: Value(localPath),
      fileName: Value(fileName),
      mimeType: Value(mimeType),
      fileSize: Value(fileSize),
      createdAt: Value(createdAt),
    );
  }

  factory ServiceAttachmentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceAttachmentRow(
      id: serializer.fromJson<String>(json['id']),
      serviceRecordId: serializer.fromJson<String>(json['serviceRecordId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      fileName: serializer.fromJson<String>(json['fileName']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serviceRecordId': serializer.toJson<String>(serviceRecordId),
      'localPath': serializer.toJson<String>(localPath),
      'fileName': serializer.toJson<String>(fileName),
      'mimeType': serializer.toJson<String>(mimeType),
      'fileSize': serializer.toJson<int>(fileSize),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  ServiceAttachmentRow copyWith(
          {String? id,
          String? serviceRecordId,
          String? localPath,
          String? fileName,
          String? mimeType,
          int? fileSize,
          String? createdAt}) =>
      ServiceAttachmentRow(
        id: id ?? this.id,
        serviceRecordId: serviceRecordId ?? this.serviceRecordId,
        localPath: localPath ?? this.localPath,
        fileName: fileName ?? this.fileName,
        mimeType: mimeType ?? this.mimeType,
        fileSize: fileSize ?? this.fileSize,
        createdAt: createdAt ?? this.createdAt,
      );
  ServiceAttachmentRow copyWithCompanion(ServiceAttachmentsCompanion data) {
    return ServiceAttachmentRow(
      id: data.id.present ? data.id.value : this.id,
      serviceRecordId: data.serviceRecordId.present
          ? data.serviceRecordId.value
          : this.serviceRecordId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceAttachmentRow(')
          ..write('id: $id, ')
          ..write('serviceRecordId: $serviceRecordId, ')
          ..write('localPath: $localPath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, serviceRecordId, localPath, fileName, mimeType, fileSize, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceAttachmentRow &&
          other.id == this.id &&
          other.serviceRecordId == this.serviceRecordId &&
          other.localPath == this.localPath &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.fileSize == this.fileSize &&
          other.createdAt == this.createdAt);
}

class ServiceAttachmentsCompanion
    extends UpdateCompanion<ServiceAttachmentRow> {
  final Value<String> id;
  final Value<String> serviceRecordId;
  final Value<String> localPath;
  final Value<String> fileName;
  final Value<String> mimeType;
  final Value<int> fileSize;
  final Value<String> createdAt;
  final Value<int> rowid;
  const ServiceAttachmentsCompanion({
    this.id = const Value.absent(),
    this.serviceRecordId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceAttachmentsCompanion.insert({
    required String id,
    required String serviceRecordId,
    required String localPath,
    required String fileName,
    required String mimeType,
    required int fileSize,
    required String createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        serviceRecordId = Value(serviceRecordId),
        localPath = Value(localPath),
        fileName = Value(fileName),
        mimeType = Value(mimeType),
        fileSize = Value(fileSize),
        createdAt = Value(createdAt);
  static Insertable<ServiceAttachmentRow> custom({
    Expression<String>? id,
    Expression<String>? serviceRecordId,
    Expression<String>? localPath,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<int>? fileSize,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceRecordId != null) 'service_record_id': serviceRecordId,
      if (localPath != null) 'local_path': localPath,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (fileSize != null) 'file_size': fileSize,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceAttachmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? serviceRecordId,
      Value<String>? localPath,
      Value<String>? fileName,
      Value<String>? mimeType,
      Value<int>? fileSize,
      Value<String>? createdAt,
      Value<int>? rowid}) {
    return ServiceAttachmentsCompanion(
      id: id ?? this.id,
      serviceRecordId: serviceRecordId ?? this.serviceRecordId,
      localPath: localPath ?? this.localPath,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serviceRecordId.present) {
      map['service_record_id'] = Variable<String>(serviceRecordId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('serviceRecordId: $serviceRecordId, ')
          ..write('localPath: $localPath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSettingRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String value;
  final String updatedAt;
  const AppSettingRow(
      {required this.key, required this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  AppSettingRow copyWith({String? key, String? value, String? updatedAt}) =>
      AppSettingRow(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value),
        updatedAt = Value(updatedAt);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key,
      Value<String>? value,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationJobsTable extends NotificationJobs
    with TableInfo<$NotificationJobsTable, NotificationJobRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _maintenanceScheduleIdMeta =
      const VerificationMeta('maintenanceScheduleId');
  @override
  late final GeneratedColumn<String> maintenanceScheduleId =
      GeneratedColumn<String>('maintenance_schedule_id', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES maintenance_schedules (id) ON DELETE CASCADE'));
  static const VerificationMeta _cycleKeyMeta =
      const VerificationMeta('cycleKey');
  @override
  late final GeneratedColumn<String> cycleKey = GeneratedColumn<String>(
      'cycle_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggerTypeMeta =
      const VerificationMeta('triggerType');
  @override
  late final GeneratedColumn<String> triggerType = GeneratedColumn<String>(
      'trigger_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _platformNotificationIdMeta =
      const VerificationMeta('platformNotificationId');
  @override
  late final GeneratedColumn<int> platformNotificationId = GeneratedColumn<int>(
      'platform_notification_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _plannedAtMeta =
      const VerificationMeta('plannedAt');
  @override
  late final GeneratedColumn<String> plannedAt = GeneratedColumn<String>(
      'planned_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        maintenanceScheduleId,
        cycleKey,
        triggerType,
        platformNotificationId,
        plannedAt,
        state,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_jobs';
  @override
  VerificationContext validateIntegrity(Insertable<NotificationJobRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('maintenance_schedule_id')) {
      context.handle(
          _maintenanceScheduleIdMeta,
          maintenanceScheduleId.isAcceptableOrUnknown(
              data['maintenance_schedule_id']!, _maintenanceScheduleIdMeta));
    } else if (isInserting) {
      context.missing(_maintenanceScheduleIdMeta);
    }
    if (data.containsKey('cycle_key')) {
      context.handle(_cycleKeyMeta,
          cycleKey.isAcceptableOrUnknown(data['cycle_key']!, _cycleKeyMeta));
    } else if (isInserting) {
      context.missing(_cycleKeyMeta);
    }
    if (data.containsKey('trigger_type')) {
      context.handle(
          _triggerTypeMeta,
          triggerType.isAcceptableOrUnknown(
              data['trigger_type']!, _triggerTypeMeta));
    } else if (isInserting) {
      context.missing(_triggerTypeMeta);
    }
    if (data.containsKey('platform_notification_id')) {
      context.handle(
          _platformNotificationIdMeta,
          platformNotificationId.isAcceptableOrUnknown(
              data['platform_notification_id']!, _platformNotificationIdMeta));
    } else if (isInserting) {
      context.missing(_platformNotificationIdMeta);
    }
    if (data.containsKey('planned_at')) {
      context.handle(_plannedAtMeta,
          plannedAt.isAcceptableOrUnknown(data['planned_at']!, _plannedAtMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {maintenanceScheduleId, cycleKey, triggerType},
      ];
  @override
  NotificationJobRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationJobRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      maintenanceScheduleId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}maintenance_schedule_id'])!,
      cycleKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cycle_key'])!,
      triggerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trigger_type'])!,
      platformNotificationId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}platform_notification_id'])!,
      plannedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}planned_at']),
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NotificationJobsTable createAlias(String alias) {
    return $NotificationJobsTable(attachedDatabase, alias);
  }
}

class NotificationJobRow extends DataClass
    implements Insertable<NotificationJobRow> {
  final String id;
  final String maintenanceScheduleId;
  final String cycleKey;
  final String triggerType;
  final int platformNotificationId;
  final String? plannedAt;
  final String state;
  final String createdAt;
  final String updatedAt;
  const NotificationJobRow(
      {required this.id,
      required this.maintenanceScheduleId,
      required this.cycleKey,
      required this.triggerType,
      required this.platformNotificationId,
      this.plannedAt,
      required this.state,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['maintenance_schedule_id'] = Variable<String>(maintenanceScheduleId);
    map['cycle_key'] = Variable<String>(cycleKey);
    map['trigger_type'] = Variable<String>(triggerType);
    map['platform_notification_id'] = Variable<int>(platformNotificationId);
    if (!nullToAbsent || plannedAt != null) {
      map['planned_at'] = Variable<String>(plannedAt);
    }
    map['state'] = Variable<String>(state);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  NotificationJobsCompanion toCompanion(bool nullToAbsent) {
    return NotificationJobsCompanion(
      id: Value(id),
      maintenanceScheduleId: Value(maintenanceScheduleId),
      cycleKey: Value(cycleKey),
      triggerType: Value(triggerType),
      platformNotificationId: Value(platformNotificationId),
      plannedAt: plannedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedAt),
      state: Value(state),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotificationJobRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationJobRow(
      id: serializer.fromJson<String>(json['id']),
      maintenanceScheduleId:
          serializer.fromJson<String>(json['maintenanceScheduleId']),
      cycleKey: serializer.fromJson<String>(json['cycleKey']),
      triggerType: serializer.fromJson<String>(json['triggerType']),
      platformNotificationId:
          serializer.fromJson<int>(json['platformNotificationId']),
      plannedAt: serializer.fromJson<String?>(json['plannedAt']),
      state: serializer.fromJson<String>(json['state']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'maintenanceScheduleId': serializer.toJson<String>(maintenanceScheduleId),
      'cycleKey': serializer.toJson<String>(cycleKey),
      'triggerType': serializer.toJson<String>(triggerType),
      'platformNotificationId': serializer.toJson<int>(platformNotificationId),
      'plannedAt': serializer.toJson<String?>(plannedAt),
      'state': serializer.toJson<String>(state),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  NotificationJobRow copyWith(
          {String? id,
          String? maintenanceScheduleId,
          String? cycleKey,
          String? triggerType,
          int? platformNotificationId,
          Value<String?> plannedAt = const Value.absent(),
          String? state,
          String? createdAt,
          String? updatedAt}) =>
      NotificationJobRow(
        id: id ?? this.id,
        maintenanceScheduleId:
            maintenanceScheduleId ?? this.maintenanceScheduleId,
        cycleKey: cycleKey ?? this.cycleKey,
        triggerType: triggerType ?? this.triggerType,
        platformNotificationId:
            platformNotificationId ?? this.platformNotificationId,
        plannedAt: plannedAt.present ? plannedAt.value : this.plannedAt,
        state: state ?? this.state,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NotificationJobRow copyWithCompanion(NotificationJobsCompanion data) {
    return NotificationJobRow(
      id: data.id.present ? data.id.value : this.id,
      maintenanceScheduleId: data.maintenanceScheduleId.present
          ? data.maintenanceScheduleId.value
          : this.maintenanceScheduleId,
      cycleKey: data.cycleKey.present ? data.cycleKey.value : this.cycleKey,
      triggerType:
          data.triggerType.present ? data.triggerType.value : this.triggerType,
      platformNotificationId: data.platformNotificationId.present
          ? data.platformNotificationId.value
          : this.platformNotificationId,
      plannedAt: data.plannedAt.present ? data.plannedAt.value : this.plannedAt,
      state: data.state.present ? data.state.value : this.state,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationJobRow(')
          ..write('id: $id, ')
          ..write('maintenanceScheduleId: $maintenanceScheduleId, ')
          ..write('cycleKey: $cycleKey, ')
          ..write('triggerType: $triggerType, ')
          ..write('platformNotificationId: $platformNotificationId, ')
          ..write('plannedAt: $plannedAt, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      maintenanceScheduleId,
      cycleKey,
      triggerType,
      platformNotificationId,
      plannedAt,
      state,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationJobRow &&
          other.id == this.id &&
          other.maintenanceScheduleId == this.maintenanceScheduleId &&
          other.cycleKey == this.cycleKey &&
          other.triggerType == this.triggerType &&
          other.platformNotificationId == this.platformNotificationId &&
          other.plannedAt == this.plannedAt &&
          other.state == this.state &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotificationJobsCompanion extends UpdateCompanion<NotificationJobRow> {
  final Value<String> id;
  final Value<String> maintenanceScheduleId;
  final Value<String> cycleKey;
  final Value<String> triggerType;
  final Value<int> platformNotificationId;
  final Value<String?> plannedAt;
  final Value<String> state;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const NotificationJobsCompanion({
    this.id = const Value.absent(),
    this.maintenanceScheduleId = const Value.absent(),
    this.cycleKey = const Value.absent(),
    this.triggerType = const Value.absent(),
    this.platformNotificationId = const Value.absent(),
    this.plannedAt = const Value.absent(),
    this.state = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationJobsCompanion.insert({
    required String id,
    required String maintenanceScheduleId,
    required String cycleKey,
    required String triggerType,
    required int platformNotificationId,
    this.plannedAt = const Value.absent(),
    required String state,
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        maintenanceScheduleId = Value(maintenanceScheduleId),
        cycleKey = Value(cycleKey),
        triggerType = Value(triggerType),
        platformNotificationId = Value(platformNotificationId),
        state = Value(state),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NotificationJobRow> custom({
    Expression<String>? id,
    Expression<String>? maintenanceScheduleId,
    Expression<String>? cycleKey,
    Expression<String>? triggerType,
    Expression<int>? platformNotificationId,
    Expression<String>? plannedAt,
    Expression<String>? state,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maintenanceScheduleId != null)
        'maintenance_schedule_id': maintenanceScheduleId,
      if (cycleKey != null) 'cycle_key': cycleKey,
      if (triggerType != null) 'trigger_type': triggerType,
      if (platformNotificationId != null)
        'platform_notification_id': platformNotificationId,
      if (plannedAt != null) 'planned_at': plannedAt,
      if (state != null) 'state': state,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationJobsCompanion copyWith(
      {Value<String>? id,
      Value<String>? maintenanceScheduleId,
      Value<String>? cycleKey,
      Value<String>? triggerType,
      Value<int>? platformNotificationId,
      Value<String?>? plannedAt,
      Value<String>? state,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return NotificationJobsCompanion(
      id: id ?? this.id,
      maintenanceScheduleId:
          maintenanceScheduleId ?? this.maintenanceScheduleId,
      cycleKey: cycleKey ?? this.cycleKey,
      triggerType: triggerType ?? this.triggerType,
      platformNotificationId:
          platformNotificationId ?? this.platformNotificationId,
      plannedAt: plannedAt ?? this.plannedAt,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (maintenanceScheduleId.present) {
      map['maintenance_schedule_id'] =
          Variable<String>(maintenanceScheduleId.value);
    }
    if (cycleKey.present) {
      map['cycle_key'] = Variable<String>(cycleKey.value);
    }
    if (triggerType.present) {
      map['trigger_type'] = Variable<String>(triggerType.value);
    }
    if (platformNotificationId.present) {
      map['platform_notification_id'] =
          Variable<int>(platformNotificationId.value);
    }
    if (plannedAt.present) {
      map['planned_at'] = Variable<String>(plannedAt.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationJobsCompanion(')
          ..write('id: $id, ')
          ..write('maintenanceScheduleId: $maintenanceScheduleId, ')
          ..write('cycleKey: $cycleKey, ')
          ..write('triggerType: $triggerType, ')
          ..write('platformNotificationId: $platformNotificationId, ')
          ..write('plannedAt: $plannedAt, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MotorcyclesTable motorcycles = $MotorcyclesTable(this);
  late final $ServiceRecordsTable serviceRecords = $ServiceRecordsTable(this);
  late final $OdometerReadingsTable odometerReadings =
      $OdometerReadingsTable(this);
  late final $MaintenanceSchedulesTable maintenanceSchedules =
      $MaintenanceSchedulesTable(this);
  late final $ServiceRecordItemsTable serviceRecordItems =
      $ServiceRecordItemsTable(this);
  late final $ServiceAttachmentsTable serviceAttachments =
      $ServiceAttachmentsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $NotificationJobsTable notificationJobs =
      $NotificationJobsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        motorcycles,
        serviceRecords,
        odometerReadings,
        maintenanceSchedules,
        serviceRecordItems,
        serviceAttachments,
        appSettings,
        notificationJobs
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('motorcycles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('service_records', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('motorcycles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('odometer_readings', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('service_records',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('odometer_readings', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('motorcycles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('maintenance_schedules', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('service_records',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('service_record_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('maintenance_schedules',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('service_record_items', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('service_records',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('service_attachments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('maintenance_schedules',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('notification_jobs', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$MotorcyclesTableCreateCompanionBuilder = MotorcyclesCompanion
    Function({
  required String id,
  required String nickname,
  required String brand,
  required String model,
  required String motorcycleType,
  Value<int?> manufactureYear,
  Value<String?> licensePlate,
  required String propulsionType,
  Value<String?> notes,
  required String createdAt,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$MotorcyclesTableUpdateCompanionBuilder = MotorcyclesCompanion
    Function({
  Value<String> id,
  Value<String> nickname,
  Value<String> brand,
  Value<String> model,
  Value<String> motorcycleType,
  Value<int?> manufactureYear,
  Value<String?> licensePlate,
  Value<String> propulsionType,
  Value<String?> notes,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<int> rowid,
});

final class $$MotorcyclesTableReferences
    extends BaseReferences<_$AppDatabase, $MotorcyclesTable, MotorcycleRow> {
  $$MotorcyclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ServiceRecordsTable, List<ServiceRecordRow>>
      _serviceRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.serviceRecords,
              aliasName: 'motorcycles__id__service_records__motorcycle_id');

  $$ServiceRecordsTableProcessedTableManager get serviceRecordsRefs {
    final manager = $$ServiceRecordsTableTableManager($_db, $_db.serviceRecords)
        .filter(
            (f) => f.motorcycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OdometerReadingsTable, List<OdometerReadingRow>>
      _odometerReadingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.odometerReadings,
              aliasName: 'motorcycles__id__odometer_readings__motorcycle_id');

  $$OdometerReadingsTableProcessedTableManager get odometerReadingsRefs {
    final manager =
        $$OdometerReadingsTableTableManager($_db, $_db.odometerReadings).filter(
            (f) => f.motorcycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_odometerReadingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MaintenanceSchedulesTable,
      List<MaintenanceScheduleRow>> _maintenanceSchedulesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceSchedules,
          aliasName: 'motorcycles__id__maintenance_schedules__motorcycle_id');

  $$MaintenanceSchedulesTableProcessedTableManager
      get maintenanceSchedulesRefs {
    final manager = $$MaintenanceSchedulesTableTableManager(
            $_db, $_db.maintenanceSchedules)
        .filter(
            (f) => f.motorcycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceSchedulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MotorcyclesTableFilterComposer
    extends Composer<_$AppDatabase, $MotorcyclesTable> {
  $$MotorcyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motorcycleType => $composableBuilder(
      column: $table.motorcycleType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get manufactureYear => $composableBuilder(
      column: $table.manufactureYear,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get licensePlate => $composableBuilder(
      column: $table.licensePlate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get propulsionType => $composableBuilder(
      column: $table.propulsionType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> serviceRecordsRefs(
      Expression<bool> Function($$ServiceRecordsTableFilterComposer f) f) {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> odometerReadingsRefs(
      Expression<bool> Function($$OdometerReadingsTableFilterComposer f) f) {
    final $$OdometerReadingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.odometerReadings,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OdometerReadingsTableFilterComposer(
              $db: $db,
              $table: $db.odometerReadings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> maintenanceSchedulesRefs(
      Expression<bool> Function($$MaintenanceSchedulesTableFilterComposer f)
          f) {
    final $$MaintenanceSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceSchedules,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MotorcyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $MotorcyclesTable> {
  $$MotorcyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motorcycleType => $composableBuilder(
      column: $table.motorcycleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get manufactureYear => $composableBuilder(
      column: $table.manufactureYear,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get licensePlate => $composableBuilder(
      column: $table.licensePlate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get propulsionType => $composableBuilder(
      column: $table.propulsionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MotorcyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MotorcyclesTable> {
  $$MotorcyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get motorcycleType => $composableBuilder(
      column: $table.motorcycleType, builder: (column) => column);

  GeneratedColumn<int> get manufactureYear => $composableBuilder(
      column: $table.manufactureYear, builder: (column) => column);

  GeneratedColumn<String> get licensePlate => $composableBuilder(
      column: $table.licensePlate, builder: (column) => column);

  GeneratedColumn<String> get propulsionType => $composableBuilder(
      column: $table.propulsionType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> serviceRecordsRefs<T extends Object>(
      Expression<T> Function($$ServiceRecordsTableAnnotationComposer a) f) {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> odometerReadingsRefs<T extends Object>(
      Expression<T> Function($$OdometerReadingsTableAnnotationComposer a) f) {
    final $$OdometerReadingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.odometerReadings,
        getReferencedColumn: (t) => t.motorcycleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OdometerReadingsTableAnnotationComposer(
              $db: $db,
              $table: $db.odometerReadings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> maintenanceSchedulesRefs<T extends Object>(
      Expression<T> Function($$MaintenanceSchedulesTableAnnotationComposer a)
          f) {
    final $$MaintenanceSchedulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceSchedules,
            getReferencedColumn: (t) => t.motorcycleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceSchedulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceSchedules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MotorcyclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MotorcyclesTable,
    MotorcycleRow,
    $$MotorcyclesTableFilterComposer,
    $$MotorcyclesTableOrderingComposer,
    $$MotorcyclesTableAnnotationComposer,
    $$MotorcyclesTableCreateCompanionBuilder,
    $$MotorcyclesTableUpdateCompanionBuilder,
    (MotorcycleRow, $$MotorcyclesTableReferences),
    MotorcycleRow,
    PrefetchHooks Function(
        {bool serviceRecordsRefs,
        bool odometerReadingsRefs,
        bool maintenanceSchedulesRefs})> {
  $$MotorcyclesTableTableManager(_$AppDatabase db, $MotorcyclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MotorcyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MotorcyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MotorcyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nickname = const Value.absent(),
            Value<String> brand = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<String> motorcycleType = const Value.absent(),
            Value<int?> manufactureYear = const Value.absent(),
            Value<String?> licensePlate = const Value.absent(),
            Value<String> propulsionType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MotorcyclesCompanion(
            id: id,
            nickname: nickname,
            brand: brand,
            model: model,
            motorcycleType: motorcycleType,
            manufactureYear: manufactureYear,
            licensePlate: licensePlate,
            propulsionType: propulsionType,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nickname,
            required String brand,
            required String model,
            required String motorcycleType,
            Value<int?> manufactureYear = const Value.absent(),
            Value<String?> licensePlate = const Value.absent(),
            required String propulsionType,
            Value<String?> notes = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MotorcyclesCompanion.insert(
            id: id,
            nickname: nickname,
            brand: brand,
            model: model,
            motorcycleType: motorcycleType,
            manufactureYear: manufactureYear,
            licensePlate: licensePlate,
            propulsionType: propulsionType,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MotorcyclesTable, MotorcycleRow>(table),
                    $$MotorcyclesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {serviceRecordsRefs = false,
              odometerReadingsRefs = false,
              maintenanceSchedulesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (serviceRecordsRefs) db.serviceRecords,
                if (odometerReadingsRefs) db.odometerReadings,
                if (maintenanceSchedulesRefs) db.maintenanceSchedules
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serviceRecordsRefs)
                    await $_getPrefetchedDataByColumns<
                            MotorcycleRow,
                            $MotorcyclesTable,
                            ServiceRecordRow,
                            $ServiceRecordsTable>(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._serviceRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .serviceRecordsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'motorcycle_id',
                        typedResults: items),
                  if (odometerReadingsRefs)
                    await $_getPrefetchedDataByColumns<
                            MotorcycleRow,
                            $MotorcyclesTable,
                            OdometerReadingRow,
                            $OdometerReadingsTable>(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._odometerReadingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .odometerReadingsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'motorcycle_id',
                        typedResults: items),
                  if (maintenanceSchedulesRefs)
                    await $_getPrefetchedDataByColumns<
                            MotorcycleRow,
                            $MotorcyclesTable,
                            MaintenanceScheduleRow,
                            $MaintenanceSchedulesTable>(
                        currentTable: table,
                        referencedTable: $$MotorcyclesTableReferences
                            ._maintenanceSchedulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MotorcyclesTableReferences(db, table, p0)
                                .maintenanceSchedulesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'motorcycle_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MotorcyclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MotorcyclesTable,
    MotorcycleRow,
    $$MotorcyclesTableFilterComposer,
    $$MotorcyclesTableOrderingComposer,
    $$MotorcyclesTableAnnotationComposer,
    $$MotorcyclesTableCreateCompanionBuilder,
    $$MotorcyclesTableUpdateCompanionBuilder,
    (MotorcycleRow, $$MotorcyclesTableReferences),
    MotorcycleRow,
    PrefetchHooks Function(
        {bool serviceRecordsRefs,
        bool odometerReadingsRefs,
        bool maintenanceSchedulesRefs})>;
typedef $$ServiceRecordsTableCreateCompanionBuilder = ServiceRecordsCompanion
    Function({
  required String id,
  required String motorcycleId,
  required String serviceDate,
  required int odometerKm,
  Value<String?> workshopName,
  Value<int> additionalCost,
  Value<String?> notes,
  required String createdAt,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$ServiceRecordsTableUpdateCompanionBuilder = ServiceRecordsCompanion
    Function({
  Value<String> id,
  Value<String> motorcycleId,
  Value<String> serviceDate,
  Value<int> odometerKm,
  Value<String?> workshopName,
  Value<int> additionalCost,
  Value<String?> notes,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<int> rowid,
});

final class $$ServiceRecordsTableReferences extends BaseReferences<
    _$AppDatabase, $ServiceRecordsTable, ServiceRecordRow> {
  $$ServiceRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles
          .createAlias('service_records__motorcycle_id__motorcycles__id');

  $$MotorcyclesTableProcessedTableManager get motorcycleId {
    final $_column = $_itemColumn<String>('motorcycle_id')!;

    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OdometerReadingsTable, List<OdometerReadingRow>>
      _odometerReadingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.odometerReadings,
              aliasName:
                  'service_records__id__odometer_readings__service_record_id');

  $$OdometerReadingsTableProcessedTableManager get odometerReadingsRefs {
    final manager =
        $$OdometerReadingsTableTableManager($_db, $_db.odometerReadings).filter(
            (f) => f.serviceRecordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_odometerReadingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ServiceRecordItemsTable,
      List<ServiceRecordItemRow>> _serviceRecordItemsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.serviceRecordItems,
          aliasName:
              'service_records__id__service_record_items__service_record_id');

  $$ServiceRecordItemsTableProcessedTableManager get serviceRecordItemsRefs {
    final manager = $$ServiceRecordItemsTableTableManager(
            $_db, $_db.serviceRecordItems)
        .filter(
            (f) => f.serviceRecordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_serviceRecordItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ServiceAttachmentsTable,
      List<ServiceAttachmentRow>> _serviceAttachmentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.serviceAttachments,
          aliasName:
              'service_records__id__service_attachments__service_record_id');

  $$ServiceAttachmentsTableProcessedTableManager get serviceAttachmentsRefs {
    final manager = $$ServiceAttachmentsTableTableManager(
            $_db, $_db.serviceAttachments)
        .filter(
            (f) => f.serviceRecordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_serviceAttachmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ServiceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceRecordsTable> {
  $$ServiceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serviceDate => $composableBuilder(
      column: $table.serviceDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workshopName => $composableBuilder(
      column: $table.workshopName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get additionalCost => $composableBuilder(
      column: $table.additionalCost,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> odometerReadingsRefs(
      Expression<bool> Function($$OdometerReadingsTableFilterComposer f) f) {
    final $$OdometerReadingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.odometerReadings,
        getReferencedColumn: (t) => t.serviceRecordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OdometerReadingsTableFilterComposer(
              $db: $db,
              $table: $db.odometerReadings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> serviceRecordItemsRefs(
      Expression<bool> Function($$ServiceRecordItemsTableFilterComposer f) f) {
    final $$ServiceRecordItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceRecordItems,
        getReferencedColumn: (t) => t.serviceRecordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordItemsTableFilterComposer(
              $db: $db,
              $table: $db.serviceRecordItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> serviceAttachmentsRefs(
      Expression<bool> Function($$ServiceAttachmentsTableFilterComposer f) f) {
    final $$ServiceAttachmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceAttachments,
        getReferencedColumn: (t) => t.serviceRecordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceAttachmentsTableFilterComposer(
              $db: $db,
              $table: $db.serviceAttachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ServiceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceRecordsTable> {
  $$ServiceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serviceDate => $composableBuilder(
      column: $table.serviceDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workshopName => $composableBuilder(
      column: $table.workshopName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get additionalCost => $composableBuilder(
      column: $table.additionalCost,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceRecordsTable> {
  $$ServiceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serviceDate => $composableBuilder(
      column: $table.serviceDate, builder: (column) => column);

  GeneratedColumn<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => column);

  GeneratedColumn<String> get workshopName => $composableBuilder(
      column: $table.workshopName, builder: (column) => column);

  GeneratedColumn<int> get additionalCost => $composableBuilder(
      column: $table.additionalCost, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> odometerReadingsRefs<T extends Object>(
      Expression<T> Function($$OdometerReadingsTableAnnotationComposer a) f) {
    final $$OdometerReadingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.odometerReadings,
        getReferencedColumn: (t) => t.serviceRecordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OdometerReadingsTableAnnotationComposer(
              $db: $db,
              $table: $db.odometerReadings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> serviceRecordItemsRefs<T extends Object>(
      Expression<T> Function($$ServiceRecordItemsTableAnnotationComposer a) f) {
    final $$ServiceRecordItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.serviceRecordItems,
            getReferencedColumn: (t) => t.serviceRecordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ServiceRecordItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.serviceRecordItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> serviceAttachmentsRefs<T extends Object>(
      Expression<T> Function($$ServiceAttachmentsTableAnnotationComposer a) f) {
    final $$ServiceAttachmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.serviceAttachments,
            getReferencedColumn: (t) => t.serviceRecordId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ServiceAttachmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.serviceAttachments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ServiceRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiceRecordsTable,
    ServiceRecordRow,
    $$ServiceRecordsTableFilterComposer,
    $$ServiceRecordsTableOrderingComposer,
    $$ServiceRecordsTableAnnotationComposer,
    $$ServiceRecordsTableCreateCompanionBuilder,
    $$ServiceRecordsTableUpdateCompanionBuilder,
    (ServiceRecordRow, $$ServiceRecordsTableReferences),
    ServiceRecordRow,
    PrefetchHooks Function(
        {bool motorcycleId,
        bool odometerReadingsRefs,
        bool serviceRecordItemsRefs,
        bool serviceAttachmentsRefs})> {
  $$ServiceRecordsTableTableManager(
      _$AppDatabase db, $ServiceRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> motorcycleId = const Value.absent(),
            Value<String> serviceDate = const Value.absent(),
            Value<int> odometerKm = const Value.absent(),
            Value<String?> workshopName = const Value.absent(),
            Value<int> additionalCost = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceRecordsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            serviceDate: serviceDate,
            odometerKm: odometerKm,
            workshopName: workshopName,
            additionalCost: additionalCost,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String motorcycleId,
            required String serviceDate,
            required int odometerKm,
            Value<String?> workshopName = const Value.absent(),
            Value<int> additionalCost = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceRecordsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            serviceDate: serviceDate,
            odometerKm: odometerKm,
            workshopName: workshopName,
            additionalCost: additionalCost,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ServiceRecordsTable, ServiceRecordRow>(table),
                    $$ServiceRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false,
              odometerReadingsRefs = false,
              serviceRecordItemsRefs = false,
              serviceAttachmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (odometerReadingsRefs) db.odometerReadings,
                if (serviceRecordItemsRefs) db.serviceRecordItems,
                if (serviceAttachmentsRefs) db.serviceAttachments
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable:
                        $$ServiceRecordsTableReferences._motorcycleIdTable(db),
                    referencedColumn: $$ServiceRecordsTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (odometerReadingsRefs)
                    await $_getPrefetchedDataByColumns<
                            ServiceRecordRow,
                            $ServiceRecordsTable,
                            OdometerReadingRow,
                            $OdometerReadingsTable>(
                        currentTable: table,
                        referencedTable: $$ServiceRecordsTableReferences
                            ._odometerReadingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ServiceRecordsTableReferences(db, table, p0)
                                .odometerReadingsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'service_record_id',
                        typedResults: items),
                  if (serviceRecordItemsRefs)
                    await $_getPrefetchedDataByColumns<
                            ServiceRecordRow,
                            $ServiceRecordsTable,
                            ServiceRecordItemRow,
                            $ServiceRecordItemsTable>(
                        currentTable: table,
                        referencedTable: $$ServiceRecordsTableReferences
                            ._serviceRecordItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ServiceRecordsTableReferences(db, table, p0)
                                .serviceRecordItemsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'service_record_id',
                        typedResults: items),
                  if (serviceAttachmentsRefs)
                    await $_getPrefetchedDataByColumns<
                            ServiceRecordRow,
                            $ServiceRecordsTable,
                            ServiceAttachmentRow,
                            $ServiceAttachmentsTable>(
                        currentTable: table,
                        referencedTable: $$ServiceRecordsTableReferences
                            ._serviceAttachmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ServiceRecordsTableReferences(db, table, p0)
                                .serviceAttachmentsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'service_record_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ServiceRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiceRecordsTable,
    ServiceRecordRow,
    $$ServiceRecordsTableFilterComposer,
    $$ServiceRecordsTableOrderingComposer,
    $$ServiceRecordsTableAnnotationComposer,
    $$ServiceRecordsTableCreateCompanionBuilder,
    $$ServiceRecordsTableUpdateCompanionBuilder,
    (ServiceRecordRow, $$ServiceRecordsTableReferences),
    ServiceRecordRow,
    PrefetchHooks Function(
        {bool motorcycleId,
        bool odometerReadingsRefs,
        bool serviceRecordItemsRefs,
        bool serviceAttachmentsRefs})>;
typedef $$OdometerReadingsTableCreateCompanionBuilder
    = OdometerReadingsCompanion Function({
  required String id,
  required String motorcycleId,
  required int odometerKm,
  required String readingDate,
  required String source,
  Value<String?> notes,
  required String createdAt,
  Value<String?> serviceRecordId,
  Value<int> rowid,
});
typedef $$OdometerReadingsTableUpdateCompanionBuilder
    = OdometerReadingsCompanion Function({
  Value<String> id,
  Value<String> motorcycleId,
  Value<int> odometerKm,
  Value<String> readingDate,
  Value<String> source,
  Value<String?> notes,
  Value<String> createdAt,
  Value<String?> serviceRecordId,
  Value<int> rowid,
});

final class $$OdometerReadingsTableReferences extends BaseReferences<
    _$AppDatabase, $OdometerReadingsTable, OdometerReadingRow> {
  $$OdometerReadingsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles
          .createAlias('odometer_readings__motorcycle_id__motorcycles__id');

  $$MotorcyclesTableProcessedTableManager get motorcycleId {
    final $_column = $_itemColumn<String>('motorcycle_id')!;

    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ServiceRecordsTable _serviceRecordIdTable(_$AppDatabase db) => db
      .serviceRecords
      .createAlias('odometer_readings__service_record_id__service_records__id');

  $$ServiceRecordsTableProcessedTableManager? get serviceRecordId {
    final $_column = $_itemColumn<String>('service_record_id');
    if ($_column == null) return null;
    final manager = $$ServiceRecordsTableTableManager($_db, $_db.serviceRecords)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OdometerReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $OdometerReadingsTable> {
  $$OdometerReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get readingDate => $composableBuilder(
      column: $table.readingDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ServiceRecordsTableFilterComposer get serviceRecordId {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceRecordId,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OdometerReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $OdometerReadingsTable> {
  $$OdometerReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get readingDate => $composableBuilder(
      column: $table.readingDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ServiceRecordsTableOrderingComposer get serviceRecordId {
    final $$ServiceRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceRecordId,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OdometerReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OdometerReadingsTable> {
  $$OdometerReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get odometerKm => $composableBuilder(
      column: $table.odometerKm, builder: (column) => column);

  GeneratedColumn<String> get readingDate => $composableBuilder(
      column: $table.readingDate, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ServiceRecordsTableAnnotationComposer get serviceRecordId {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceRecordId,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OdometerReadingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OdometerReadingsTable,
    OdometerReadingRow,
    $$OdometerReadingsTableFilterComposer,
    $$OdometerReadingsTableOrderingComposer,
    $$OdometerReadingsTableAnnotationComposer,
    $$OdometerReadingsTableCreateCompanionBuilder,
    $$OdometerReadingsTableUpdateCompanionBuilder,
    (OdometerReadingRow, $$OdometerReadingsTableReferences),
    OdometerReadingRow,
    PrefetchHooks Function({bool motorcycleId, bool serviceRecordId})> {
  $$OdometerReadingsTableTableManager(
      _$AppDatabase db, $OdometerReadingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OdometerReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OdometerReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OdometerReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> motorcycleId = const Value.absent(),
            Value<int> odometerKm = const Value.absent(),
            Value<String> readingDate = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String?> serviceRecordId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OdometerReadingsCompanion(
            id: id,
            motorcycleId: motorcycleId,
            odometerKm: odometerKm,
            readingDate: readingDate,
            source: source,
            notes: notes,
            createdAt: createdAt,
            serviceRecordId: serviceRecordId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String motorcycleId,
            required int odometerKm,
            required String readingDate,
            required String source,
            Value<String?> notes = const Value.absent(),
            required String createdAt,
            Value<String?> serviceRecordId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OdometerReadingsCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            odometerKm: odometerKm,
            readingDate: readingDate,
            source: source,
            notes: notes,
            createdAt: createdAt,
            serviceRecordId: serviceRecordId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$OdometerReadingsTable, OdometerReadingRow>(
                        table),
                    $$OdometerReadingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false, serviceRecordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable: $$OdometerReadingsTableReferences
                        ._motorcycleIdTable(db),
                    referencedColumn: $$OdometerReadingsTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }
                if (serviceRecordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.serviceRecordId,
                    referencedTable: $$OdometerReadingsTableReferences
                        ._serviceRecordIdTable(db),
                    referencedColumn: $$OdometerReadingsTableReferences
                        ._serviceRecordIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OdometerReadingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OdometerReadingsTable,
    OdometerReadingRow,
    $$OdometerReadingsTableFilterComposer,
    $$OdometerReadingsTableOrderingComposer,
    $$OdometerReadingsTableAnnotationComposer,
    $$OdometerReadingsTableCreateCompanionBuilder,
    $$OdometerReadingsTableUpdateCompanionBuilder,
    (OdometerReadingRow, $$OdometerReadingsTableReferences),
    OdometerReadingRow,
    PrefetchHooks Function({bool motorcycleId, bool serviceRecordId})>;
typedef $$MaintenanceSchedulesTableCreateCompanionBuilder
    = MaintenanceSchedulesCompanion Function({
  required String id,
  required String motorcycleId,
  required String name,
  Value<String?> category,
  Value<int?> intervalKm,
  Value<int?> intervalMonths,
  Value<int?> lastDoneKm,
  Value<String?> lastDoneDate,
  Value<int?> manualLastDoneKm,
  Value<String?> manualLastDoneDate,
  Value<int?> reminderLeadKm,
  Value<int?> reminderLeadDays,
  Value<bool> isActive,
  required String createdAt,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$MaintenanceSchedulesTableUpdateCompanionBuilder
    = MaintenanceSchedulesCompanion Function({
  Value<String> id,
  Value<String> motorcycleId,
  Value<String> name,
  Value<String?> category,
  Value<int?> intervalKm,
  Value<int?> intervalMonths,
  Value<int?> lastDoneKm,
  Value<String?> lastDoneDate,
  Value<int?> manualLastDoneKm,
  Value<String?> manualLastDoneDate,
  Value<int?> reminderLeadKm,
  Value<int?> reminderLeadDays,
  Value<bool> isActive,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<int> rowid,
});

final class $$MaintenanceSchedulesTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceSchedulesTable, MaintenanceScheduleRow> {
  $$MaintenanceSchedulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MotorcyclesTable _motorcycleIdTable(_$AppDatabase db) =>
      db.motorcycles
          .createAlias('maintenance_schedules__motorcycle_id__motorcycles__id');

  $$MotorcyclesTableProcessedTableManager get motorcycleId {
    final $_column = $_itemColumn<String>('motorcycle_id')!;

    final manager = $$MotorcyclesTableTableManager($_db, $_db.motorcycles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_motorcycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ServiceRecordItemsTable,
      List<ServiceRecordItemRow>> _serviceRecordItemsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.serviceRecordItems,
          aliasName:
              'maintenance_schedules__id__service_record_items__maintenance_schedule_id');

  $$ServiceRecordItemsTableProcessedTableManager get serviceRecordItemsRefs {
    final manager = $$ServiceRecordItemsTableTableManager(
            $_db, $_db.serviceRecordItems)
        .filter((f) =>
            f.maintenanceScheduleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_serviceRecordItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NotificationJobsTable,
      List<NotificationJobRow>> _notificationJobsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.notificationJobs,
          aliasName:
              'maintenance_schedules__id__notification_jobs__maintenance_schedule_id');

  $$NotificationJobsTableProcessedTableManager get notificationJobsRefs {
    final manager = $$NotificationJobsTableTableManager(
            $_db, $_db.notificationJobs)
        .filter((f) =>
            f.maintenanceScheduleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_notificationJobsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MaintenanceSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceSchedulesTable> {
  $$MaintenanceSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalKm => $composableBuilder(
      column: $table.intervalKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalMonths => $composableBuilder(
      column: $table.intervalMonths,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastDoneKm => $composableBuilder(
      column: $table.lastDoneKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastDoneDate => $composableBuilder(
      column: $table.lastDoneDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get manualLastDoneKm => $composableBuilder(
      column: $table.manualLastDoneKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get manualLastDoneDate => $composableBuilder(
      column: $table.manualLastDoneDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderLeadKm => $composableBuilder(
      column: $table.reminderLeadKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderLeadDays => $composableBuilder(
      column: $table.reminderLeadDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$MotorcyclesTableFilterComposer get motorcycleId {
    final $$MotorcyclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableFilterComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> serviceRecordItemsRefs(
      Expression<bool> Function($$ServiceRecordItemsTableFilterComposer f) f) {
    final $$ServiceRecordItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceRecordItems,
        getReferencedColumn: (t) => t.maintenanceScheduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordItemsTableFilterComposer(
              $db: $db,
              $table: $db.serviceRecordItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> notificationJobsRefs(
      Expression<bool> Function($$NotificationJobsTableFilterComposer f) f) {
    final $$NotificationJobsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notificationJobs,
        getReferencedColumn: (t) => t.maintenanceScheduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotificationJobsTableFilterComposer(
              $db: $db,
              $table: $db.notificationJobs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceSchedulesTable> {
  $$MaintenanceSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalKm => $composableBuilder(
      column: $table.intervalKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalMonths => $composableBuilder(
      column: $table.intervalMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastDoneKm => $composableBuilder(
      column: $table.lastDoneKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastDoneDate => $composableBuilder(
      column: $table.lastDoneDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get manualLastDoneKm => $composableBuilder(
      column: $table.manualLastDoneKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get manualLastDoneDate => $composableBuilder(
      column: $table.manualLastDoneDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderLeadKm => $composableBuilder(
      column: $table.reminderLeadKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderLeadDays => $composableBuilder(
      column: $table.reminderLeadDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$MotorcyclesTableOrderingComposer get motorcycleId {
    final $$MotorcyclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableOrderingComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaintenanceSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceSchedulesTable> {
  $$MaintenanceSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get intervalKm => $composableBuilder(
      column: $table.intervalKm, builder: (column) => column);

  GeneratedColumn<int> get intervalMonths => $composableBuilder(
      column: $table.intervalMonths, builder: (column) => column);

  GeneratedColumn<int> get lastDoneKm => $composableBuilder(
      column: $table.lastDoneKm, builder: (column) => column);

  GeneratedColumn<String> get lastDoneDate => $composableBuilder(
      column: $table.lastDoneDate, builder: (column) => column);

  GeneratedColumn<int> get manualLastDoneKm => $composableBuilder(
      column: $table.manualLastDoneKm, builder: (column) => column);

  GeneratedColumn<String> get manualLastDoneDate => $composableBuilder(
      column: $table.manualLastDoneDate, builder: (column) => column);

  GeneratedColumn<int> get reminderLeadKm => $composableBuilder(
      column: $table.reminderLeadKm, builder: (column) => column);

  GeneratedColumn<int> get reminderLeadDays => $composableBuilder(
      column: $table.reminderLeadDays, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MotorcyclesTableAnnotationComposer get motorcycleId {
    final $$MotorcyclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.motorcycleId,
        referencedTable: $db.motorcycles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MotorcyclesTableAnnotationComposer(
              $db: $db,
              $table: $db.motorcycles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> serviceRecordItemsRefs<T extends Object>(
      Expression<T> Function($$ServiceRecordItemsTableAnnotationComposer a) f) {
    final $$ServiceRecordItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.serviceRecordItems,
            getReferencedColumn: (t) => t.maintenanceScheduleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ServiceRecordItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.serviceRecordItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> notificationJobsRefs<T extends Object>(
      Expression<T> Function($$NotificationJobsTableAnnotationComposer a) f) {
    final $$NotificationJobsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notificationJobs,
        getReferencedColumn: (t) => t.maintenanceScheduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotificationJobsTableAnnotationComposer(
              $db: $db,
              $table: $db.notificationJobs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceSchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceSchedulesTable,
    MaintenanceScheduleRow,
    $$MaintenanceSchedulesTableFilterComposer,
    $$MaintenanceSchedulesTableOrderingComposer,
    $$MaintenanceSchedulesTableAnnotationComposer,
    $$MaintenanceSchedulesTableCreateCompanionBuilder,
    $$MaintenanceSchedulesTableUpdateCompanionBuilder,
    (MaintenanceScheduleRow, $$MaintenanceSchedulesTableReferences),
    MaintenanceScheduleRow,
    PrefetchHooks Function(
        {bool motorcycleId,
        bool serviceRecordItemsRefs,
        bool notificationJobsRefs})> {
  $$MaintenanceSchedulesTableTableManager(
      _$AppDatabase db, $MaintenanceSchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceSchedulesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceSchedulesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> motorcycleId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int?> intervalKm = const Value.absent(),
            Value<int?> intervalMonths = const Value.absent(),
            Value<int?> lastDoneKm = const Value.absent(),
            Value<String?> lastDoneDate = const Value.absent(),
            Value<int?> manualLastDoneKm = const Value.absent(),
            Value<String?> manualLastDoneDate = const Value.absent(),
            Value<int?> reminderLeadKm = const Value.absent(),
            Value<int?> reminderLeadDays = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceSchedulesCompanion(
            id: id,
            motorcycleId: motorcycleId,
            name: name,
            category: category,
            intervalKm: intervalKm,
            intervalMonths: intervalMonths,
            lastDoneKm: lastDoneKm,
            lastDoneDate: lastDoneDate,
            manualLastDoneKm: manualLastDoneKm,
            manualLastDoneDate: manualLastDoneDate,
            reminderLeadKm: reminderLeadKm,
            reminderLeadDays: reminderLeadDays,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String motorcycleId,
            required String name,
            Value<String?> category = const Value.absent(),
            Value<int?> intervalKm = const Value.absent(),
            Value<int?> intervalMonths = const Value.absent(),
            Value<int?> lastDoneKm = const Value.absent(),
            Value<String?> lastDoneDate = const Value.absent(),
            Value<int?> manualLastDoneKm = const Value.absent(),
            Value<String?> manualLastDoneDate = const Value.absent(),
            Value<int?> reminderLeadKm = const Value.absent(),
            Value<int?> reminderLeadDays = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceSchedulesCompanion.insert(
            id: id,
            motorcycleId: motorcycleId,
            name: name,
            category: category,
            intervalKm: intervalKm,
            intervalMonths: intervalMonths,
            lastDoneKm: lastDoneKm,
            lastDoneDate: lastDoneDate,
            manualLastDoneKm: manualLastDoneKm,
            manualLastDoneDate: manualLastDoneDate,
            reminderLeadKm: reminderLeadKm,
            reminderLeadDays: reminderLeadDays,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MaintenanceSchedulesTable,
                        MaintenanceScheduleRow>(table),
                    $$MaintenanceSchedulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {motorcycleId = false,
              serviceRecordItemsRefs = false,
              notificationJobsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (serviceRecordItemsRefs) db.serviceRecordItems,
                if (notificationJobsRefs) db.notificationJobs
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (motorcycleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.motorcycleId,
                    referencedTable: $$MaintenanceSchedulesTableReferences
                        ._motorcycleIdTable(db),
                    referencedColumn: $$MaintenanceSchedulesTableReferences
                        ._motorcycleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serviceRecordItemsRefs)
                    await $_getPrefetchedDataByColumns<
                            MaintenanceScheduleRow,
                            $MaintenanceSchedulesTable,
                            ServiceRecordItemRow,
                            $ServiceRecordItemsTable>(
                        currentTable: table,
                        referencedTable: $$MaintenanceSchedulesTableReferences
                            ._serviceRecordItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceSchedulesTableReferences(db, table, p0)
                                .serviceRecordItemsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'maintenance_schedule_id',
                        typedResults: items),
                  if (notificationJobsRefs)
                    await $_getPrefetchedDataByColumns<
                            MaintenanceScheduleRow,
                            $MaintenanceSchedulesTable,
                            NotificationJobRow,
                            $NotificationJobsTable>(
                        currentTable: table,
                        referencedTable: $$MaintenanceSchedulesTableReferences
                            ._notificationJobsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceSchedulesTableReferences(db, table, p0)
                                .notificationJobsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'maintenance_schedule_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MaintenanceSchedulesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MaintenanceSchedulesTable,
        MaintenanceScheduleRow,
        $$MaintenanceSchedulesTableFilterComposer,
        $$MaintenanceSchedulesTableOrderingComposer,
        $$MaintenanceSchedulesTableAnnotationComposer,
        $$MaintenanceSchedulesTableCreateCompanionBuilder,
        $$MaintenanceSchedulesTableUpdateCompanionBuilder,
        (MaintenanceScheduleRow, $$MaintenanceSchedulesTableReferences),
        MaintenanceScheduleRow,
        PrefetchHooks Function(
            {bool motorcycleId,
            bool serviceRecordItemsRefs,
            bool notificationJobsRefs})>;
typedef $$ServiceRecordItemsTableCreateCompanionBuilder
    = ServiceRecordItemsCompanion Function({
  required String id,
  required String serviceRecordId,
  Value<String?> maintenanceScheduleId,
  required String itemName,
  Value<String?> category,
  Value<int> itemCost,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$ServiceRecordItemsTableUpdateCompanionBuilder
    = ServiceRecordItemsCompanion Function({
  Value<String> id,
  Value<String> serviceRecordId,
  Value<String?> maintenanceScheduleId,
  Value<String> itemName,
  Value<String?> category,
  Value<int> itemCost,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$ServiceRecordItemsTableReferences extends BaseReferences<
    _$AppDatabase, $ServiceRecordItemsTable, ServiceRecordItemRow> {
  $$ServiceRecordItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ServiceRecordsTable _serviceRecordIdTable(_$AppDatabase db) =>
      db.serviceRecords.createAlias(
          'service_record_items__service_record_id__service_records__id');

  $$ServiceRecordsTableProcessedTableManager get serviceRecordId {
    final $_column = $_itemColumn<String>('service_record_id')!;

    final manager = $$ServiceRecordsTableTableManager($_db, $_db.serviceRecords)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceSchedulesTable _maintenanceScheduleIdTable(
          _$AppDatabase db) =>
      db.maintenanceSchedules.createAlias(
          'service_record_items__maintenance_schedule_id__maintenance_schedules__id');

  $$MaintenanceSchedulesTableProcessedTableManager? get maintenanceScheduleId {
    final $_column = $_itemColumn<String>('maintenance_schedule_id');
    if ($_column == null) return null;
    final manager =
        $$MaintenanceSchedulesTableTableManager($_db, $_db.maintenanceSchedules)
            .filter((f) => f.id.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_maintenanceScheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ServiceRecordItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceRecordItemsTable> {
  $$ServiceRecordItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemCost => $composableBuilder(
      column: $table.itemCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$ServiceRecordsTableFilterComposer get serviceRecordId {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceRecordId,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceSchedulesTableFilterComposer get maintenanceScheduleId {
    final $$MaintenanceSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.maintenanceScheduleId,
        referencedTable: $db.maintenanceSchedules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceRecordItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceRecordItemsTable> {
  $$ServiceRecordItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemCost => $composableBuilder(
      column: $table.itemCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$ServiceRecordsTableOrderingComposer get serviceRecordId {
    final $$ServiceRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceRecordId,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceSchedulesTableOrderingComposer get maintenanceScheduleId {
    final $$MaintenanceSchedulesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.maintenanceScheduleId,
            referencedTable: $db.maintenanceSchedules,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceSchedulesTableOrderingComposer(
                  $db: $db,
                  $table: $db.maintenanceSchedules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ServiceRecordItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceRecordItemsTable> {
  $$ServiceRecordItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get itemCost =>
      $composableBuilder(column: $table.itemCost, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ServiceRecordsTableAnnotationComposer get serviceRecordId {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceRecordId,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceSchedulesTableAnnotationComposer get maintenanceScheduleId {
    final $$MaintenanceSchedulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.maintenanceScheduleId,
            referencedTable: $db.maintenanceSchedules,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceSchedulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceSchedules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ServiceRecordItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiceRecordItemsTable,
    ServiceRecordItemRow,
    $$ServiceRecordItemsTableFilterComposer,
    $$ServiceRecordItemsTableOrderingComposer,
    $$ServiceRecordItemsTableAnnotationComposer,
    $$ServiceRecordItemsTableCreateCompanionBuilder,
    $$ServiceRecordItemsTableUpdateCompanionBuilder,
    (ServiceRecordItemRow, $$ServiceRecordItemsTableReferences),
    ServiceRecordItemRow,
    PrefetchHooks Function(
        {bool serviceRecordId, bool maintenanceScheduleId})> {
  $$ServiceRecordItemsTableTableManager(
      _$AppDatabase db, $ServiceRecordItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceRecordItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceRecordItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceRecordItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> serviceRecordId = const Value.absent(),
            Value<String?> maintenanceScheduleId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int> itemCost = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceRecordItemsCompanion(
            id: id,
            serviceRecordId: serviceRecordId,
            maintenanceScheduleId: maintenanceScheduleId,
            itemName: itemName,
            category: category,
            itemCost: itemCost,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String serviceRecordId,
            Value<String?> maintenanceScheduleId = const Value.absent(),
            required String itemName,
            Value<String?> category = const Value.absent(),
            Value<int> itemCost = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceRecordItemsCompanion.insert(
            id: id,
            serviceRecordId: serviceRecordId,
            maintenanceScheduleId: maintenanceScheduleId,
            itemName: itemName,
            category: category,
            itemCost: itemCost,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ServiceRecordItemsTable, ServiceRecordItemRow>(
                        table),
                    $$ServiceRecordItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {serviceRecordId = false, maintenanceScheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (serviceRecordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.serviceRecordId,
                    referencedTable: $$ServiceRecordItemsTableReferences
                        ._serviceRecordIdTable(db),
                    referencedColumn: $$ServiceRecordItemsTableReferences
                        ._serviceRecordIdTable(db)
                        .id,
                  ) as T;
                }
                if (maintenanceScheduleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.maintenanceScheduleId,
                    referencedTable: $$ServiceRecordItemsTableReferences
                        ._maintenanceScheduleIdTable(db),
                    referencedColumn: $$ServiceRecordItemsTableReferences
                        ._maintenanceScheduleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ServiceRecordItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiceRecordItemsTable,
    ServiceRecordItemRow,
    $$ServiceRecordItemsTableFilterComposer,
    $$ServiceRecordItemsTableOrderingComposer,
    $$ServiceRecordItemsTableAnnotationComposer,
    $$ServiceRecordItemsTableCreateCompanionBuilder,
    $$ServiceRecordItemsTableUpdateCompanionBuilder,
    (ServiceRecordItemRow, $$ServiceRecordItemsTableReferences),
    ServiceRecordItemRow,
    PrefetchHooks Function({bool serviceRecordId, bool maintenanceScheduleId})>;
typedef $$ServiceAttachmentsTableCreateCompanionBuilder
    = ServiceAttachmentsCompanion Function({
  required String id,
  required String serviceRecordId,
  required String localPath,
  required String fileName,
  required String mimeType,
  required int fileSize,
  required String createdAt,
  Value<int> rowid,
});
typedef $$ServiceAttachmentsTableUpdateCompanionBuilder
    = ServiceAttachmentsCompanion Function({
  Value<String> id,
  Value<String> serviceRecordId,
  Value<String> localPath,
  Value<String> fileName,
  Value<String> mimeType,
  Value<int> fileSize,
  Value<String> createdAt,
  Value<int> rowid,
});

final class $$ServiceAttachmentsTableReferences extends BaseReferences<
    _$AppDatabase, $ServiceAttachmentsTable, ServiceAttachmentRow> {
  $$ServiceAttachmentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ServiceRecordsTable _serviceRecordIdTable(_$AppDatabase db) =>
      db.serviceRecords.createAlias(
          'service_attachments__service_record_id__service_records__id');

  $$ServiceRecordsTableProcessedTableManager get serviceRecordId {
    final $_column = $_itemColumn<String>('service_record_id')!;

    final manager = $$ServiceRecordsTableTableManager($_db, $_db.serviceRecords)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ServiceAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceAttachmentsTable> {
  $$ServiceAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ServiceRecordsTableFilterComposer get serviceRecordId {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceRecordId,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceAttachmentsTable> {
  $$ServiceAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ServiceRecordsTableOrderingComposer get serviceRecordId {
    final $$ServiceRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceRecordId,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceAttachmentsTable> {
  $$ServiceAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ServiceRecordsTableAnnotationComposer get serviceRecordId {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceRecordId,
        referencedTable: $db.serviceRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceAttachmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiceAttachmentsTable,
    ServiceAttachmentRow,
    $$ServiceAttachmentsTableFilterComposer,
    $$ServiceAttachmentsTableOrderingComposer,
    $$ServiceAttachmentsTableAnnotationComposer,
    $$ServiceAttachmentsTableCreateCompanionBuilder,
    $$ServiceAttachmentsTableUpdateCompanionBuilder,
    (ServiceAttachmentRow, $$ServiceAttachmentsTableReferences),
    ServiceAttachmentRow,
    PrefetchHooks Function({bool serviceRecordId})> {
  $$ServiceAttachmentsTableTableManager(
      _$AppDatabase db, $ServiceAttachmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceAttachmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> serviceRecordId = const Value.absent(),
            Value<String> localPath = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> mimeType = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceAttachmentsCompanion(
            id: id,
            serviceRecordId: serviceRecordId,
            localPath: localPath,
            fileName: fileName,
            mimeType: mimeType,
            fileSize: fileSize,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String serviceRecordId,
            required String localPath,
            required String fileName,
            required String mimeType,
            required int fileSize,
            required String createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceAttachmentsCompanion.insert(
            id: id,
            serviceRecordId: serviceRecordId,
            localPath: localPath,
            fileName: fileName,
            mimeType: mimeType,
            fileSize: fileSize,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ServiceAttachmentsTable, ServiceAttachmentRow>(
                        table),
                    $$ServiceAttachmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({serviceRecordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (serviceRecordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.serviceRecordId,
                    referencedTable: $$ServiceAttachmentsTableReferences
                        ._serviceRecordIdTable(db),
                    referencedColumn: $$ServiceAttachmentsTableReferences
                        ._serviceRecordIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ServiceAttachmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiceAttachmentsTable,
    ServiceAttachmentRow,
    $$ServiceAttachmentsTableFilterComposer,
    $$ServiceAttachmentsTableOrderingComposer,
    $$ServiceAttachmentsTableAnnotationComposer,
    $$ServiceAttachmentsTableCreateCompanionBuilder,
    $$ServiceAttachmentsTableUpdateCompanionBuilder,
    (ServiceAttachmentRow, $$ServiceAttachmentsTableReferences),
    ServiceAttachmentRow,
    PrefetchHooks Function({bool serviceRecordId})>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<String> updatedAt,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingRow,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSettingRow,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>
    ),
    AppSettingRow,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AppSettingsTable, AppSettingRow>(table),
                    BaseReferences<_$AppDatabase, $AppSettingsTable,
                        AppSettingRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingRow,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSettingRow,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>
    ),
    AppSettingRow,
    PrefetchHooks Function()>;
typedef $$NotificationJobsTableCreateCompanionBuilder
    = NotificationJobsCompanion Function({
  required String id,
  required String maintenanceScheduleId,
  required String cycleKey,
  required String triggerType,
  required int platformNotificationId,
  Value<String?> plannedAt,
  required String state,
  required String createdAt,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$NotificationJobsTableUpdateCompanionBuilder
    = NotificationJobsCompanion Function({
  Value<String> id,
  Value<String> maintenanceScheduleId,
  Value<String> cycleKey,
  Value<String> triggerType,
  Value<int> platformNotificationId,
  Value<String?> plannedAt,
  Value<String> state,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<int> rowid,
});

final class $$NotificationJobsTableReferences extends BaseReferences<
    _$AppDatabase, $NotificationJobsTable, NotificationJobRow> {
  $$NotificationJobsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MaintenanceSchedulesTable _maintenanceScheduleIdTable(
          _$AppDatabase db) =>
      db.maintenanceSchedules.createAlias(
          'notification_jobs__maintenance_schedule_id__maintenance_schedules__id');

  $$MaintenanceSchedulesTableProcessedTableManager get maintenanceScheduleId {
    final $_column = $_itemColumn<String>('maintenance_schedule_id')!;

    final manager =
        $$MaintenanceSchedulesTableTableManager($_db, $_db.maintenanceSchedules)
            .filter((f) => f.id.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_maintenanceScheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NotificationJobsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationJobsTable> {
  $$NotificationJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cycleKey => $composableBuilder(
      column: $table.cycleKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get platformNotificationId => $composableBuilder(
      column: $table.platformNotificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plannedAt => $composableBuilder(
      column: $table.plannedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$MaintenanceSchedulesTableFilterComposer get maintenanceScheduleId {
    final $$MaintenanceSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.maintenanceScheduleId,
        referencedTable: $db.maintenanceSchedules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotificationJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationJobsTable> {
  $$NotificationJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cycleKey => $composableBuilder(
      column: $table.cycleKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get platformNotificationId => $composableBuilder(
      column: $table.platformNotificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plannedAt => $composableBuilder(
      column: $table.plannedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$MaintenanceSchedulesTableOrderingComposer get maintenanceScheduleId {
    final $$MaintenanceSchedulesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.maintenanceScheduleId,
            referencedTable: $db.maintenanceSchedules,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceSchedulesTableOrderingComposer(
                  $db: $db,
                  $table: $db.maintenanceSchedules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$NotificationJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationJobsTable> {
  $$NotificationJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cycleKey =>
      $composableBuilder(column: $table.cycleKey, builder: (column) => column);

  GeneratedColumn<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => column);

  GeneratedColumn<int> get platformNotificationId => $composableBuilder(
      column: $table.platformNotificationId, builder: (column) => column);

  GeneratedColumn<String> get plannedAt =>
      $composableBuilder(column: $table.plannedAt, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MaintenanceSchedulesTableAnnotationComposer get maintenanceScheduleId {
    final $$MaintenanceSchedulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.maintenanceScheduleId,
            referencedTable: $db.maintenanceSchedules,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceSchedulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceSchedules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$NotificationJobsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationJobsTable,
    NotificationJobRow,
    $$NotificationJobsTableFilterComposer,
    $$NotificationJobsTableOrderingComposer,
    $$NotificationJobsTableAnnotationComposer,
    $$NotificationJobsTableCreateCompanionBuilder,
    $$NotificationJobsTableUpdateCompanionBuilder,
    (NotificationJobRow, $$NotificationJobsTableReferences),
    NotificationJobRow,
    PrefetchHooks Function({bool maintenanceScheduleId})> {
  $$NotificationJobsTableTableManager(
      _$AppDatabase db, $NotificationJobsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> maintenanceScheduleId = const Value.absent(),
            Value<String> cycleKey = const Value.absent(),
            Value<String> triggerType = const Value.absent(),
            Value<int> platformNotificationId = const Value.absent(),
            Value<String?> plannedAt = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationJobsCompanion(
            id: id,
            maintenanceScheduleId: maintenanceScheduleId,
            cycleKey: cycleKey,
            triggerType: triggerType,
            platformNotificationId: platformNotificationId,
            plannedAt: plannedAt,
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String maintenanceScheduleId,
            required String cycleKey,
            required String triggerType,
            required int platformNotificationId,
            Value<String?> plannedAt = const Value.absent(),
            required String state,
            required String createdAt,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationJobsCompanion.insert(
            id: id,
            maintenanceScheduleId: maintenanceScheduleId,
            cycleKey: cycleKey,
            triggerType: triggerType,
            platformNotificationId: platformNotificationId,
            plannedAt: plannedAt,
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$NotificationJobsTable, NotificationJobRow>(
                        table),
                    $$NotificationJobsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({maintenanceScheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (maintenanceScheduleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.maintenanceScheduleId,
                    referencedTable: $$NotificationJobsTableReferences
                        ._maintenanceScheduleIdTable(db),
                    referencedColumn: $$NotificationJobsTableReferences
                        ._maintenanceScheduleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NotificationJobsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotificationJobsTable,
    NotificationJobRow,
    $$NotificationJobsTableFilterComposer,
    $$NotificationJobsTableOrderingComposer,
    $$NotificationJobsTableAnnotationComposer,
    $$NotificationJobsTableCreateCompanionBuilder,
    $$NotificationJobsTableUpdateCompanionBuilder,
    (NotificationJobRow, $$NotificationJobsTableReferences),
    NotificationJobRow,
    PrefetchHooks Function({bool maintenanceScheduleId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MotorcyclesTableTableManager get motorcycles =>
      $$MotorcyclesTableTableManager(_db, _db.motorcycles);
  $$ServiceRecordsTableTableManager get serviceRecords =>
      $$ServiceRecordsTableTableManager(_db, _db.serviceRecords);
  $$OdometerReadingsTableTableManager get odometerReadings =>
      $$OdometerReadingsTableTableManager(_db, _db.odometerReadings);
  $$MaintenanceSchedulesTableTableManager get maintenanceSchedules =>
      $$MaintenanceSchedulesTableTableManager(_db, _db.maintenanceSchedules);
  $$ServiceRecordItemsTableTableManager get serviceRecordItems =>
      $$ServiceRecordItemsTableTableManager(_db, _db.serviceRecordItems);
  $$ServiceAttachmentsTableTableManager get serviceAttachments =>
      $$ServiceAttachmentsTableTableManager(_db, _db.serviceAttachments);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$NotificationJobsTableTableManager get notificationJobs =>
      $$NotificationJobsTableTableManager(_db, _db.notificationJobs);
}
