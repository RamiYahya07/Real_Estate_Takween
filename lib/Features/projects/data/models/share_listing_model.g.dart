// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareListingModel _$ShareListingModelFromJson(Map<String, dynamic> json) =>
    ShareListingModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      sellerUserId: json['sellerUserId'] as String,
      sellerName: json['sellerName'] as String,
      buyerUserId: json['buyerUserId'] as String?,
      buyerName: json['buyerName'] as String?,
      shareCount: (json['shareCount'] as num).toInt(),
      pricePerShareUsd: (json['pricePerShareUsd'] as num).toDouble(),
      totalPriceUsd: (json['totalPriceUsd'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      soldAt: json['soldAt'] == null
          ? null
          : DateTime.parse(json['soldAt'] as String),
    );

Map<String, dynamic> _$ShareListingModelToJson(ShareListingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'sellerUserId': instance.sellerUserId,
      'sellerName': instance.sellerName,
      'buyerUserId': instance.buyerUserId,
      'buyerName': instance.buyerName,
      'shareCount': instance.shareCount,
      'pricePerShareUsd': instance.pricePerShareUsd,
      'totalPriceUsd': instance.totalPriceUsd,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'soldAt': instance.soldAt?.toIso8601String(),
    };
