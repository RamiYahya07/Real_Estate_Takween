import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/posts/data/models/land_post_created_model.dart';
import 'package:takween/Features/posts/data/models/land_post_item_details_model.dart';
import 'package:takween/Features/posts/data/models/land_post_item_model.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';
import 'package:takween/Features/posts/data/repos/land_post_repo.dart';

class LandPostRepoImpl implements LandPostRepo {
  final ApiConsumer api;

  LandPostRepoImpl(this.api);

  /// create draft post (landOwner)
  @override
  Future<Either<Failure, LandPostCreatedModel>> createDraftLandPost({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String city,
    required String neighborhood,
    required double areaSqm,
    required double plotWidth,
    required double plotDepth,
    required int investmentType,
    required bool isSealedAuction,
    required int maxAcceptedBids,
    required double priceUsd,
    required bool acceptsAdditionalInvestors,
    required int desiredBuildingType,
    required int desiredFloors,
    required String specialRequirements,
    required int ownershipBasis,
    required bool isRepresentative,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kLandPost,
        body: {
          "title": title,
          "description": description,
          "latitude": latitude,
          "longitude": longitude,
          "city": city,
          "neighborhood": neighborhood,
          "areaSqm": areaSqm,
          "plotWidth": plotWidth,
          "plotDepth": plotDepth,
          "investmentType": investmentType,
          "isSealedAuction": isSealedAuction,
          "maxAcceptedBids": maxAcceptedBids,
          "priceUsd": priceUsd,
          "acceptsAdditionalInvestors": acceptsAdditionalInvestors,
          "desiredBuildingType": desiredBuildingType,
          "desiredFloors": desiredFloors,
          "specialRequirements": specialRequirements,
          "ownershipBasis": ownershipBasis,
          "isRepresentative": isRepresentative,
        },
      );
      final postCreatedResponse = ApiResponse<LandPostCreatedModel>.fromJson(
        response,
        (data) => LandPostCreatedModel.fromJson(data),
      );
      if (postCreatedResponse.success == false) {
        return left(
          ServerFailure(postCreatedResponse.message ?? 'Something went wrong'),
        );
      }
      return Right(postCreatedResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  /// upload post documents(landOwner)
  @override
  Future<Either<Failure, void>> uploadLandPostDocuments({
    required String postId,
    required List<File> documentFiles,
    required List<String> documentTypes,
  }) async {
    try {
      if (documentFiles.length != documentTypes.length) {
        return left(ServerFailure("Files and documentTypes must match"));
      }

      final formData = FormData();

      for (int i = 0; i < documentFiles.length; i++) {
        formData.files.add(
          MapEntry(
            "files",
            await MultipartFile.fromFile(
              documentFiles[i].path,
              filename: documentFiles[i].path.split('/').last,
            ),
          ),
        );

        formData.fields.add(MapEntry("documentTypes", documentTypes[i]));
      }

      await api.postFormData(
        "${EndPoints.kLandPost}$postId${EndPoints.kDocuments}",
        formData: formData,
      );

      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  /// submit draft post (landOwner)
  @override
  Future<Either<Failure, void>> submitDraftLandPost({
    required String postId,
  }) async {
    try {
      await api.post("${EndPoints.kLandPost}$postId${EndPoints.kSubmit}");

      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  /// get land posts(landOwner + Contractor)
  @override
  Future<Either<Failure, List<LandPostItemModel>>> getLandPosts({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await api.get(
        EndPoints.kMyPosts,
        queryParameters: {"page": page, "pageSize": pageSize},
      );

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      final List items = apiResponse.data["items"];

      final posts = items.map((e) => LandPostItemModel.fromJson(e)).toList();

      return Right(posts);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  /// get land Post details (landOwner)
  @override
  Future<Either<Failure, LandPostItemDetailsModel>> getLandPostDetails(
    String postId,
  ) async {
    try {
      final response = await api.get("${EndPoints.kLandPost}/$postId");

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      final postDetails = LandPostItemDetailsModel.fromJson(apiResponse.data);

      return Right(postDetails);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  /// delete land post (landOwner)
  @override
  Future<Either<Failure, void>> deleteLandPost(String postId) async {
    try {
      final response = await api.delete("${EndPoints.kLandPost}/$postId");

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == true) {
        return const Right(null);
      } else {
        return Left(
          ServerFailure(apiResponse.message ?? "Failed to delete post"),
        );
      }
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  /// edit land post (landOwner)
  @override
  Future<Either<Failure, void>> editLandPost({
    required String postId,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String city,
    required String neighborhood,
    required double areaSqm,
    required double plotWidth,
    required double plotDepth,
    required String investmentType,
    required bool isSealedAuction,
    required int maxAcceptedBids,
    required double priceUsd,
    required double pricePerShareUsd,
    required bool acceptsAdditionalInvestors,
    required String desiredBuildingType,
    required int desiredFloors,
    required String specialRequirements,
    required String ownershipBasis,
    required bool isRepresentative,
  }) async {
    try {
      final response = await api.put(
        "${EndPoints.kLandPost}$postId",
        body: {
          "title": title,
          "description": description,
          "latitude": latitude,
          "longitude": longitude,
          "city": city,
          "neighborhood": neighborhood,
          "areaSqm": areaSqm,
          "plotWidth": plotWidth,
          "plotDepth": plotDepth,
          "investmentType": investmentType,
          "isSealedAuction": isSealedAuction,
          "maxAcceptedBids": maxAcceptedBids,
          "priceUsd": priceUsd,
          "acceptsAdditionalInvestors": acceptsAdditionalInvestors,
          "desiredBuildingType": desiredBuildingType,
          "desiredFloors": desiredFloors,
          "specialRequirements": specialRequirements,
          "ownershipBasis": ownershipBasis,
          "isRepresentative": isRepresentative,
        },
      );
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
  
   /// get open land posts (Contractor)
  @override
  Future<Either<Failure, List<LandPostItemModel>>> getOpenLandPosts({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await api.get(
        EndPoints.kLandPost,
        queryParameters: {
          "page": page,
          "pageSize": pageSize,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response,
        (data) => data,
      );

      final List items = apiResponse.data["items"];

      final posts = items
          .map((e) => LandPostItemModel.fromJson(e))
          .toList();

      return Right(posts);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
