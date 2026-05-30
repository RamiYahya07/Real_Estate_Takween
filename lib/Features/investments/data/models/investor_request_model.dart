class InvestorRequestModel {
  final String id;
  final String projectId;
  final String investorUserId;
  final String investorName;
  final double investmentAmountUsd;
  final int requestedShares;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  InvestorRequestModel({
    required this.id,
    required this.projectId,
    required this.investorUserId,
    required this.investorName,
    required this.investmentAmountUsd,
    required this.requestedShares,
    required this.status,
    this.notes,
    required this.createdAt,
    this.reviewedAt,
  });

  factory InvestorRequestModel.fromJson(Map<String, dynamic> json) {
    return InvestorRequestModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      investorUserId: json['investorUserId'] as String? ?? '',
      investorName: json['investorName'] as String? ?? '',
      investmentAmountUsd:
          (json['investmentAmountUsd'] as num?)?.toDouble() ?? 0,
      requestedShares: (json['requestedShares'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'PENDING',
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
    );
  }
}
