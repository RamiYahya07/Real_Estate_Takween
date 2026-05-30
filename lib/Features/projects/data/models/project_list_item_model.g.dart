// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectListItemModel _$ProjectListItemModelFromJson(
  Map<String, dynamic> json,
) => ProjectListItemModel(
  id: json['id'] as String,
  title: json['title'] as String,
  city: json['city'] as String,
  investmentType: json['investmentType'] as String,
  status: json['status'] as String,
  contractorName: json['contractorName'] as String,
  landOwnerName: json['landOwnerName'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProjectListItemModelToJson(
  ProjectListItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'city': instance.city,
  'investmentType': instance.investmentType,
  'status': instance.status,
  'contractorName': instance.contractorName,
  'landOwnerName': instance.landOwnerName,
  'createdAt': instance.createdAt.toIso8601String(),
};
