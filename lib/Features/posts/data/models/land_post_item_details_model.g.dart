// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'land_post_item_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandPostItemDetailsModel _$LandPostItemDetailsModelFromJson(
  Map<String, dynamic> json,
) => LandPostItemDetailsModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  city: json['city'] as String,
  neighborhood: json['neighborhood'] as String,
  areaSqm: (json['areaSqm'] as num).toDouble(),
  plotWidth: (json['plotWidth'] as num?)?.toDouble(),
  plotDepth: (json['plotDepth'] as num?)?.toDouble(),
  investmentType: json['investmentType'] as String,
  isSealedAuction: json['isSealedAuction'] as bool,
  maxAcceptedBids: (json['maxAcceptedBids'] as num).toInt(),
  priceUsd: (json['priceUsd'] as num?)?.toDouble(),
  pricePerShareUsd: (json['pricePerShareUsd'] as num?)?.toDouble(),
  acceptsAdditionalInvestors: json['acceptsAdditionalInvestors'] as bool,
  desiredBuildingType: json['desiredBuildingType'] as String,
  buildableArea: json['buildableArea'] == null
      ? null
      : BuildableAreaModel.fromJson(
          json['buildableArea'] as Map<String, dynamic>,
        ),
  desiredFloors: (json['desiredFloors'] as num?)?.toInt(),
  specialRequirements: json['specialRequirements'] as String?,
  ownershipBasis: json['ownershipBasis'] as String,
  isRepresentative: json['isRepresentative'] as bool,
  acceptedBidCount: (json['acceptedBidCount'] as num).toInt(),
  bidCount: (json['bidCount'] as num).toInt(),
  status: json['status'] as String,
  zoneConfidence: json['zoneConfidence'] as String?,
  zoneInfo: json['zoneInfo'] == null
      ? null
      : ZoneInfoModel.fromJson(json['zoneInfo'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LandPostItemDetailsModelToJson(
  LandPostItemDetailsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'city': instance.city,
  'neighborhood': instance.neighborhood,
  'areaSqm': instance.areaSqm,
  'plotWidth': instance.plotWidth,
  'plotDepth': instance.plotDepth,
  'investmentType': instance.investmentType,
  'isSealedAuction': instance.isSealedAuction,
  'maxAcceptedBids': instance.maxAcceptedBids,
  'priceUsd': instance.priceUsd,
  'pricePerShareUsd': instance.pricePerShareUsd,
  'acceptsAdditionalInvestors': instance.acceptsAdditionalInvestors,
  'desiredBuildingType': instance.desiredBuildingType,
  'buildableArea': instance.buildableArea?.toJson(),
  'desiredFloors': instance.desiredFloors,
  'specialRequirements': instance.specialRequirements,
  'ownershipBasis': instance.ownershipBasis,
  'isRepresentative': instance.isRepresentative,
  'acceptedBidCount': instance.acceptedBidCount,
  'bidCount': instance.bidCount,
  'status': instance.status,
  'zoneConfidence': instance.zoneConfidence,
  'zoneInfo': instance.zoneInfo?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
};
