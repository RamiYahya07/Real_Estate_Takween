// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZoneInfoModel _$ZoneInfoModelFromJson(Map<String, dynamic> json) =>
    ZoneInfoModel(
      buildingZoneId: json['buildingZoneId'] as String,
      zoneId: json['zoneId'] as String,
      zoneNameEn: json['zoneNameEn'] as String,
      zoneNameAr: json['zoneNameAr'] as String,
      zoneType: json['zoneType'] as String,
      city: json['city'] as String,
      cityAr: json['cityAr'] as String,
      matchedNeighborhoodEn: json['matchedNeighborhoodEn'] as String,
      matchedNeighborhoodAr: json['matchedNeighborhoodAr'] as String,
      distanceM: (json['distanceM'] as num).toDouble(),
      confidence: json['confidence'] as String,
      maxFloors: (json['maxFloors'] as num).toInt(),
      maxHeightM: (json['maxHeightM'] as num).toDouble(),
      far: (json['far'] as num).toDouble(),
      maxCoveragePct: (json['maxCoveragePct'] as num).toInt(),
      minPlotSizeSqm: (json['minPlotSizeSqm'] as num).toDouble(),
      minFrontageM: (json['minFrontageM'] as num).toDouble(),
      setbackFrontM: (json['setbackFrontM'] as num).toDouble(),
      setbackSideM: (json['setbackSideM'] as num).toDouble(),
      setbackRearM: (json['setbackRearM'] as num).toDouble(),
      minApartmentSizeSqm: (json['minApartmentSizeSqm'] as num?)?.toDouble(),
      parkingPerUnit: (json['parkingPerUnit'] as num?)?.toDouble(),
      basementAllowed: json['basementAllowed'] as bool,
    );

Map<String, dynamic> _$ZoneInfoModelToJson(ZoneInfoModel instance) =>
    <String, dynamic>{
      'buildingZoneId': instance.buildingZoneId,
      'zoneId': instance.zoneId,
      'zoneNameEn': instance.zoneNameEn,
      'zoneNameAr': instance.zoneNameAr,
      'zoneType': instance.zoneType,
      'city': instance.city,
      'cityAr': instance.cityAr,
      'matchedNeighborhoodEn': instance.matchedNeighborhoodEn,
      'matchedNeighborhoodAr': instance.matchedNeighborhoodAr,
      'distanceM': instance.distanceM,
      'confidence': instance.confidence,
      'maxFloors': instance.maxFloors,
      'maxHeightM': instance.maxHeightM,
      'far': instance.far,
      'maxCoveragePct': instance.maxCoveragePct,
      'minPlotSizeSqm': instance.minPlotSizeSqm,
      'minFrontageM': instance.minFrontageM,
      'setbackFrontM': instance.setbackFrontM,
      'setbackSideM': instance.setbackSideM,
      'setbackRearM': instance.setbackRearM,
      'minApartmentSizeSqm': instance.minApartmentSizeSqm,
      'parkingPerUnit': instance.parkingPerUnit,
      'basementAllowed': instance.basementAllowed,
    };
