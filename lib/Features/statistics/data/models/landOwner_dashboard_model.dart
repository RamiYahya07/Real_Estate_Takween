import 'package:json_annotation/json_annotation.dart';
part 'landOwner_dashboard_model.g.dart';

@JsonSerializable()
class LandownerDashboardModel {
  final int totalPosts;
  final int openPosts;
  final int closedPosts;
  final int draftPosts;
  final int receivedBids;
  final int pendingBids;

  LandownerDashboardModel({
    required this.totalPosts,
    required this.openPosts,
    required this.closedPosts,
    required this.draftPosts,
    required this.receivedBids,
    required this.pendingBids,
  });

  factory LandownerDashboardModel.fromJson(Map<String, dynamic> jsonData) =>
      _$LandownerDashboardModelFromJson(jsonData);
  Map<String, dynamic> toJson() => _$LandownerDashboardModelToJson(this);
}
