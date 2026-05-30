import 'package:json_annotation/json_annotation.dart';
import 'package:takween/Features/feasibility/data/models/rental_analysis_model.dart';

part 'detailed_feasibility_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DetailedFeasibilityModel {
  final String projectId;
  final String projectTitle;
  final String city;
  final double landAreaSqm;
  final double buildableFootprintSqm;
  final double totalBuildableAreaSqm;
  final double totalSellableAreaSqm;
  final int maxFloors;
  final int estimatedUnits;
  final double constructionCostUsd;
  final int timelineMonths;
  final double grossRevenueUsd;
  final double sellingExpensesUsd;
  final double netRevenueUsd;
  final double netProfitUsd;
  final double profitMarginPercent;
  final double roiPercent;
  final double npv;
  final double annualizedIRRPercent;
  final RentalAnalysisModel? rentalAnalysis;

  DetailedFeasibilityModel({
    required this.projectId,
    required this.projectTitle,
    required this.city,
    required this.landAreaSqm,
    required this.buildableFootprintSqm,
    required this.totalBuildableAreaSqm,
    required this.totalSellableAreaSqm,
    required this.maxFloors,
    required this.estimatedUnits,
    required this.constructionCostUsd,
    required this.timelineMonths,
    required this.grossRevenueUsd,
    required this.sellingExpensesUsd,
    required this.netRevenueUsd,
    required this.netProfitUsd,
    required this.profitMarginPercent,
    required this.roiPercent,
    required this.npv,
    required this.annualizedIRRPercent,
    this.rentalAnalysis,
  });

  factory DetailedFeasibilityModel.fromJson(Map<String, dynamic> json) =>
      _$DetailedFeasibilityModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailedFeasibilityModelToJson(this);
}
