// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectStatisticsModel _$ProjectStatisticsModelFromJson(
  Map<String, dynamic> json,
) => ProjectStatisticsModel(
  totalProjects: (json['totalProjects'] as num).toInt(),
  activeProjects: (json['activeProjects'] as num).toInt(),
  completedProjects: (json['completedProjects'] as num).toInt(),
);

Map<String, dynamic> _$ProjectStatisticsModelToJson(
  ProjectStatisticsModel instance,
) => <String, dynamic>{
  'totalProjects': instance.totalProjects,
  'activeProjects': instance.activeProjects,
  'completedProjects': instance.completedProjects,
};
