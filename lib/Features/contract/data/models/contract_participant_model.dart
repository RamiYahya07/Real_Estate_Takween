import 'package:json_annotation/json_annotation.dart';

part 'contract_participant_model.g.dart';

@JsonSerializable()
class ContractParticipantModel {
  final String userId;
  final String name;
  final String? fullName;
  final String role;
  final int shares;
  final double percentage;
  final bool hasSigned;
  final DateTime? signedAt;

  ContractParticipantModel({
    required this.userId,
    required this.name,
    this.fullName,
    required this.role,
    required this.shares,
    required this.percentage,
    required this.hasSigned,
    this.signedAt,
  });

  factory ContractParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ContractParticipantModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractParticipantModelToJson(this);
}
