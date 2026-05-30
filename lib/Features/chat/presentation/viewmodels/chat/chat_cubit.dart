import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:takween/Features/chat/data/models/chat_message_model.dart';
import 'package:takween/Features/chat/data/repos/chat_repo.dart';
import 'package:takween/Features/chat/presentation/viewmodels/chat/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo repo;

  ChatCubit(this.repo) : super(ChatInitialState());

  String? _projectId;

  final List<ChatMessageModel> _messages = [];
  int _page = 1;
  final int _pageSize = 50;
  bool _hasNext = true;
  bool _isLoadingMore = false;
  bool _isSending = false;
  bool _isConnected = false;
  bool _isReconnecting = false;
  bool _connectionInitialized = false;

  StreamSubscription<ChatMessageModel>? _newMessageSub;
  StreamSubscription<String>? _errorSub;
  StreamSubscription<HubConnectionState>? _connectionSub;

  Future<void> init(String projectId) async {
    await _newMessageSub?.cancel();
    await _errorSub?.cancel();
    await _connectionSub?.cancel();

    _newMessageSub = null;
    _errorSub = null;
    _connectionSub = null;
    _projectId = projectId;

    _messages.clear();
    _page = 1;
    _hasNext = true;
    _isLoadingMore = false;
    _isSending = false;
    _isConnected = false;
    _isReconnecting = false;
    _connectionInitialized = false;
    emit(ChatLoadingState());

    _connectionSub = repo.connectionStateStream.listen((state) {
      _isConnected = state == HubConnectionState.Connected;
      _isReconnecting = state == HubConnectionState.Reconnecting;
      _connectionInitialized = true;
      _emitLoaded();
    });

    final joinResult = await repo.joinProject(projectId);
    final joinFailure = joinResult.fold<String?>(
      (f) => f.errMessage,
      (_) => null,
    );
    if (joinFailure != null) {
      emit(ChatFailureState(joinFailure));
      return;
    }

    _newMessageSub = repo.onNewMessage.listen(_onIncomingMessage);
    _errorSub = repo.onChatError.listen((msg) {
      emit(ChatTransientError(msg));
      _emitLoaded();
    });

    await _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    if (_projectId == null) return;
    _page = 1;
    _hasNext = true;
    _messages.clear();

    final result = await repo.getMessages(
      projectId: _projectId!,
      page: _page,
      pageSize: _pageSize,
    );
    result.fold((failure) => emit(ChatFailureState(failure.errMessage)), (
      data,
    ) {
      _messages
        ..clear()
        ..addAll(data);
      _hasNext = data.length == _pageSize;
      _emitLoaded();
    });
  }

  Future<void> refresh() => _loadFirstPage();

  Future<void> loadMore() async {
    if (_projectId == null || _isLoadingMore || !_hasNext) return;
    _isLoadingMore = true;
    _emitLoaded();
    _page++;

    final result = await repo.getMessages(
      projectId: _projectId!,
      page: _page,
      pageSize: _pageSize,
    );
    result.fold(
      (failure) {
        _isLoadingMore = false;
        _page--;
        emit(ChatTransientError(failure.errMessage));
        _emitLoaded();
      },
      (data) {
        _isLoadingMore = false;
        _messages.addAll(data);
        _hasNext = data.length == _pageSize;
        _emitLoaded();
      },
    );
  }

  Future<void> send(String content) async {
    final trimmed = content.trim();
    if (_projectId == null || trimmed.isEmpty || _isSending) return;

    _isSending = true;
    _emitLoaded();

    final result = await repo.sendMessage(
      projectId: _projectId!,
      content: trimmed,
    );
    result.fold(
      (failure) {
        _isSending = false;
        emit(ChatTransientError(failure.errMessage));
        _emitLoaded();
      },
      (msg) {
        _isSending = false;
        _onIncomingMessage(msg);
      },
    );
  }

  void _onIncomingMessage(ChatMessageModel msg) {
    if (_messages.any((m) => m.id == msg.id)) {
      _emitLoaded();
      return;
    }
    _messages.insert(0, msg);
    _emitLoaded();
  }

  void _emitLoaded() {
    emit(
      ChatLoadedState(
        messages: List.unmodifiable(_messages),
        hasNext: _hasNext,
        isLoadingMore: _isLoadingMore,
        isSending: _isSending,
        isConnected: _connectionInitialized ? _isConnected : true,
        isReconnecting: _isReconnecting,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _newMessageSub?.cancel();
    await _errorSub?.cancel();
    await _connectionSub?.cancel();
    if (_projectId != null) {
      await repo.leaveProject(_projectId!);
    }
    return super.close();
  }
}
