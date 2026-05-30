// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: json['id'] as String,
  userName: json['userName'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  fullName: json['fullName'] as String,
  bio: json['bio'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  city: json['city'] as String?,
  nationalId: json['nationalId'] as String?,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'fullName': instance.fullName,
      'bio': instance.bio,
      'avatarUrl': instance.avatarUrl,
      'city': instance.city,
      'nationalId': instance.nationalId,
      'roles': instance.roles,
      'createdAt': instance.createdAt.toIso8601String(),
    };
