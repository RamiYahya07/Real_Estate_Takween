// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractModel _$ContractModelFromJson(Map<String, dynamic> json) =>
    ContractModel(
      id: json['id'] as String?,
      projectId: json['projectId'] as String,
      pdfUrl: json['pdfUrl'] as String?,
      status: json['status'] as String?,
      summary: json['summary'] as String?,
      investmentType: json['investmentType'] as String?,
      totalValueUsd: (json['totalValueUsd'] as num?)?.toDouble(),
      totalShares: (json['totalShares'] as num).toInt(),
      participants: (json['participants'] as List<dynamic>)
          .map(
            (e) => ContractParticipantModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      documentHash: json['documentHash'] as String?,
      signedCount: (json['signedCount'] as num).toInt(),
      requiredSignatures: (json['requiredSignatures'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      fullySignedAt: json['fullySignedAt'] == null
          ? null
          : DateTime.parse(json['fullySignedAt'] as String),
    );

Map<String, dynamic> _$ContractModelToJson(ContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'pdfUrl': instance.pdfUrl,
      'status': instance.status,
      'summary': instance.summary,
      'investmentType': instance.investmentType,
      'totalValueUsd': instance.totalValueUsd,
      'totalShares': instance.totalShares,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'documentHash': instance.documentHash,
      'signedCount': instance.signedCount,
      'requiredSignatures': instance.requiredSignatures,
      'createdAt': instance.createdAt.toIso8601String(),
      'fullySignedAt': instance.fullySignedAt?.toIso8601String(),
    };
