class InvestmentOpportunityModel {
  final String projectId;
  final String title;
  final String city;
  final String neighborhood;
  final double areaSqm;
  final String buildingType;
  final double? estimatedCostUsd;
  final int availableShares;
  final int currentInvestorCount;
  final String projectStatus;
  final DateTime createdAt;

  InvestmentOpportunityModel({
    required this.projectId,
    required this.title,
    required this.city,
    required this.neighborhood,
    required this.areaSqm,
    required this.buildingType,
    this.estimatedCostUsd,
    required this.availableShares,
    required this.currentInvestorCount,
    required this.projectStatus,
    required this.createdAt,
  });

  factory InvestmentOpportunityModel.fromJson(Map<String, dynamic> json) {
    return InvestmentOpportunityModel(
      projectId: json['projectId'] as String,
      title: json['title'] as String? ?? '',
      city: json['city'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      areaSqm: (json['areaSqm'] as num?)?.toDouble() ?? 0,
      buildingType: json['buildingType'] as String? ?? '',
      estimatedCostUsd: (json['estimatedCostUsd'] as num?)?.toDouble(),
      availableShares: (json['availableShares'] as num?)?.toInt() ?? 0,
      currentInvestorCount:
          (json['currentInvestorCount'] as num?)?.toInt() ?? 0,
      projectStatus: json['projectStatus'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
