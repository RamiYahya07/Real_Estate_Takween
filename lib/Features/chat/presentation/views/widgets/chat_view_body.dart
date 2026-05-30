import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/Features/chat/presentation/viewmodels/chat/chat_cubit.dart';
import 'package:takween/Features/chat/presentation/viewmodels/chat/chat_state.dart';
import 'package:takween/Features/chat/presentation/views/widgets/message_bubble.dart';
import 'package:takween/Features/chat/presentation/views/widgets/message_input_bar.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class ChatViewBody extends StatefulWidget {
  final String projectId;

  const ChatViewBody({super.key, required this.projectId});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadCurrentUserId() async {
    final id = await sl<SecureStorageService>().getUserId();
    if (mounted) {
      setState(() => _currentUserId = id);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      context.read<ChatCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatTransientError) {
          context.showErrorSnackBar(state.message);
        }
      },
      buildWhen: (previous, current) => current is! ChatTransientError,
      builder: (context, state) {
        if (state is ChatLoadingState || state is ChatInitialState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatFailureState) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<ChatCubit>().init(widget.projectId),
          );
        }

        if (state is ChatLoadedState) {
          return Column(
            children: [
              _ConnectionBanner(
                isConnected: state.isConnected,
                isReconnecting: state.isReconnecting,
              ),
              Expanded(
                child: state.messages.isEmpty
                    ? _EmptyView()
                    : RefreshIndicator(
                        onRefresh: () => context.read<ChatCubit>().refresh(),
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          itemCount:
                              state.messages.length +
                              (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.messages.length) {
                              return Padding(
                                padding: EdgeInsets.all(12.w),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final msg = state.messages[index];
                            final isMine =
                                _currentUserId != null &&
                                msg.senderUserId == _currentUserId;
                            final next = index > 0
                                ? state.messages[index - 1]
                                : null;
                            final showSender =
                                next == null ||
                                next.senderUserId != msg.senderUserId;
                            return MessageBubble(
                              message: msg,
                              isMine: isMine,
                              showSender: showSender,
                            );
                          },
                        ),
                      ),
              ),
              MessageInputBar(
                isSending: state.isSending,
                enabled: state.isConnected,
                onSend: (content) => context.read<ChatCubit>().send(content),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _ConnectionBanner extends StatelessWidget {
  final bool isConnected;
  final bool isReconnecting;

  const _ConnectionBanner({
    required this.isConnected,
    required this.isReconnecting,
  });

  @override
  Widget build(BuildContext context) {
    if (isConnected && !isReconnecting) {
      return const SizedBox.shrink();
    }
    final color = isReconnecting ? AppColors.warning : AppColors.error;
    final label = isReconnecting ? 'Reconnecting...' : 'Disconnected';
    return Container(
      width: double.infinity,
      color: color.withValues(alpha: 0.12),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 12.w,
            height: 12.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 120.h),
        Icon(
          Icons.forum_outlined,
          size: 56.sp,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            'No messages yet',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 6.h),
        Center(
          child: Text(
            'Be the first to start the conversation',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textTertiaryLight,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
