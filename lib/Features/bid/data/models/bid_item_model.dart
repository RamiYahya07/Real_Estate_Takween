import 'package:json_annotation/json_annotation.dart';
part 'bid_item_model.g.dart';

@JsonSerializable()
class BidItemModel {
  final String id;
  final String landPostId;
  final String contractorName;
  final String status;

  final double? offerPriceUsd;
  final double estimatedConstructionCostUsd;
  final int estimatedTimelineMonths;
  final double? requestedShares;

  final DateTime createdAt;

  BidItemModel({
    required this.id,
    required this.landPostId,
    required this.contractorName,
    required this.status,
    required this.estimatedConstructionCostUsd,
    required this.estimatedTimelineMonths,
    required this.createdAt,
    this.offerPriceUsd,
    this.requestedShares,
  });
  factory BidItemModel.fromJson(Map<String, dynamic> json) =>
      _$BidItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$BidItemModelToJson(this);
}
