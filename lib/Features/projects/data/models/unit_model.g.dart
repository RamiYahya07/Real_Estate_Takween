// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitModel _$UnitModelFromJson(Map<String, dynamic> json) => UnitModel(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  unitNumber: json['unitNumber'] as String,
  floor: (json['floor'] as num).toInt(),
  areaSqm: (json['areaSqm'] as num).toDouble(),
  unitType: json['unitType'] as String?,
  status: json['status'] as String,
  allocatedToUserId: json['allocatedToUserId'] as String?,
  allocatedToName: json['allocatedToName'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UnitModelToJson(UnitModel instance) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'unitNumber': instance.unitNumber,
  'floor': instance.floor,
  'areaSqm': instance.areaSqm,
  'unitType': instance.unitType,
  'status': instance.status,
  'allocatedToUserId': instance.allocatedToUserId,
  'allocatedToName': instance.allocatedToName,
  'createdAt': instance.createdAt.toIso8601String(),
};
