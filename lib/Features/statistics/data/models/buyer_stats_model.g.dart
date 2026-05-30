// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuyerStatsModel _$BuyerStatsModelFromJson(
  Map<String, dynamic> json,
) => BuyerStatsModel(
  totalOffers: (json['totalOffers'] as num).toInt(),
  pendingOffers: (json['pendingOffers'] as num).toInt(),
  acceptedOffers: (json['acceptedOffers'] as num).toInt(),
  rejectedOffers: (json['rejectedOffers'] as num).toInt(),
  unitsOwned: (json['unitsOwned'] as num).toInt(),
  savedListings: (json['savedListings'] as num).toInt(),
  totalInvestmentRequests: (json['totalInvestmentRequests'] as num).toInt(),
  pendingInvestmentRequests: (json['pendingInvestmentRequests'] as num).toInt(),
  approvedInvestmentRequests: (json['approvedInvestmentRequests'] as num)
      .toInt(),
  rejectedInvestmentRequests: (json['rejectedInvestmentRequests'] as num)
      .toInt(),
  paidInvestmentRequests: (json['paidInvestmentRequests'] as num).toInt(),
  totalSharesOwned: (json['totalSharesOwned'] as num).toInt(),
  projectsWithShares: (json['projectsWithShares'] as num).toInt(),
  averageSharePercentage: (json['averageSharePercentage'] as num).toDouble(),
  sharesBreakdown: (json['sharesBreakdown'] as List<dynamic>)
      .map((e) => ProjectShareModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  projectsParticipating: (json['projectsParticipating'] as num).toInt(),
);

Map<String, dynamic> _$BuyerStatsModelToJson(
  BuyerStatsModel instance,
) => <String, dynamic>{
  'totalOffers': instance.totalOffers,
  'pendingOffers': instance.pendingOffers,
  'acceptedOffers': instance.acceptedOffers,
  'rejectedOffers': instance.rejectedOffers,
  'unitsOwned': instance.unitsOwned,
  'savedListings': instance.savedListings,
  'totalInvestmentRequests': instance.totalInvestmentRequests,
  'pendingInvestmentRequests': instance.pendingInvestmentRequests,
  'approvedInvestmentRequests': instance.approvedInvestmentRequests,
  'rejectedInvestmentRequests': instance.rejectedInvestmentRequests,
  'paidInvestmentRequests': instance.paidInvestmentRequests,
  'totalSharesOwned': instance.totalSharesOwned,
  'projectsWithShares': instance.projectsWithShares,
  'averageSharePercentage': instance.averageSharePercentage,
  'sharesBreakdown': instance.sharesBreakdown.map((e) => e.toJson()).toList(),
  'projectsParticipating': instance.projectsParticipating,
};
