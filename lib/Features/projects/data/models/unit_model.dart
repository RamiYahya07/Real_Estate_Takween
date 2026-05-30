import 'package:json_annotation/json_annotation.dart';

part 'unit_model.g.dart';

@JsonSerializable()
class UnitModel {
  final String id;
  final String projectId;
  final String unitNumber;
  final int floor;
  final double areaSqm;
  final String? unitType;
  final String status;
  final String? allocatedToUserId;
  final String? allocatedToName;
  final DateTime createdAt;

  UnitModel({
    required this.id,
    required this.projectId,
    required this.unitNumber,
    required this.floor,
    required this.areaSqm,
    this.unitType,
    required this.status,
    this.allocatedToUserId,
    this.allocatedToName,
    required this.createdAt,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}
