// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_rates_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostRatesModel _$CostRatesModelFromJson(
  Map<String, dynamic> json,
) => CostRatesModel(
  cementPerTonUsd: (json['cementPerTonUsd'] as num?)?.toDouble() ?? 0,
  steelPerTonUsd: (json['steelPerTonUsd'] as num?)?.toDouble() ?? 0,
  concretePerCubicMeterUsd:
      (json['concretePerCubicMeterUsd'] as num?)?.toDouble() ?? 0,
  bricksPerThousandUsd: (json['bricksPerThousandUsd'] as num?)?.toDouble() ?? 0,
  sandPerCubicMeterUsd: (json['sandPerCubicMeterUsd'] as num?)?.toDouble() ?? 0,
  gravelPerCubicMeterUsd:
      (json['gravelPerCubicMeterUsd'] as num?)?.toDouble() ?? 0,
  skilledLaborPerDayUsd:
      (json['skilledLaborPerDayUsd'] as num?)?.toDouble() ?? 0,
  unskilledLaborPerDayUsd:
      (json['unskilledLaborPerDayUsd'] as num?)?.toDouble() ?? 0,
  electricalLaborPerDayUsd:
      (json['electricalLaborPerDayUsd'] as num?)?.toDouble() ?? 0,
  plumbingLaborPerDayUsd:
      (json['plumbingLaborPerDayUsd'] as num?)?.toDouble() ?? 0,
  cranePerMonthUsd: (json['cranePerMonthUsd'] as num?)?.toDouble() ?? 0,
  excavatorPerMonthUsd: (json['excavatorPerMonthUsd'] as num?)?.toDouble() ?? 0,
  mixerPerMonthUsd: (json['mixerPerMonthUsd'] as num?)?.toDouble() ?? 0,
  basicFinishPerSqmUsd: (json['basicFinishPerSqmUsd'] as num?)?.toDouble() ?? 0,
  standardFinishPerSqmUsd:
      (json['standardFinishPerSqmUsd'] as num?)?.toDouble() ?? 0,
  premiumFinishPerSqmUsd:
      (json['premiumFinishPerSqmUsd'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$CostRatesModelToJson(CostRatesModel instance) =>
    <String, dynamic>{
      'cementPerTonUsd': instance.cementPerTonUsd,
      'steelPerTonUsd': instance.steelPerTonUsd,
      'concretePerCubicMeterUsd': instance.concretePerCubicMeterUsd,
      'bricksPerThousandUsd': instance.bricksPerThousandUsd,
      'sandPerCubicMeterUsd': instance.sandPerCubicMeterUsd,
      'gravelPerCubicMeterUsd': instance.gravelPerCubicMeterUsd,
      'skilledLaborPerDayUsd': instance.skilledLaborPerDayUsd,
      'unskilledLaborPerDayUsd': instance.unskilledLaborPerDayUsd,
      'electricalLaborPerDayUsd': instance.electricalLaborPerDayUsd,
      'plumbingLaborPerDayUsd': instance.plumbingLaborPerDayUsd,
      'cranePerMonthUsd': instance.cranePerMonthUsd,
      'excavatorPerMonthUsd': instance.excavatorPerMonthUsd,
      'mixerPerMonthUsd': instance.mixerPerMonthUsd,
      'basicFinishPerSqmUsd': instance.basicFinishPerSqmUsd,
      'standardFinishPerSqmUsd': instance.standardFinishPerSqmUsd,
      'premiumFinishPerSqmUsd': instance.premiumFinishPerSqmUsd,
    };
