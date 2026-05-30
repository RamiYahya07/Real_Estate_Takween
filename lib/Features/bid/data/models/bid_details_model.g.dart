// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidDetailsModel _$BidDetailsModelFromJson(
  Map<String, dynamic> json,
) => BidDetailsModel(
  id: json['id'] as String,
  landPostId: json['landPostId'] as String,
  contractorUserId: json['contractorUserId'] as String,
  contractorName: json['contractorName'] as String,
  investmentType: json['investmentType'] as String,
  status: json['status'] as String,
  offerPriceUsd: (json['offerPriceUsd'] as num?)?.toDouble(),
  landownerSharePercent: (json['landownerSharePercent'] as num?)?.toDouble(),
  contractorSharePercent: (json['contractorSharePercent'] as num?)?.toDouble(),
  availableForPartnersPercent: (json['availableForPartnersPercent'] as num?)
      ?.toDouble(),
  requestedShares: (json['requestedShares'] as num?)?.toDouble(),
  estimatedConstructionCostUsd: (json['estimatedConstructionCostUsd'] as num)
      .toDouble(),
  estimatedTimelineMonths: (json['estimatedTimelineMonths'] as num).toInt(),
  finishTier: json['finishTier'] as String,
  proposedFloors: (json['proposedFloors'] as num).toInt(),
  proposedApproach: json['proposedApproach'] as String,
  notes: json['notes'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BidDetailsModelToJson(BidDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'landPostId': instance.landPostId,
      'contractorUserId': instance.contractorUserId,
      'contractorName': instance.contractorName,
      'investmentType': instance.investmentType,
      'status': instance.status,
      'offerPriceUsd': instance.offerPriceUsd,
      'landownerSharePercent': instance.landownerSharePercent,
      'contractorSharePercent': instance.contractorSharePercent,
      'availableForPartnersPercent': instance.availableForPartnersPercent,
      'requestedShares': instance.requestedShares,
      'estimatedConstructionCostUsd': instance.estimatedConstructionCostUsd,
      'estimatedTimelineMonths': instance.estimatedTimelineMonths,
      'finishTier': instance.finishTier,
      'proposedFloors': instance.proposedFloors,
      'proposedApproach': instance.proposedApproach,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };
