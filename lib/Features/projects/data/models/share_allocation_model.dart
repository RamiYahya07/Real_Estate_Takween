import 'package:json_annotation/json_annotation.dart';

part 'share_allocation_model.g.dart';

@JsonSerializable()
class ShareAllocationModel {
  final String id;
  final String userId;
  final String userName;
  final int shareCount;
  final double percentage;
  final String role;
  final String contributionType;
  final DateTime allocatedAt;

  ShareAllocationModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.shareCount,
    required this.percentage,
    required this.role,
    required this.contributionType,
    required this.allocatedAt,
  });

  factory ShareAllocationModel.fromJson(Map<String, dynamic> json) =>
      _$ShareAllocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShareAllocationModelToJson(this);
}
