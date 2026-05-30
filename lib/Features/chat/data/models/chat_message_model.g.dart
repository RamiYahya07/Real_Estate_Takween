// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      senderUserId: json['senderUserId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'senderUserId': instance.senderUserId,
      'senderName': instance.senderName,
      'content': instance.content,
      'sentAt': instance.sentAt.toIso8601String(),
    };
