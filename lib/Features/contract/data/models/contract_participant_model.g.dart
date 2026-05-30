// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractParticipantModel _$ContractParticipantModelFromJson(
  Map<String, dynamic> json,
) => ContractParticipantModel(
  userId: json['userId'] as String,
  name: json['name'] as String,
  fullName: json['fullName'] as String?,
  role: json['role'] as String,
  shares: (json['shares'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
  hasSigned: json['hasSigned'] as bool,
  signedAt: json['signedAt'] == null
      ? null
      : DateTime.parse(json['signedAt'] as String),
);

Map<String, dynamic> _$ContractParticipantModelToJson(
  ContractParticipantModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'name': instance.name,
  'fullName': instance.fullName,
  'role': instance.role,
  'shares': instance.shares,
  'percentage': instance.percentage,
  'hasSigned': instance.hasSigned,
  'signedAt': instance.signedAt?.toIso8601String(),
};
