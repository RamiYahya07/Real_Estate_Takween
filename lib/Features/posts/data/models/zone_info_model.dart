import 'package:json_annotation/json_annotation.dart';
part 'zone_info_model.g.dart';

@JsonSerializable()
class ZoneInfoModel {
  final String buildingZoneId;
  final String zoneId;
  final String zoneNameEn;
  final String zoneNameAr;
  final String zoneType;
  final String city;
  final String cityAr;
  final String matchedNeighborhoodEn;
  final String matchedNeighborhoodAr;
  final double distanceM;
  final String confidence;
  final int maxFloors;
  final double maxHeightM;
  final double far;
  final int maxCoveragePct;
  final double minPlotSizeSqm;
  final double minFrontageM;
  final double setbackFrontM;
  final double setbackSideM;
  final double setbackRearM;
  final double? minApartmentSizeSqm;
  final double? parkingPerUnit;
  final bool basementAllowed;

  ZoneInfoModel({
    required this.buildingZoneId,
    required this.zoneId,
    required this.zoneNameEn,
    required this.zoneNameAr,
    required this.zoneType,
    required this.city,
    required this.cityAr,
    required this.matchedNeighborhoodEn,
    required this.matchedNeighborhoodAr,
    required this.distanceM,
    required this.confidence,
    required this.maxFloors,
    required this.maxHeightM,
    required this.far,
    required this.maxCoveragePct,
    required this.minPlotSizeSqm,
    required this.minFrontageM,
    required this.setbackFrontM,
    required this.setbackSideM,
    required this.setbackRearM,
    this.minApartmentSizeSqm,
    this.parkingPerUnit,
    required this.basementAllowed,
  });

  factory ZoneInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ZoneInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZoneInfoModelToJson(this);
}
