import 'package:json_annotation/json_annotation.dart';

part 'share_listing_model.g.dart';

@JsonSerializable()
class ShareListingModel {
  final String id;
  final String projectId;
  final String sellerUserId;
  final String sellerName;
  final String? buyerUserId;
  final String? buyerName;
  final int shareCount;
  final double pricePerShareUsd;
  final double totalPriceUsd;
  final String status;
  final DateTime createdAt;
  final DateTime? soldAt;

  ShareListingModel({
    required this.id,
    required this.projectId,
    required this.sellerUserId,
    required this.sellerName,
    this.buyerUserId,
    this.buyerName,
    required this.shareCount,
    required this.pricePerShareUsd,
    required this.totalPriceUsd,
    required this.status,
    required this.createdAt,
    this.soldAt,
  });

  factory ShareListingModel.fromJson(Map<String, dynamic> json) =>
      _$ShareListingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShareListingModelToJson(this);
}
