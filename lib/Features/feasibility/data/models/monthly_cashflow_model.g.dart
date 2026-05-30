// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_cashflow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyCashflowModel _$MonthlyCashflowModelFromJson(
  Map<String, dynamic> json,
) => MonthlyCashflowModel(
  month: json['month'] as String,
  incomeUsd: (json['incomeUsd'] as num).toDouble(),
  expensesUsd: (json['expensesUsd'] as num).toDouble(),
  netCashFlow: (json['netCashFlow'] as num).toDouble(),
  cumulativeCashFlow: (json['cumulativeCashFlow'] as num).toDouble(),
);

Map<String, dynamic> _$MonthlyCashflowModelToJson(
  MonthlyCashflowModel instance,
) => <String, dynamic>{
  'month': instance.month,
  'incomeUsd': instance.incomeUsd,
  'expensesUsd': instance.expensesUsd,
  'netCashFlow': instance.netCashFlow,
  'cumulativeCashFlow': instance.cumulativeCashFlow,
};
