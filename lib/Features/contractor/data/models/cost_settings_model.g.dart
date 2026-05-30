// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostSettingsModel _$CostSettingsModelFromJson(Map<String, dynamic> json) =>
    CostSettingsModel(
      rates: CostRatesModel.fromJson(json['rates'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CostSettingsModelToJson(CostSettingsModel instance) =>
    <String, dynamic>{
      'rates': instance.rates.toJson(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
