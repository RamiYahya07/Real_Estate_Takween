import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  final String id;
  final String projectId;
  final String category;
  final String description;
  final double amountUsd;
  final DateTime paidAt;
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.projectId,
    required this.category,
    required this.description,
    required this.amountUsd,
    required this.paidAt,
    required this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);
}
