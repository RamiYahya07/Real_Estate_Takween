import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/profile/data/models/profile_model.dart';
import 'package:takween/Features/profile/data/repos/profile_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class ProfileRepoImpl extends ProfileRepo {
  final ApiConsumer api;
  ProfileRepoImpl(this.api);

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final response = await api.get(EndPoints.kProfile);
      if (response == null || response.isEmpty) {
        return left(ServerFailure('Unauthorized or empty response'));
      }
      final profileResponse = ApiResponse<ProfileModel>.fromJson(
        response,
        (data) => ProfileModel.fromJson(data),
      );
      return right(profileResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }


  @override
  Future<Either<Failure, void>> editProfile({
    required String fullName,
    required String bio,
    required String city,
    required String phoneNumber,
    required String nationalId,
  }) async {
    try {
      final response = await api.put(
        EndPoints.kProfile,
        body: {
          "fullName": fullName,
          "bio": bio,
          "city": city,
          "phoneNumber": phoneNumber,
          "nationalId": nationalId,
        },
      );

      final editedProfileResponse = ApiResponse<void>.fromJson(response, null);

      if (!editedProfileResponse.success) {
        return left(ServerFailure(editedProfileResponse.message ?? 'Error'));
      }

      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> uploadProfilePicture({
    required File imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      await api.postFormData(
        EndPoints.kUploadProfilePicture,
        formData: formData,
      );

      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
