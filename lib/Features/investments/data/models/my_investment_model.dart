class MyInvestmentModel {
  final String id;
  final String projectId;
  final String projectTitle;
  final String projectCity;
  final double investmentAmountUsd;
  final int requestedShares;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  MyInvestmentModel({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.projectCity,
    required this.investmentAmountUsd,
    required this.requestedShares,
    required this.status,
    this.notes,
    required this.createdAt,
    this.reviewedAt,
  });

  factory MyInvestmentModel.fromJson(Map<String, dynamic> json) {
    return MyInvestmentModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      projectTitle: json['projectTitle'] as String? ?? '',
      projectCity: json['projectCity'] as String? ?? '',
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
