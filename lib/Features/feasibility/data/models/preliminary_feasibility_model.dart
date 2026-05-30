import 'package:json_annotation/json_annotation.dart';

part 'preliminary_feasibility_model.g.dart';

@JsonSerializable()
class PreliminaryFeasibilityModel {
  final String landPostId;
  final String title;
  final String city;
  final double landAreaSqm;
  final double totalBuildableAreaSqm;
  final double totalSellableAreaSqm;
  final int maxFloors;
  final int estimatedUnits;
  final double estimatedGrossRevenueUsd;

  PreliminaryFeasibilityModel({
    required this.landPostId,
    required this.title,
    required this.city,
    required this.landAreaSqm,
    required this.totalBuildableAreaSqm,
    required this.totalSellableAreaSqm,
    required this.maxFloors,
    required this.estimatedUnits,
    required this.estimatedGrossRevenueUsd,
  });

  factory PreliminaryFeasibilityModel.fromJson(Map<String, dynamic> json) =>
      _$PreliminaryFeasibilityModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreliminaryFeasibilityModelToJson(this);
}
