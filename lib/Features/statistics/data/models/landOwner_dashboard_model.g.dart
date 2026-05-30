// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landOwner_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandownerDashboardModel _$LandownerDashboardModelFromJson(
  Map<String, dynamic> json,
) => LandownerDashboardModel(
  totalPosts: (json['totalPosts'] as num).toInt(),
  openPosts: (json['openPosts'] as num).toInt(),
  closedPosts: (json['closedPosts'] as num).toInt(),
  draftPosts: (json['draftPosts'] as num).toInt(),
  receivedBids: (json['receivedBids'] as num).toInt(),
  pendingBids: (json['pendingBids'] as num).toInt(),
);

Map<String, dynamic> _$LandownerDashboardModelToJson(
  LandownerDashboardModel instance,
) => <String, dynamic>{
  'totalPosts': instance.totalPosts,
  'openPosts': instance.openPosts,
  'closedPosts': instance.closedPosts,
  'draftPosts': instance.draftPosts,
  'receivedBids': instance.receivedBids,
  'pendingBids': instance.pendingBids,
};
