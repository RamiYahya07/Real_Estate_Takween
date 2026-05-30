import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/Features/chat/data/models/chat_message_model.dart';
import 'package:takween/core/theme/colors.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMine;
  final bool showSender;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.showSender,
  });

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bubbleColor = isMine
        ? AppColors.primary
        : theme.brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05);
    final textColor =
        isMine ? Colors.white : theme.textTheme.bodyMedium?.color;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (showSender && !isMine)
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, bottom: 2.h),
                    child: Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      topRight: Radius.circular(14.r),
                      bottomLeft: Radius.circular(isMine ? 14.r : 4.r),
                      bottomRight: Radius.circular(isMine ? 4.r : 14.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.content,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13.sp,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _formatTime(message.sentAt),
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: isMine
                              ? Colors.white.withValues(alpha: 0.8)
                              : theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
