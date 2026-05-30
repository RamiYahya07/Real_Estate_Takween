// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashflow_feasibility_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashflowFeasibilityModel _$CashflowFeasibilityModelFromJson(
  Map<String, dynamic> json,
) => CashflowFeasibilityModel(
  projectId: json['projectId'] as String,
  totalIncomeUsd: (json['totalIncomeUsd'] as num).toDouble(),
  totalExpensesUsd: (json['totalExpensesUsd'] as num).toDouble(),
  netCashFlowUsd: (json['netCashFlowUsd'] as num).toDouble(),
  peakNegativeCashUsd: (json['peakNegativeCashUsd'] as num).toDouble(),
  paybackMonth: json['paybackMonth'] as String?,
  monthlyBreakdown: (json['monthlyBreakdown'] as List<dynamic>)
      .map((e) => MonthlyCashflowModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CashflowFeasibilityModelToJson(
  CashflowFeasibilityModel instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'totalIncomeUsd': instance.totalIncomeUsd,
  'totalExpensesUsd': instance.totalExpensesUsd,
  'netCashFlowUsd': instance.netCashFlowUsd,
  'peakNegativeCashUsd': instance.peakNegativeCashUsd,
  'paybackMonth': instance.paybackMonth,
  'monthlyBreakdown': instance.monthlyBreakdown.map((e) => e.toJson()).toList(),
};
