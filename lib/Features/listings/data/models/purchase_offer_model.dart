import 'package:json_annotation/json_annotation.dart';

part 'purchase_offer_model.g.dart';

@JsonSerializable()
class PurchaseOfferModel {
  final String id;
  final String listingId;
  final String buyerUserId;
  final String buyerName;
  final double offerPriceUsd;
  final String? message;
  final String status;
  final DateTime createdAt;

  PurchaseOfferModel({
    required this.id,
    required this.listingId,
    required this.buyerUserId,
    required this.buyerName,
    required this.offerPriceUsd,
    this.message,
    required this.status,
    required this.createdAt,
  });

  factory PurchaseOfferModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseOfferModelToJson(this);
}
