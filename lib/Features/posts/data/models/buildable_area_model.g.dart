// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buildable_area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildableAreaModel _$BuildableAreaModelFromJson(Map<String, dynamic> json) =>
    BuildableAreaModel(
      buildableFootprintSqm: (json['buildableFootprintSqm'] as num).toDouble(),
      totalBuildableAreaSqm: (json['totalBuildableAreaSqm'] as num).toDouble(),
      maxAllowedFloors: (json['maxAllowedFloors'] as num).toInt(),
      estimatedUnits: (json['estimatedUnits'] as num).toInt(),
      floorHeightM: (json['floorHeightM'] as num).toDouble(),
      estimatedBuildingHeightM: (json['estimatedBuildingHeightM'] as num)
          .toDouble(),
      basementAllowed: json['basementAllowed'] as bool,
      requiredParkingSpots: (json['requiredParkingSpots'] as num).toInt(),
    );

Map<String, dynamic> _$BuildableAreaModelToJson(BuildableAreaModel instance) =>
    <String, dynamic>{
      'buildableFootprintSqm': instance.buildableFootprintSqm,
      'totalBuildableAreaSqm': instance.totalBuildableAreaSqm,
      'maxAllowedFloors': instance.maxAllowedFloors,
      'estimatedUnits': instance.estimatedUnits,
      'floorHeightM': instance.floorHeightM,
      'estimatedBuildingHeightM': instance.estimatedBuildingHeightM,
      'basementAllowed': instance.basementAllowed,
      'requiredParkingSpots': instance.requiredParkingSpots,
    };
