// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingStatisticsModel _$ListingStatisticsModelFromJson(
  Map<String, dynamic> json,
) => ListingStatisticsModel(
  totalListings: (json['totalListings'] as num).toInt(),
  activeListings: (json['activeListings'] as num).toInt(),
  soldListings: (json['soldListings'] as num).toInt(),
  pendingOffers: (json['pendingOffers'] as num).toInt(),
);

Map<String, dynamic> _$ListingStatisticsModelToJson(
  ListingStatisticsModel instance,
) => <String, dynamic>{
  'totalListings': instance.totalListings,
  'activeListings': instance.activeListings,
  'soldListings': instance.soldListings,
  'pendingOffers': instance.pendingOffers,
};
