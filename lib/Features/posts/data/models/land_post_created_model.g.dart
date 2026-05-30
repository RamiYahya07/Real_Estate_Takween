// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'land_post_created_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandPostCreatedModel _$LandPostCreatedModelFromJson(
  Map<String, dynamic> json,
) => LandPostCreatedModel(
  message: json['message'] as String?,
  status: json['status'] as String?,
  checkoutUrl: json['checkoutUrl'] as String?,
  id: json['id'] as String,
);

Map<String, dynamic> _$LandPostCreatedModelToJson(
  LandPostCreatedModel instance,
) => <String, dynamic>{
  'message': instance.message,
  'id': instance.id,
  'status': instance.status,
  'checkoutUrl': instance.checkoutUrl,
};
