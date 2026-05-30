// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_share_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectShareModel _$ProjectShareModelFromJson(Map<String, dynamic> json) =>
    ProjectShareModel(
      projectId: json['projectId'] as String,
      projectTitle: json['projectTitle'] as String,
      shares: (json['shares'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$ProjectShareModelToJson(ProjectShareModel instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'projectTitle': instance.projectTitle,
      'shares': instance.shares,
      'percentage': instance.percentage,
    };
