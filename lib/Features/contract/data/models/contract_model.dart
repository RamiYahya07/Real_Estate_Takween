import 'package:json_annotation/json_annotation.dart';
import 'package:takween/Features/contract/data/models/contract_participant_model.dart';

part 'contract_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ContractModel {
  final String? id;
  final String projectId;
  final String? pdfUrl;
  final String? status;
  final String? summary;
  final String? investmentType;
  final double? totalValueUsd;
  final int totalShares;
  final List<ContractParticipantModel> participants;
  final String? documentHash;
  final int signedCount;
  final int requiredSignatures;
  final DateTime createdAt;
  final DateTime? fullySignedAt;

  ContractModel({
    required this.id,
    required this.projectId,
    required this.pdfUrl,
    required this.status,
    required this.summary,
    required this.investmentType,
    this.totalValueUsd,
    required this.totalShares,
    required this.participants,
    required this.documentHash,
    required this.signedCount,
    required this.requiredSignatures,
    required this.createdAt,
    this.fullySignedAt,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);
}
