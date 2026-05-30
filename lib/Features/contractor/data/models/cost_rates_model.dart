import 'package:json_annotation/json_annotation.dart';

part 'cost_rates_model.g.dart';

@JsonSerializable()
class CostRatesModel {
  final double cementPerTonUsd;
  final double steelPerTonUsd;
  final double concretePerCubicMeterUsd;
  final double bricksPerThousandUsd;
  final double sandPerCubicMeterUsd;
  final double gravelPerCubicMeterUsd;
  final double skilledLaborPerDayUsd;
  final double unskilledLaborPerDayUsd;
  final double electricalLaborPerDayUsd;
  final double plumbingLaborPerDayUsd;
  final double cranePerMonthUsd;
  final double excavatorPerMonthUsd;
  final double mixerPerMonthUsd;
  final double basicFinishPerSqmUsd;
  final double standardFinishPerSqmUsd;
  final double premiumFinishPerSqmUsd;

  CostRatesModel({
    this.cementPerTonUsd = 0,
    this.steelPerTonUsd = 0,
    this.concretePerCubicMeterUsd = 0,
    this.bricksPerThousandUsd = 0,
    this.sandPerCubicMeterUsd = 0,
    this.gravelPerCubicMeterUsd = 0,
    this.skilledLaborPerDayUsd = 0,
    this.unskilledLaborPerDayUsd = 0,
    this.electricalLaborPerDayUsd = 0,
    this.plumbingLaborPerDayUsd = 0,
    this.cranePerMonthUsd = 0,
    this.excavatorPerMonthUsd = 0,
    this.mixerPerMonthUsd = 0,
    this.basicFinishPerSqmUsd = 0,
    this.standardFinishPerSqmUsd = 0,
    this.premiumFinishPerSqmUsd = 0,
  });

  factory CostRatesModel.fromJson(Map<String, dynamic> json) =>
      _$CostRatesModelFromJson(json);

  Map<String, dynamic> toJson() => _$CostRatesModelToJson(this);
}
