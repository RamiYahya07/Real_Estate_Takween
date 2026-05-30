// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) => ProjectModel(
  id: json['id'] as String,
  landPostId: json['landPostId'] as String,
  acceptedBidId: json['acceptedBidId'] as String,
  investmentType: json['investmentType'] as String,
  status: json['status'] as String,
  buildingType: json['buildingType'] as String,
  contractorName: json['contractorName'] as String,
  landOwnerName: json['landOwnerName'] as String,
  totalShares: (json['totalShares'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  shares: (json['shares'] as List<dynamic>)
      .map((e) => ShareAllocationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'landPostId': instance.landPostId,
      'acceptedBidId': instance.acceptedBidId,
      'investmentType': instance.investmentType,
      'status': instance.status,
      'buildingType': instance.buildingType,
      'contractorName': instance.contractorName,
      'landOwnerName': instance.landOwnerName,
      'totalShares': instance.totalShares,
      'createdAt': instance.createdAt.toIso8601String(),
      'shares': instance.shares.map((e) => e.toJson()).toList(),
    };
