// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contractor_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractorDashboardModel _$ContractorDashboardModelFromJson(
  Map<String, dynamic> json,
) => ContractorDashboardModel(
  totalBids: (json['totalBids'] as num).toInt(),
  pendingBids: (json['pendingBids'] as num).toInt(),
  acceptedBids: (json['acceptedBids'] as num).toInt(),
  rejectedBids: (json['rejectedBids'] as num).toInt(),
);

Map<String, dynamic> _$ContractorDashboardModelToJson(
  ContractorDashboardModel instance,
) => <String, dynamic>{
  'totalBids': instance.totalBids,
  'pendingBids': instance.pendingBids,
  'acceptedBids': instance.acceptedBids,
  'rejectedBids': instance.rejectedBids,
};
