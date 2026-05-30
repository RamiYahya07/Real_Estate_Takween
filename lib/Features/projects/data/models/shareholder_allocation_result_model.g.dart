// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shareholder_allocation_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareholderAllocationResultModel _$ShareholderAllocationResultModelFromJson(
  Map<String, dynamic> json,
) => ShareholderAllocationResultModel(
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  shares: (json['shares'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
  entitledUnits: (json['entitledUnits'] as num).toInt(),
  assignedUnits: (json['assignedUnits'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ShareholderAllocationResultModelToJson(
  ShareholderAllocationResultModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'shares': instance.shares,
  'percentage': instance.percentage,
  'entitledUnits': instance.entitledUnits,
  'assignedUnits': instance.assignedUnits,
};
