// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RentalAnalysisModel _$RentalAnalysisModelFromJson(Map<String, dynamic> json) =>
    RentalAnalysisModel(
      monthlyGrossIncomeUsd: (json['monthlyGrossIncomeUsd'] as num).toDouble(),
      annualGrossIncomeUsd: (json['annualGrossIncomeUsd'] as num).toDouble(),
      vacancyLossUsd: (json['vacancyLossUsd'] as num).toDouble(),
      annualMaintenanceCostUsd: (json['annualMaintenanceCostUsd'] as num)
          .toDouble(),
      annualNetIncomeUsd: (json['annualNetIncomeUsd'] as num).toDouble(),
      capRatePercent: (json['capRatePercent'] as num).toDouble(),
      grossYieldPercent: (json['grossYieldPercent'] as num).toDouble(),
      netYieldPercent: (json['netYieldPercent'] as num).toDouble(),
    );

Map<String, dynamic> _$RentalAnalysisModelToJson(
  RentalAnalysisModel instance,
) => <String, dynamic>{
  'monthlyGrossIncomeUsd': instance.monthlyGrossIncomeUsd,
  'annualGrossIncomeUsd': instance.annualGrossIncomeUsd,
  'vacancyLossUsd': instance.vacancyLossUsd,
  'annualMaintenanceCostUsd': instance.annualMaintenanceCostUsd,
  'annualNetIncomeUsd': instance.annualNetIncomeUsd,
  'capRatePercent': instance.capRatePercent,
  'grossYieldPercent': instance.grossYieldPercent,
  'netYieldPercent': instance.netYieldPercent,
};
