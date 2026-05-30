import 'package:dartz/dartz.dart';
import 'package:takween/Features/authentication/data/models/auth_response_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, AuthResponseModel>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, AuthResponseModel>> createAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    required String password,
    required String confirmPassword,
  });
  Future<Either<Failure, AuthResponseModel>> refreshToken({
    required String refreshToken,
    required String userId,
  });
  Future<Either<Failure, void>> logout();
}
