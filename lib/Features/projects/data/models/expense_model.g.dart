// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) => ExpenseModel(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  category: json['category'] as String,
  description: json['description'] as String,
  amountUsd: (json['amountUsd'] as num).toDouble(),
  paidAt: DateTime.parse(json['paidAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ExpenseModelToJson(ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'category': instance.category,
      'description': instance.description,
      'amountUsd': instance.amountUsd,
      'paidAt': instance.paidAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
