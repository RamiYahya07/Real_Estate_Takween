import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/authentication/data/models/auth_response_model.dart';
import 'package:takween/Features/authentication/data/repos/auth_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/data/shared_prefs_service.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/errors/failures.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer api;

  AuthRepoImpl(this.api);

  @override
  Future<Either<Failure, AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kLogin,
        body: {"email": email, "password": password},
      );
      final loginResponse = ApiResponse<AuthResponseModel>.fromJson(
        response,
        (data) => AuthResponseModel.fromJson(data),
      );
      if (loginResponse.success == false) {
        return left(
          ServerFailure(loginResponse.message ?? 'Something went wrong'),
        );
      }
      

      return right(loginResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> createAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kRegister,
        body: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "role": role,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );

      final user = ApiResponse<AuthResponseModel>.fromJson(
        response,
        (data) => AuthResponseModel.fromJson(data),
      );
      return right(user.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> refreshToken({
    required String refreshToken,
    required String userId,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kRefershToken,
        body: {"refreshToken": refreshToken, "userId": userId},
      );
      final user = ApiResponse<AuthResponseModel>.fromJson(
        response,
        (data) => AuthResponseModel.fromJson(data),
      );
      return right(user.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await sl<AppPreferences>().setSignedIn(false);
      await sl<SecureStorageService>().deleteToken();
      await sl<SecureStorageService>().deleteRole();
      await sl<SecureStorageService>().deleteuserId();

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
// if (!apiResponse.success) {
//   return left(ServerFailure(apiResponse.message ?? 'Error'));
// }

// if (apiResponse.data == null) {
//   return left(ServerFailure('No data returned'));
// }
