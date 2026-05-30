import 'package:json_annotation/json_annotation.dart';
part 'buildable_area_model.g.dart';

@JsonSerializable()
class BuildableAreaModel {
  final double buildableFootprintSqm;
  final double totalBuildableAreaSqm;
  final int maxAllowedFloors;
  final int estimatedUnits;
  final double floorHeightM;
  final double estimatedBuildingHeightM;
  final bool basementAllowed;
  final int requiredParkingSpots;

  BuildableAreaModel({
    required this.buildableFootprintSqm,
    required this.totalBuildableAreaSqm,
    required this.maxAllowedFloors,
    required this.estimatedUnits,
    required this.floorHeightM,
    required this.estimatedBuildingHeightM,
    required this.basementAllowed,
    required this.requiredParkingSpots,
  });

  factory BuildableAreaModel.fromJson(Map<String, dynamic> json) =>
      _$BuildableAreaModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuildableAreaModelToJson(this);
}
