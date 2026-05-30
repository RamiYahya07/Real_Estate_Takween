import 'package:json_annotation/json_annotation.dart';
import 'package:takween/Features/projects/data/models/shareholder_allocation_result_model.dart';

part 'allocation_result_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AllocationResultModel {
  final int totalUnits;
  final int allocatedUnits;
  final List<ShareholderAllocationResultModel> shareholders;

  AllocationResultModel({
    required this.totalUnits,
    required this.allocatedUnits,
    required this.shareholders,
  });

  factory AllocationResultModel.fromJson(Map<String, dynamic> json) =>
      _$AllocationResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllocationResultModelToJson(this);
}
