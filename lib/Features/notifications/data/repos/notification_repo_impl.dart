import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/notifications/data/models/notification_model.dart';
import 'package:takween/Features/notifications/data/repos/notification_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class NotificationRepoImpl implements NotificationRepo {
  final ApiConsumer api;

  NotificationRepoImpl(this.api);

  @override
  Future<Either<Failure, List<NotificationModel>>> getMyNotifications({
    int page = 1,
    int pageSize = 30,
  }) async {
    try {
      final response = await api.get(
        EndPoints.kNotifications,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load notifications'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final notifications =
          items.map((e) => NotificationModel.fromJson(e)).toList();
      return right(notifications);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> markRead(List<String> ids) async {
    try {
      final response = await api.put(
        EndPoints.kNotificationsRead,
        body: {'ids': ids},
      );
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success) {
        return left(ServerFailure(apiResponse.message ?? 'Failed to mark read'));
      }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> markAllRead() async {
    try {
      final response = await api.put(EndPoints.kNotificationsMarkAllRead);
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success) {
        return left(ServerFailure(apiResponse.message ?? 'Failed to mark read'));
      }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
