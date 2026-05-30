import 'package:dartz/dartz.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:takween/Features/chat/data/models/chat_message_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class ChatRepo {
  Future<Either<Failure, List<ChatMessageModel>>> getMessages({
    required String projectId,
    int page = 1,
    int pageSize = 50,
  });

  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String projectId,
    required String content,
  });

  Future<Either<Failure, void>> joinProject(String projectId);
  Future<Either<Failure, void>> leaveProject(String projectId);

  Stream<ChatMessageModel> get onNewMessage;
  Stream<String> get onChatError;
  Stream<HubConnectionState> get connectionStateStream;

  Future<void> dispose();
}
