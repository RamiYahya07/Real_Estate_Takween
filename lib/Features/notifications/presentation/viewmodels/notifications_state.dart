import 'package:equatable/equatable.dart';
import 'package:takween/Features/notifications/data/models/notification_model.dart';

abstract class NotificationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> items;
  final int unreadCount;

  NotificationsLoaded({required this.items, required this.unreadCount});

  @override
  List<Object?> get props => [items, unreadCount];
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
