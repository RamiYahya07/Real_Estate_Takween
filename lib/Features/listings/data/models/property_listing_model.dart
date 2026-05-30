import 'package:json_annotation/json_annotation.dart';

part 'property_listing_model.g.dart';

@JsonSerializable()
class PropertyListingModel {
  final String id;
  final String projectId;
  final String createdByUserId;
  final String createdByName;
  final String title;
  final String? description;
  final String type;
  final String status;
  final double priceUsd;
  final double? areaSqm;
  final int? rooms;
  final int? floor;
  final List<String> photoUrls;
  final String? city;
  final String? neighborhood;
  final int offerCount;
  final DateTime createdAt;

  PropertyListingModel({
    required this.id,
    required this.projectId,
    required this.createdByUserId,
    required this.createdByName,
    required this.title,
    this.description,
    required this.type,
    required this.status,
    required this.priceUsd,
    this.areaSqm,
    this.rooms,
    this.floor,
    this.photoUrls = const [],
    this.city,
    this.neighborhood,
    required this.offerCount,
    required this.createdAt,
  });

  factory PropertyListingModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyListingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyListingModelToJson(this);
}
