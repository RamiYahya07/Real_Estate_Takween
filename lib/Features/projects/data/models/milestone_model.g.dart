// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MilestoneModel _$MilestoneModelFromJson(Map<String, dynamic> json) =>
    MilestoneModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String?,
      orderIndex: (json['orderIndex'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$MilestoneModelToJson(MilestoneModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'orderIndex': instance.orderIndex,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
