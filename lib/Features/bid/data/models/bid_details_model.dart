import 'package:json_annotation/json_annotation.dart';
part 'bid_details_model.g.dart';

@JsonSerializable()
class BidDetailsModel {
  final String id;
  final String landPostId;
  final String contractorUserId;
  final String contractorName;
  final String investmentType;
  final String status;
  final double? offerPriceUsd;
  final double? landownerSharePercent;
  final double? contractorSharePercent;
  final double? availableForPartnersPercent;
  final double? requestedShares;
  final double estimatedConstructionCostUsd;
  final int estimatedTimelineMonths;
  final String finishTier;
  final int proposedFloors;
  final String proposedApproach;
  final String notes;
  final DateTime createdAt;

  BidDetailsModel({
    required this.id,
    required this.landPostId,
    required this.contractorUserId,
    required this.contractorName,
    required this.investmentType,
    required this.status,
    this.offerPriceUsd,
    this.landownerSharePercent,
    this.contractorSharePercent,
    this.availableForPartnersPercent,
    this.requestedShares,
    required this.estimatedConstructionCostUsd,
    required this.estimatedTimelineMonths,
    required this.finishTier,
    required this.proposedFloors,
    required this.proposedApproach,
    required this.notes,
    required this.createdAt,
  });
  factory BidDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$BidDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$BidDetailsModelToJson(this);
}
