import 'package:json_annotation/json_annotation.dart';
import 'package:takween/Features/statistics/data/models/project_share_model.dart';

part 'buyer_stats_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BuyerStatsModel {
  final int totalOffers;
  final int pendingOffers;
  final int acceptedOffers;
  final int rejectedOffers;
  final int unitsOwned;
  final int savedListings;

  final int totalInvestmentRequests;
  final int pendingInvestmentRequests;
  final int approvedInvestmentRequests;
  final int rejectedInvestmentRequests;
  final int paidInvestmentRequests;

  final int totalSharesOwned;
  final int projectsWithShares;
  final double averageSharePercentage;
  final List<ProjectShareModel> sharesBreakdown;

  final int projectsParticipating;

  BuyerStatsModel({
    required this.totalOffers,
    required this.pendingOffers,
    required this.acceptedOffers,
    required this.rejectedOffers,
    required this.unitsOwned,
    required this.savedListings,
    required this.totalInvestmentRequests,
    required this.pendingInvestmentRequests,
    required this.approvedInvestmentRequests,
    required this.rejectedInvestmentRequests,
    required this.paidInvestmentRequests,
    required this.totalSharesOwned,
    required this.projectsWithShares,
    required this.averageSharePercentage,
    required this.sharesBreakdown,
    required this.projectsParticipating,
  });

  factory BuyerStatsModel.fromJson(Map<String, dynamic> json) =>
      _$BuyerStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuyerStatsModelToJson(this);
}
