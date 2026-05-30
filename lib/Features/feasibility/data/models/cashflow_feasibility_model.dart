import 'package:json_annotation/json_annotation.dart';
import 'package:takween/Features/feasibility/data/models/monthly_cashflow_model.dart';

part 'cashflow_feasibility_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CashflowFeasibilityModel {
  final String projectId;
  final double totalIncomeUsd;
  final double totalExpensesUsd;
  final double netCashFlowUsd;
  final double peakNegativeCashUsd;
  final String? paybackMonth;
  final List<MonthlyCashflowModel> monthlyBreakdown;

  CashflowFeasibilityModel({
    required this.projectId,
    required this.totalIncomeUsd,
    required this.totalExpensesUsd,
    required this.netCashFlowUsd,
    required this.peakNegativeCashUsd,
    this.paybackMonth,
    required this.monthlyBreakdown,
  });

  factory CashflowFeasibilityModel.fromJson(Map<String, dynamic> json) =>
      _$CashflowFeasibilityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashflowFeasibilityModelToJson(this);
}
