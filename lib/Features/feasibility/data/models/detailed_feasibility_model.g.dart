// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailed_feasibility_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailedFeasibilityModel _$DetailedFeasibilityModelFromJson(
  Map<String, dynamic> json,
) => DetailedFeasibilityModel(
  projectId: json['projectId'] as String,
  projectTitle: json['projectTitle'] as String,
  city: json['city'] as String,
  landAreaSqm: (json['landAreaSqm'] as num).toDouble(),
  buildableFootprintSqm: (json['buildableFootprintSqm'] as num).toDouble(),
  totalBuildableAreaSqm: (json['totalBuildableAreaSqm'] as num).toDouble(),
  totalSellableAreaSqm: (json['totalSellableAreaSqm'] as num).toDouble(),
  maxFloors: (json['maxFloors'] as num).toInt(),
  estimatedUnits: (json['estimatedUnits'] as num).toInt(),
  constructionCostUsd: (json['constructionCostUsd'] as num).toDouble(),
  timelineMonths: (json['timelineMonths'] as num).toInt(),
  grossRevenueUsd: (json['grossRevenueUsd'] as num).toDouble(),
  sellingExpensesUsd: (json['sellingExpensesUsd'] as num).toDouble(),
  netRevenueUsd: (json['netRevenueUsd'] as num).toDouble(),
  netProfitUsd: (json['netProfitUsd'] as num).toDouble(),
  profitMarginPercent: (json['profitMarginPercent'] as num).toDouble(),
  roiPercent: (json['roiPercent'] as num).toDouble(),
  npv: (json['npv'] as num).toDouble(),
  annualizedIRRPercent: (json['annualizedIRRPercent'] as num).toDouble(),
  rentalAnalysis: json['rentalAnalysis'] == null
      ? null
      : RentalAnalysisModel.fromJson(
          json['rentalAnalysis'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$DetailedFeasibilityModelToJson(
  DetailedFeasibilityModel instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'projectTitle': instance.projectTitle,
  'city': instance.city,
  'landAreaSqm': instance.landAreaSqm,
  'buildableFootprintSqm': instance.buildableFootprintSqm,
  'totalBuildableAreaSqm': instance.totalBuildableAreaSqm,
  'totalSellableAreaSqm': instance.totalSellableAreaSqm,
  'maxFloors': instance.maxFloors,
  'estimatedUnits': instance.estimatedUnits,
  'constructionCostUsd': instance.constructionCostUsd,
  'timelineMonths': instance.timelineMonths,
  'grossRevenueUsd': instance.grossRevenueUsd,
  'sellingExpensesUsd': instance.sellingExpensesUsd,
  'netRevenueUsd': instance.netRevenueUsd,
  'netProfitUsd': instance.netProfitUsd,
  'profitMarginPercent': instance.profitMarginPercent,
  'roiPercent': instance.roiPercent,
  'npv': instance.npv,
  'annualizedIRRPercent': instance.annualizedIRRPercent,
  'rentalAnalysis': instance.rentalAnalysis?.toJson(),
};
