// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingListItemModel _$ListingListItemModelFromJson(
  Map<String, dynamic> json,
) => ListingListItemModel(
  id: json['id'] as String,
  title: json['title'] as String,
  type: json['type'] as String,
  status: json['status'] as String,
  priceUsd: (json['priceUsd'] as num).toDouble(),
  areaSqm: (json['areaSqm'] as num?)?.toDouble(),
  rooms: (json['rooms'] as num?)?.toInt(),
  city: json['city'] as String?,
  offerCount: (json['offerCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ListingListItemModelToJson(
  ListingListItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': instance.type,
  'status': instance.status,
  'priceUsd': instance.priceUsd,
  'areaSqm': instance.areaSqm,
  'rooms': instance.rooms,
  'city': instance.city,
  'offerCount': instance.offerCount,
  'createdAt': instance.createdAt.toIso8601String(),
};
