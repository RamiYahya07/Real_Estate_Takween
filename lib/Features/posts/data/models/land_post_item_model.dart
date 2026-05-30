import 'package:json_annotation/json_annotation.dart';

part 'land_post_item_model.g.dart';

@JsonSerializable()
class LandPostItemModel {
  final String id;
  final String title;//
  final String city;
  final String neighborhood;
  final double areaSqm;
  final String investmentType;
  final String status;
  final double? priceUsd;//
  final double? pricePerShareUsd;//
  final int bidCount;
  final String desiredBuildingType;
  final DateTime createdAt;

  LandPostItemModel({
    required this.id,
    required this.title,
    required this.city,
    required this.neighborhood,
    required this.areaSqm,
    required this.investmentType,
    required this.status,
    required this.priceUsd,
    required this.pricePerShareUsd,
    required this.bidCount,
    required this.desiredBuildingType,
    required this.createdAt,
  });

  factory LandPostItemModel.fromJson(Map<String, dynamic> json) =>
      _$LandPostItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$LandPostItemModelToJson(this);
}