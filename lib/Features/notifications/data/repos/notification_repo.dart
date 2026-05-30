import 'package:dartz/dartz.dart';
import 'package:takween/Features/notifications/data/models/notification_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationModel>>> getMyNotifications({
    int page = 1,
    int pageSize = 30,
  });

  Future<Either<Failure, void>> markRead(List<String> ids);

  Future<Either<Failure, void>> markAllRead();
}
