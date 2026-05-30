import 'package:json_annotation/json_annotation.dart';
import 'package:takween/Features/contractor/data/models/cost_rates_model.dart';

part 'cost_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CostSettingsModel {
  final CostRatesModel rates;
  final DateTime updatedAt;

  CostSettingsModel({required this.rates, required this.updatedAt});

  factory CostSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$CostSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CostSettingsModelToJson(this);
}
