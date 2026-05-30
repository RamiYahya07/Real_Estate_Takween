import 'package:json_annotation/json_annotation.dart';

part 'project_list_item_model.g.dart';

@JsonSerializable()
class ProjectListItemModel {
  final String id;
  final String title;
  final String city;
  final String investmentType;
  final String status;
  final String contractorName;
  final String landOwnerName;
  final DateTime createdAt;

  ProjectListItemModel({
    required this.id,
    required this.title,
    required this.city,
    required this.investmentType,
    required this.status,
    required this.contractorName,
    required this.landOwnerName,
    required this.createdAt,
  });

  factory ProjectListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectListItemModelToJson(this);
}
