import 'package:json_annotation/json_annotation.dart';
import 'package:takween/Features/statistics/data/models/project_share_model.dart';

part 'shares_statistics_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharesStatisticsModel {
  final int totalSharesOwned;
  final int projectsWithShares;
  final double averageSharePercentage;
  final List<ProjectShareModel> breakdown;

  SharesStatisticsModel({
    required this.totalSharesOwned,
    required this.projectsWithShares,
    required this.averageSharePercentage,
    required this.breakdown,
  });

  factory SharesStatisticsModel.fromJson(Map<String, dynamic> jsonData) =>
      _$SharesStatisticsModelFromJson(jsonData);

  Map<String, dynamic> toJson() => _$SharesStatisticsModelToJson(this);
}
