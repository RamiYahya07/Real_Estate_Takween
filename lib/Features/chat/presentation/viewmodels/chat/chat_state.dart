import 'package:equatable/equatable.dart';
import 'package:takween/Features/chat/data/models/chat_message_model.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<ChatMessageModel> messages;
  final bool hasNext;
  final bool isLoadingMore;
  final bool isSending;
  final bool isConnected;
  final bool isReconnecting;

  ChatLoadedState({
    required this.messages,
    required this.hasNext,
    required this.isLoadingMore,
    required this.isSending,
    required this.isConnected,
    required this.isReconnecting,
  });

  ChatLoadedState copyWith({
    List<ChatMessageModel>? messages,
    bool? hasNext,
    bool? isLoadingMore,
    bool? isSending,
    bool? isConnected,
    bool? isReconnecting,
  }) {
    return ChatLoadedState(
      messages: messages ?? this.messages,
      hasNext: hasNext ?? this.hasNext,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSending: isSending ?? this.isSending,
      isConnected: isConnected ?? this.isConnected,
      isReconnecting: isReconnecting ?? this.isReconnecting,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        hasNext,
        isLoadingMore,
        isSending,
        isConnected,
        isReconnecting,
      ];
}

class ChatFailureState extends ChatState {
  final String message;
  ChatFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatTransientError extends ChatState {
  final String message;
  ChatTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}
