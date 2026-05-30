// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preliminary_feasibility_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreliminaryFeasibilityModel _$PreliminaryFeasibilityModelFromJson(
  Map<String, dynamic> json,
) => PreliminaryFeasibilityModel(
  landPostId: json['landPostId'] as String,
  title: json['title'] as String,
  city: json['city'] as String,
  landAreaSqm: (json['landAreaSqm'] as num).toDouble(),
  totalBuildableAreaSqm: (json['totalBuildableAreaSqm'] as num).toDouble(),
  totalSellableAreaSqm: (json['totalSellableAreaSqm'] as num).toDouble(),
  maxFloors: (json['maxFloors'] as num).toInt(),
  estimatedUnits: (json['estimatedUnits'] as num).toInt(),
  estimatedGrossRevenueUsd: (json['estimatedGrossRevenueUsd'] as num)
      .toDouble(),
);

Map<String, dynamic> _$PreliminaryFeasibilityModelToJson(
  PreliminaryFeasibilityModel instance,
) => <String, dynamic>{
  'landPostId': instance.landPostId,
  'title': instance.title,
  'city': instance.city,
  'landAreaSqm': instance.landAreaSqm,
  'totalBuildableAreaSqm': instance.totalBuildableAreaSqm,
  'totalSellableAreaSqm': instance.totalSellableAreaSqm,
  'maxFloors': instance.maxFloors,
  'estimatedUnits': instance.estimatedUnits,
  'estimatedGrossRevenueUsd': instance.estimatedGrossRevenueUsd,
};
