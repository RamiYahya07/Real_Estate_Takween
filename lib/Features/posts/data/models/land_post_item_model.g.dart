// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'land_post_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandPostItemModel _$LandPostItemModelFromJson(Map<String, dynamic> json) =>
    LandPostItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      city: json['city'] as String,
      neighborhood: json['neighborhood'] as String,
      areaSqm: (json['areaSqm'] as num).toDouble(),
      investmentType: json['investmentType'] as String,
      status: json['status'] as String,
      priceUsd: (json['priceUsd'] as num?)?.toDouble(),
      pricePerShareUsd: (json['pricePerShareUsd'] as num?)?.toDouble(),
      bidCount: (json['bidCount'] as num).toInt(),
      desiredBuildingType: json['desiredBuildingType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LandPostItemModelToJson(LandPostItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'city': instance.city,
      'neighborhood': instance.neighborhood,
      'areaSqm': instance.areaSqm,
      'investmentType': instance.investmentType,
      'status': instance.status,
      'priceUsd': instance.priceUsd,
      'pricePerShareUsd': instance.pricePerShareUsd,
      'bidCount': instance.bidCount,
      'desiredBuildingType': instance.desiredBuildingType,
      'createdAt': instance.createdAt.toIso8601String(),
    };
