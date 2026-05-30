import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/listings/data/models/listing_list_item_model.dart';
import 'package:takween/Features/listings/data/models/my_offer_model.dart';
import 'package:takween/Features/listings/data/models/property_listing_model.dart';
import 'package:takween/Features/listings/data/models/purchase_offer_model.dart';
import 'package:takween/Features/listings/data/repos/listing_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class ListingRepoImpl implements ListingRepo {
  final ApiConsumer api;

  ListingRepoImpl(this.api);

  @override
  Future<Either<Failure, List<ListingListItemModel>>> getAll({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await api.get(
        EndPoints.kListing,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load listings'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final listings =
          items.map((e) => ListingListItemModel.fromJson(e)).toList();
      return right(listings);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<MyOfferModel>>> getMyOffers({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    try {
      final response = await api.get(
        EndPoints.kListingMyOffers,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load offers'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final offers = items.map((e) => MyOfferModel.fromJson(e)).toList();
      return right(offers);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, PropertyListingModel>> getById(String id) async {
    try {
      final response = await api.get(EndPoints.kListingById(id));
      final apiResponse = ApiResponse<PropertyListingModel>.fromJson(
        response,
        (data) =>
            PropertyListingModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Listing not found'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, String>> create({
    required String projectId,
    required String title,
    String? description,
    required String type,
    required double priceUsd,
    double? areaSqm,
    int? rooms,
    int? floor,
    List<String>? photoUrls,
  }) async {
    try {
      final body = <String, dynamic>{
        'projectId': projectId,
        'title': title,
        'type': type,
        'priceUsd': priceUsd,
      };
      if (description != null && description.isNotEmpty) {
        body['description'] = description;
      }
      if (areaSqm != null) body['areaSqm'] = areaSqm;
      if (rooms != null) body['rooms'] = rooms;
      if (floor != null) body['floor'] = floor;
      if (photoUrls != null && photoUrls.isNotEmpty) {
        body['photoUrls'] = photoUrls;
      }

      final response = await api.post(EndPoints.kListing, body: body);
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to create listing'),
        );
      }
      final id = apiResponse.data is Map<String, dynamic>
          ? (apiResponse.data['id'] as String? ?? '')
          : '';
      return right(id);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> makeOffer({
    required String listingId,
    required double offerPriceUsd,
    String? message,
  }) async {
    try {
      final body = <String, dynamic>{'offerPriceUsd': offerPriceUsd};
      if (message != null && message.isNotEmpty) {
        body['message'] = message;
      }
      final response = await api.post(
        EndPoints.kListingOffer(listingId),
        body: body,
      );
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to submit offer'),
        );
      }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<PurchaseOfferModel>>> getOffers(
    String listingId,
  ) async {
    try {
      final response = await api.get(EndPoints.kListingOffers(listingId));
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load offers'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final offers =
          items.map((e) => PurchaseOfferModel.fromJson(e)).toList();
      return right(offers);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> reviewOffer({
    required String listingId,
    required String offerId,
    required bool approve,
  }) async {
    try {
      final response = await api.put(
        EndPoints.kListingReviewOffer(listingId, offerId),
        body: {'approve': approve},
      );
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to review offer'),
        );
      }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
