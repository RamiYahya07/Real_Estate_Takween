import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/notifications/data/models/notification_model.dart';
import 'package:takween/Features/notifications/presentation/viewmodels/notifications_cubit.dart';
import 'package:takween/Features/notifications/presentation/viewmodels/notifications_state.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationsCubit>()..start(),
      child: const _BellButton(),
    );
  }
}

class _BellButton extends StatelessWidget {
  const _BellButton();

  void _openSheet(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const _NotificationsSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final unread = state is NotificationsLoaded ? state.unreadCount : 0;
        final icon = const FaIcon(FontAwesomeIcons.bell);
        return IconButton(
          onPressed: () => _openSheet(context),
          icon: unread > 0
              ? Badge(
                  label: Text(unread > 99 ? '99+' : '$unread'),
                  backgroundColor: AppColors.error,
                  child: icon,
                )
              : icon,
        );
      },
    );
  }
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 8.w, 4.h),
              child: Row(
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        context.read<NotificationsCubit>().markAllRead(),
                    child: const Text('Mark all read'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading ||
                      state is NotificationsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is NotificationsError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(state.message, textAlign: TextAlign.center),
                      ),
                    );
                  }
                  if (state is NotificationsLoaded) {
                    if (state.items.isEmpty) {
                      return Center(
                        child: Text(
                          'No notifications yet.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.primaryMuted,
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<NotificationsCubit>().refresh(),
                      child: ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.all(12.w),
                        itemCount: state.items.length,
                        separatorBuilder: (_, _) => SizedBox(height: 8.h),
                        itemBuilder: (_, i) => _NotificationTile(
                          notification: state.items[i],
                          onTap: () => context
                              .read<NotificationsCubit>()
                              .markRead(state.items[i].id),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    return InkWell(
      onTap: unread ? onTap : null,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: unread
              ? AppColors.primaryContainerLight.withValues(alpha: 0.5)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.borderLight.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (unread)
              Container(
                margin: EdgeInsets.only(top: 5.h, right: 8.w),
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primaryMuted,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    _formatTime(notification.createdAt),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.primaryMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
