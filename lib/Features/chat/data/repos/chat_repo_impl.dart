import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:takween/Features/chat/data/models/chat_message_model.dart';
import 'package:takween/Features/chat/data/repos/chat_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';
import 'package:takween/core/realtime/hub_client.dart';

class ChatRepoImpl implements ChatRepo {
  final ApiConsumer api;
  final HubClient hub;

  final StreamController<ChatMessageModel> _newMessageController =
      StreamController<ChatMessageModel>.broadcast();
  final StreamController<String> _chatErrorController =
      StreamController<String>.broadcast();

  bool _eventsBound = false;

  ChatRepoImpl(this.api, this.hub);

  @override
  Stream<ChatMessageModel> get onNewMessage => _newMessageController.stream;

  @override
  Stream<String> get onChatError => _chatErrorController.stream;

  @override
  Stream<HubConnectionState> get connectionStateStream =>
      hub.connectionStateStream;

void _bindEvents() {
  hub.off('NewMessage');
  hub.off('ChatError');

  hub.on('NewMessage', (args) {
    if (args == null || args.isEmpty || args.first == null) return;
    final raw = args.first as Map<String, dynamic>;
    _newMessageController.add(ChatMessageModel.fromJson(raw));
  });

  hub.on('ChatError', (args) {
    if (args == null || args.isEmpty) return;
    _chatErrorController.add(args.first?.toString() ?? 'Chat error');
  });
}

  Future<void> _ensureConnected() async {
    if (!hub.isConnected) {
      await hub.connect();
    }
    _bindEvents();
  }

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getMessages({
    required String projectId,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await api.get(
        EndPoints.kProjectMessages(projectId),
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      final data = apiResponse.data;

      final List items = data is List ? data : (data['items'] ?? []);

      final messages = items
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return right(messages);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String projectId,
    required String content,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kProjectMessages(projectId),
        body: {'content': content},
      );
      final apiResponse = ApiResponse<ChatMessageModel>.fromJson(
        response,
        (data) => ChatMessageModel.fromJson(data),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(ServerFailure(apiResponse.message ?? 'Failed to send'));
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> joinProject(String projectId) async {
    try {
      await _ensureConnected();
      await hub.invoke('JoinProject', args: [projectId]);
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveProject(String projectId) async {
    try {
      if (!hub.isConnected) return const Right(null);
      await hub.invoke('LeaveProject', args: [projectId]);
      return const Right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> dispose() async {
    hub.off('NewMessage');
    hub.off('ChatError');
    _eventsBound = false;
    await _newMessageController.close();
    await _chatErrorController.close();
  }
}
