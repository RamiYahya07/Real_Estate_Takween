// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllocationResultModel _$AllocationResultModelFromJson(
  Map<String, dynamic> json,
) => AllocationResultModel(
  totalUnits: (json['totalUnits'] as num).toInt(),
  allocatedUnits: (json['allocatedUnits'] as num).toInt(),
  shareholders: (json['shareholders'] as List<dynamic>)
      .map(
        (e) => ShareholderAllocationResultModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$AllocationResultModelToJson(
  AllocationResultModel instance,
) => <String, dynamic>{
  'totalUnits': instance.totalUnits,
  'allocatedUnits': instance.allocatedUnits,
  'shareholders': instance.shareholders.map((e) => e.toJson()).toList(),
};
