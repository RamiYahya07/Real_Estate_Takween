import 'package:json_annotation/json_annotation.dart';

part 'project_share_model.g.dart';

@JsonSerializable()
class ProjectShareModel {
  final String projectId;
  final String projectTitle;
  final int shares;
  final double percentage;

  ProjectShareModel({
    required this.projectId,
    required this.projectTitle,
    required this.shares,
    required this.percentage,
  });

  factory ProjectShareModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectShareModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectShareModelToJson(this);
}
