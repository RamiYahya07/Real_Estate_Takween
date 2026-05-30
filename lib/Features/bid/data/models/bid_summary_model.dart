import 'package:json_annotation/json_annotation.dart';

part 'bid_summary_model.g.dart';

@JsonSerializable()
class BidSummaryModel {
  final String landPostId;
  final int totalBids;
  final int pendingBids;

  final double? lowestOfferUsd;
  final double? highestOfferUsd;
  final double? averageOfferUsd;

  final int shortestTimelineMonths;
  final int longestTimelineMonths;

  final double averageConstructionCostUsd;

  final DateTime latestBidAt;

  BidSummaryModel({
    required this.landPostId,
    required this.totalBids,
    required this.pendingBids,
    required this.lowestOfferUsd,
    required this.highestOfferUsd,
    required this.averageOfferUsd,
    required this.shortestTimelineMonths,
    required this.longestTimelineMonths,
    required this.averageConstructionCostUsd,
    required this.latestBidAt,
  });
  factory BidSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$BidSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$BidSummaryModelToJson(this);
}
