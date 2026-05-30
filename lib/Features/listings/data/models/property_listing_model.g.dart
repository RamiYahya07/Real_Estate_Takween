// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyListingModel _$PropertyListingModelFromJson(
  Map<String, dynamic> json,
) => PropertyListingModel(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  createdByUserId: json['createdByUserId'] as String,
  createdByName: json['createdByName'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  type: json['type'] as String,
  status: json['status'] as String,
  priceUsd: (json['priceUsd'] as num).toDouble(),
  areaSqm: (json['areaSqm'] as num?)?.toDouble(),
  rooms: (json['rooms'] as num?)?.toInt(),
  floor: (json['floor'] as num?)?.toInt(),
  photoUrls:
      (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  city: json['city'] as String?,
  neighborhood: json['neighborhood'] as String?,
  offerCount: (json['offerCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PropertyListingModelToJson(
  PropertyListingModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'createdByUserId': instance.createdByUserId,
  'createdByName': instance.createdByName,
  'title': instance.title,
  'description': instance.description,
  'type': instance.type,
  'status': instance.status,
  'priceUsd': instance.priceUsd,
  'areaSqm': instance.areaSqm,
  'rooms': instance.rooms,
  'floor': instance.floor,
  'photoUrls': instance.photoUrls,
  'city': instance.city,
  'neighborhood': instance.neighborhood,
  'offerCount': instance.offerCount,
  'createdAt': instance.createdAt.toIso8601String(),
};
