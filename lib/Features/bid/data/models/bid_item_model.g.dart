// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidItemModel _$BidItemModelFromJson(Map<String, dynamic> json) => BidItemModel(
  id: json['id'] as String,
  landPostId: json['landPostId'] as String,
  contractorName: json['contractorName'] as String,
  status: json['status'] as String,
  estimatedConstructionCostUsd: (json['estimatedConstructionCostUsd'] as num)
      .toDouble(),
  estimatedTimelineMonths: (json['estimatedTimelineMonths'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  offerPriceUsd: (json['offerPriceUsd'] as num?)?.toDouble(),
  requestedShares: (json['requestedShares'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BidItemModelToJson(BidItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'landPostId': instance.landPostId,
      'contractorName': instance.contractorName,
      'status': instance.status,
      'offerPriceUsd': instance.offerPriceUsd,
      'estimatedConstructionCostUsd': instance.estimatedConstructionCostUsd,
      'estimatedTimelineMonths': instance.estimatedTimelineMonths,
      'requestedShares': instance.requestedShares,
      'createdAt': instance.createdAt.toIso8601String(),
    };
