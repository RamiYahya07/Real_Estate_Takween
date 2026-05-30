import 'package:json_annotation/json_annotation.dart';

part 'rental_analysis_model.g.dart';

@JsonSerializable()
class RentalAnalysisModel {
  final double monthlyGrossIncomeUsd;
  final double annualGrossIncomeUsd;
  final double vacancyLossUsd;
  final double annualMaintenanceCostUsd;
  final double annualNetIncomeUsd;
  final double capRatePercent;
  final double grossYieldPercent;
  final double netYieldPercent;

  RentalAnalysisModel({
    required this.monthlyGrossIncomeUsd,
    required this.annualGrossIncomeUsd,
    required this.vacancyLossUsd,
    required this.annualMaintenanceCostUsd,
    required this.annualNetIncomeUsd,
    required this.capRatePercent,
    required this.grossYieldPercent,
    required this.netYieldPercent,
  });

  factory RentalAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$RentalAnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$RentalAnalysisModelToJson(this);
}
