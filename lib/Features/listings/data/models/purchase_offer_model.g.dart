// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseOfferModel _$PurchaseOfferModelFromJson(Map<String, dynamic> json) =>
    PurchaseOfferModel(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      buyerUserId: json['buyerUserId'] as String,
      buyerName: json['buyerName'] as String,
      offerPriceUsd: (json['offerPriceUsd'] as num).toDouble(),
      message: json['message'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PurchaseOfferModelToJson(PurchaseOfferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listingId': instance.listingId,
      'buyerUserId': instance.buyerUserId,
      'buyerName': instance.buyerName,
      'offerPriceUsd': instance.offerPriceUsd,
      'message': instance.message,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
