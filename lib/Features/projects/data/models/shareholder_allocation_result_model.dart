import 'package:json_annotation/json_annotation.dart';

part 'shareholder_allocation_result_model.g.dart';

@JsonSerializable()
class ShareholderAllocationResultModel {
  final String userId;
  final String userName;
  final int shares;
  final double percentage;
  final int entitledUnits;
  final List<String> assignedUnits;

  ShareholderAllocationResultModel({
    required this.userId,
    required this.userName,
    required this.shares,
    required this.percentage,
    required this.entitledUnits,
    required this.assignedUnits,
  });

  factory ShareholderAllocationResultModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ShareholderAllocationResultModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ShareholderAllocationResultModelToJson(this);
}
