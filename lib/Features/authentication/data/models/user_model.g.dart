// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  password: json['password'] as String?,
  confirmPassword: json['confirmPassword'] as String?,
  role: json['role'] as String,
  city: json['city'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'role': instance.role,
  'password': instance.password,
  'confirmPassword': instance.confirmPassword,
  'city': instance.city,
  'phoneNumber': instance.phoneNumber,
};
