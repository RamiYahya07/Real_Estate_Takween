import 'package:json_annotation/json_annotation.dart';
part 'project_statistics_model.g.dart';

@JsonSerializable()
class ProjectStatisticsModel {
  final int totalProjects;
  final int activeProjects;
  final int completedProjects;

  ProjectStatisticsModel({
    required this.totalProjects,
    required this.activeProjects,
    required this.completedProjects,
  });

  factory ProjectStatisticsModel.fromJson(Map<String, dynamic> jsonData) =>
      _$ProjectStatisticsModelFromJson(jsonData);
  Map<String, dynamic> toJson() => _$ProjectStatisticsModelToJson(this);
}
