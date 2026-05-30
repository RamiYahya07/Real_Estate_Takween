import 'package:json_annotation/json_annotation.dart';
import 'package:takween/Features/projects/data/models/pending_payment_model.dart';
import 'package:takween/Features/projects/data/models/share_allocation_model.dart';

part 'project_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectModel {
  final String id;
  final String landPostId;
  final String acceptedBidId;
  final String investmentType;
  final String status;
  final String buildingType;
  final String contractorName;
  final String landOwnerName;
  final int totalShares;
  final DateTime createdAt;
  final List<ShareAllocationModel> shares;
  final PendingPaymentModel? pendingPayment;

  ProjectModel({
    required this.id,
    required this.landPostId,
    required this.acceptedBidId,
    required this.investmentType,
    required this.status,
    required this.buildingType,
    required this.contractorName,
    required this.landOwnerName,
    required this.totalShares,
    required this.createdAt,
    required this.shares,
    this.pendingPayment,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}
