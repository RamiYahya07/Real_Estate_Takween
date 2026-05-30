// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shares_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharesStatisticsModel _$SharesStatisticsModelFromJson(
  Map<String, dynamic> json,
) => SharesStatisticsModel(
  totalSharesOwned: (json['totalSharesOwned'] as num).toInt(),
  projectsWithShares: (json['projectsWithShares'] as num).toInt(),
  averageSharePercentage: (json['averageSharePercentage'] as num).toDouble(),
  breakdown: (json['breakdown'] as List<dynamic>)
      .map((e) => ProjectShareModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SharesStatisticsModelToJson(
  SharesStatisticsModel instance,
) => <String, dynamic>{
  'totalSharesOwned': instance.totalSharesOwned,
  'projectsWithShares': instance.projectsWithShares,
  'averageSharePercentage': instance.averageSharePercentage,
  'breakdown': instance.breakdown.map((e) => e.toJson()).toList(),
};
