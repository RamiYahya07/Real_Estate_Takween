import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
  final String id;
  final String projectId;
  final String senderUserId;
  final String senderName;
  final String content;
  final DateTime sentAt;

  ChatMessageModel({
    required this.id,
    required this.projectId,
    required this.senderUserId,
    required this.senderName,
    required this.content,
    required this.sentAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}
