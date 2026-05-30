// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidSummaryModel _$BidSummaryModelFromJson(Map<String, dynamic> json) =>
    BidSummaryModel(
      landPostId: json['landPostId'] as String,
      totalBids: (json['totalBids'] as num).toInt(),
      pendingBids: (json['pendingBids'] as num).toInt(),
      lowestOfferUsd: (json['lowestOfferUsd'] as num?)?.toDouble(),
      highestOfferUsd: (json['highestOfferUsd'] as num?)?.toDouble(),
      averageOfferUsd: (json['averageOfferUsd'] as num?)?.toDouble(),
      shortestTimelineMonths: (json['shortestTimelineMonths'] as num).toInt(),
      longestTimelineMonths: (json['longestTimelineMonths'] as num).toInt(),
      averageConstructionCostUsd: (json['averageConstructionCostUsd'] as num)
          .toDouble(),
      latestBidAt: DateTime.parse(json['latestBidAt'] as String),
    );

Map<String, dynamic> _$BidSummaryModelToJson(BidSummaryModel instance) =>
    <String, dynamic>{
      'landPostId': instance.landPostId,
      'totalBids': instance.totalBids,
      'pendingBids': instance.pendingBids,
      'lowestOfferUsd': instance.lowestOfferUsd,
      'highestOfferUsd': instance.highestOfferUsd,
      'averageOfferUsd': instance.averageOfferUsd,
      'shortestTimelineMonths': instance.shortestTimelineMonths,
      'longestTimelineMonths': instance.longestTimelineMonths,
      'averageConstructionCostUsd': instance.averageConstructionCostUsd,
      'latestBidAt': instance.latestBidAt.toIso8601String(),
    };
