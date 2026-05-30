// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_allocation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareAllocationModel _$ShareAllocationModelFromJson(
  Map<String, dynamic> json,
) => ShareAllocationModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  shareCount: (json['shareCount'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
  role: json['role'] as String,
  contributionType: json['contributionType'] as String,
  allocatedAt: DateTime.parse(json['allocatedAt'] as String),
);

Map<String, dynamic> _$ShareAllocationModelToJson(
  ShareAllocationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userName': instance.userName,
  'shareCount': instance.shareCount,
  'percentage': instance.percentage,
  'role': instance.role,
  'contributionType': instance.contributionType,
  'allocatedAt': instance.allocatedAt.toIso8601String(),
};
