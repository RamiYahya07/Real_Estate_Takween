import 'package:json_annotation/json_annotation.dart';
import 'package:takween/Features/posts/data/models/buildable_area_model.dart';
import 'package:takween/Features/posts/data/models/zone_info_model.dart';

part 'land_post_item_details_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LandPostItemDetailsModel {
  final String id;
  final String title;
  final String? description;
  final double latitude;
  final double longitude;
  final String city;
  final String neighborhood;
  final double areaSqm;
  final double? plotWidth;
  final double? plotDepth;
  final String investmentType;
  final bool isSealedAuction;
  final int maxAcceptedBids;
  final double? priceUsd;
  final double? pricePerShareUsd;
  final bool acceptsAdditionalInvestors;
  final String desiredBuildingType;
  final BuildableAreaModel? buildableArea;
  final int? desiredFloors;
  final String? specialRequirements;
  final String ownershipBasis;
  final bool isRepresentative;
  final int acceptedBidCount;
  final int bidCount;
  final String status;
  final String? zoneConfidence;
  final ZoneInfoModel? zoneInfo;
  final DateTime createdAt;

  LandPostItemDetailsModel({
    required this.id,
    required this.title,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.neighborhood,
    required this.areaSqm,
    this.plotWidth,
    this.plotDepth,
    required this.investmentType,
    required this.isSealedAuction,
    required this.maxAcceptedBids,
    this.priceUsd,
    this.pricePerShareUsd,
    required this.acceptsAdditionalInvestors,
    required this.desiredBuildingType,
    this.buildableArea,
    this.desiredFloors,
    this.specialRequirements,
    required this.ownershipBasis,
    required this.isRepresentative,
    required this.acceptedBidCount,
    required this.bidCount,
    required this.status,
    this.zoneConfidence,
    this.zoneInfo,
    required this.createdAt,
  });

  factory LandPostItemDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$LandPostItemDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$LandPostItemDetailsModelToJson(this);
}
