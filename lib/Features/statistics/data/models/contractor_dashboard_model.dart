import 'package:json_annotation/json_annotation.dart';
part 'contractor_dashboard_model.g.dart';

@JsonSerializable()
class ContractorDashboardModel {
  final int totalBids;
  final int pendingBids;
  final int acceptedBids;
  final int rejectedBids;

  ContractorDashboardModel({
    required this.totalBids,
    required this.pendingBids,
    required this.acceptedBids,
    required this.rejectedBids,
  });

  factory ContractorDashboardModel.fromJson(Map<String, dynamic> jsonData) =>
      _$ContractorDashboardModelFromJson(jsonData);
  Map<String, dynamic> toJson() => _$ContractorDashboardModelToJson(this);
}
