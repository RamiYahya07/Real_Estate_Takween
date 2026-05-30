import 'package:json_annotation/json_annotation.dart';

part 'monthly_cashflow_model.g.dart';

@JsonSerializable()
class MonthlyCashflowModel {
  final String month;
  final double incomeUsd;
  final double expensesUsd;
  final double netCashFlow;
  final double cumulativeCashFlow;

  MonthlyCashflowModel({
    required this.month,
    required this.incomeUsd,
    required this.expensesUsd,
    required this.netCashFlow,
    required this.cumulativeCashFlow,
  });

  factory MonthlyCashflowModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyCashflowModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyCashflowModelToJson(this);
}
