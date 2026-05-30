import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/notifications/data/models/notification_model.dart';
import 'package:takween/Features/notifications/data/repos/notification_realtime_repo.dart';
import 'package:takween/Features/notifications/data/repos/notification_repo.dart';
import 'package:takween/Features/notifications/presentation/viewmodels/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepo repo;
  final NotificationRealtimeRepo realtime;

  NotificationsCubit(this.repo, this.realtime)
      : super(NotificationsInitial());

  StreamSubscription<void>? _sub;
  List<NotificationModel> _items = [];

  Future<void> start() async {
    try {
      await realtime.ensureConnected();
      _sub ??= realtime.onAny.listen((_) => _load(silent: true));
    } catch (_) {}
    await _load();
  }

  Future<void> refresh() => _load(silent: true);

  Future<void> _load({bool silent = false}) async {
    if (!silent) emit(NotificationsLoading());
    final result = await repo.getMyNotifications();
    result.fold(
      (failure) {
        if (!silent) emit(NotificationsError(failure.errMessage));
      },
      (items) {
        _items = items;
        emit(NotificationsLoaded(
          items: List.unmodifiable(_items),
          unreadCount: _items.where((n) => !n.isRead).length,
        ));
      },
    );
  }

  Future<void> markAllRead() async {
    final result = await repo.markAllRead();
    result.fold((_) {}, (_) => _load(silent: true));
  }

  Future<void> markRead(String id) async {
    final result = await repo.markRead([id]);
    result.fold((_) {}, (_) => _load(silent: true));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
