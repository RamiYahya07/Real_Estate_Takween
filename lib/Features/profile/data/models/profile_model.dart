import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String id;
  final String userName;
  final String email;
  final String? phoneNumber;
  final String fullName;
  final String? bio;
  final String? avatarUrl;
  final String? city;
  final String? nationalId;
  final List<String> roles;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.bio,
    required this.avatarUrl,
    required this.city,
    required this.nationalId,
    required this.roles,
    required this.createdAt,
  });
  factory ProfileModel.fromJson(Map<String, dynamic> jsonData) =>
      _$ProfileModelFromJson(jsonData);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
