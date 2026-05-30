import 'package:json_annotation/json_annotation.dart';

part 'land_post_created_model.g.dart';

@JsonSerializable()
class LandPostCreatedModel {
  final String? message;
  final String id;
  final String? status;
  final String? checkoutUrl;

  LandPostCreatedModel({
    required this.message,
    required this.status,
    required this.checkoutUrl,
    required this.id,
  });
  factory LandPostCreatedModel.fromJson(Map<String, dynamic> jsonData) =>
      _$LandPostCreatedModelFromJson(jsonData);
  Map<String, dynamic> toJson() => _$LandPostCreatedModelToJson(this);
}
