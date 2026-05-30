import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/bid/data/models/bid_details_model.dart';
import 'package:takween/Features/bid/data/models/bid_item_model.dart';
import 'package:takween/Features/bid/data/models/bid_summary_model.dart';
import 'package:takween/Features/bid/data/repos/bid_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class BidRepoImpl implements BidRepo {
  final ApiConsumer api;

  BidRepoImpl(this.api);

  // ================= DIRECT SALE =================
  @override
  Future<Either<Failure, void>> directSale({
    required String landPostId,
    required double offerPriceUsd,
    required String proposedApproach,
    required String notes,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kDirectSale,
        body: {
          'landPostId': landPostId,
          'offeringPriceUsd': offerPriceUsd,
          'proposedApproach': proposedApproach,
          'notes': notes,
        },
      );

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == false) {
        return left(
          ServerFailure(apiResponse.message ?? 'Something went wrong'),
        );
      }

      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // ================= JOINT INVESTMENT =================
  @override
  Future<Either<Failure, void>> jointInvestment({
    required String landPostId,
    required double contractorSharePercent,
    required double landownerSharePercent,
    required double estimatedConstructionCostUsd,
    required int estimatedTimelineMonths,
    required String finishTier,
    required int proposedFloors,
    required String proposedApproach,
    required String notes,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kJointInvestment,
        body: {
          'landPostId': landPostId,
          'contractorSharePercent': contractorSharePercent,
          'landownerSharePercent': landownerSharePercent,
          'estimatedConstructionCostUsd': estimatedConstructionCostUsd,
          'estimatedTimelineMonths': estimatedTimelineMonths,
          'finishTier': finishTier,
          'proposedFloors': proposedFloors,
          'proposedApproach': proposedApproach,
          'notes': notes,
        },
      );

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == false) {
        return left(
          ServerFailure(apiResponse.message ?? 'Something went wrong'),
        );
      }

      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // ================= MUQASAMA =================
  @override
  Future<Either<Failure, void>> muqasama({
    required String landPostId,
    required double landownerSharePercent,
    required double estimatedConstructionCostUsd,
    required int estimatedTimelineMonths,
    required String finishTier,
    required int proposedFloors,
    required String proposedApproach,
    required String notes,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kMuqasama,
        body: {
          'landPostId': landPostId,
          'landownerSharePercent': landownerSharePercent,
          'estimatedConstructionCostUsd': estimatedConstructionCostUsd,
          'estimatedTimelineMonths': estimatedTimelineMonths,
          'finishTier': finishTier,
          'proposedFloors': proposedFloors,
          'proposedApproach': proposedApproach,
          'notes': notes,
        },
      );

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == false) {
        return left(
          ServerFailure(apiResponse.message ?? 'Something went wrong'),
        );
      }

      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // ================= SHARE OFFERING =================
  @override
  Future<Either<Failure, void>> shareOffering({
    required String landPostId,
    required double offerPriceUsd,
    required String notes,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kShareOffering,
        body: {
          'landPostId': landPostId,
          'offerPriceUsd': offerPriceUsd,
          'notes': notes,
        },
      );

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == false) {
        return left(
          ServerFailure(apiResponse.message ?? 'Something went wrong'),
        );
      }

      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // ================= GET BIDS =================
  @override
  Future<Either<Failure, List<BidItemModel>>> getBids({
    required String landPostId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await api.get(
        "${EndPoints.kBidLandPost}/$landPostId",
        queryParameters: {"page": page, "pageSize": pageSize},
      );

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == false) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load bids'),
        );
      }

      final List items = apiResponse.data["items"];

      final bids = items.map((e) => BidItemModel.fromJson(e)).toList();

      return right(bids);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // ================= ACCEPT BID =================
  @override
  Future<Either<Failure, void>> acceptBid({required String bidId}) async {
    try {
      final response = await api.post("${EndPoints.kBid}/$bidId/accept");

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == false) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to accept bid'),
        );
      }

      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // ================= REJECT BID =================
  @override
  Future<Either<Failure, void>> rejectBid({required String bidId}) async {
    try {
      final response = await api.post("${EndPoints.kBid}/$bidId/reject");

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == false) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to reject bid'),
        );
      }

      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // ================= BID DETAILS =================
  @override
  Future<Either<Failure, BidDetailsModel>> getBidDetails({
    required String bidId,
  }) async {
    try {
      final response = await api.get("${EndPoints.kBid}/$bidId");

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == false) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load bid details'),
        );
      }

      final model = BidDetailsModel.fromJson(apiResponse.data);

      return right(model);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // ================= BID SUMMARY =================
  @override
  Future<Either<Failure, BidSummaryModel>> getBidSummary(String postId) async {
    try {
      final response = await api.get(
        "${EndPoints.kBidLandPost}/$postId/summary",
      );

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success == false) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load summary'),
        );
      }

      final model = BidSummaryModel.fromJson(apiResponse.data);

      return right(model);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
