import 'package:json_annotation/json_annotation.dart';

part 'milestone_model.g.dart';

@JsonSerializable()
class MilestoneModel {
  final String id;
  final String title;
  final String? description;
  final String? status;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime? completedAt;

  MilestoneModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.orderIndex,
    required this.createdAt,
    this.completedAt,
  });

  factory MilestoneModel.fromJson(Map<String, dynamic> json) =>
      _$MilestoneModelFromJson(json);

  Map<String, dynamic> toJson() => _$MilestoneModelToJson(this);
}
