import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? password;
  final String? confirmPassword;
  final String? city;
  final String? phoneNumber;
  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    this.confirmPassword,
    required this.role,
    this.city,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) =>
      _$UserModelFromJson(jsonData);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
