import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/statistics/data/models/buyer_stats_model.dart';
import 'package:takween/Features/statistics/data/models/contractor_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/landOwner_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/listing_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/project_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/shares_statistics_model.dart';
import 'package:takween/Features/statistics/data/repos/statistics_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class StatisticsRepoImpl implements StatisticsRepo {
  final ApiConsumer api;
  StatisticsRepoImpl(this.api);
  @override
  Future<Either<Failure, ContractorDashboardModel>>
  getContractorDashboardData() async {
    try {
      final response = await api.get(EndPoints.kContractorDashboard);
      final contractorDashboardResponse =
          ApiResponse<ContractorDashboardModel>.fromJson(
            response,
            (data) => ContractorDashboardModel.fromJson(data),
          );
      return right(contractorDashboardResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, LandownerDashboardModel>>
  getLandOwnerDashboardData() async {
    try {
      final response = await api.get(EndPoints.kLandOwnerDashboard);
      final landOwnerDashboardResponse =
          ApiResponse<LandownerDashboardModel>.fromJson(
            response,
            (data) => LandownerDashboardModel.fromJson(data),
          );
      return right(landOwnerDashboardResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, ListingStatisticsModel>>
  getListingStatisticsData() async {
    try {
            final response = await api.get(EndPoints.kStatsListing);
      final listingStatisticsResponse =
          ApiResponse<ListingStatisticsModel>.fromJson(
            response,
            (data) => ListingStatisticsModel.fromJson(data),
          );
      return right(listingStatisticsResponse.data!);

    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, ProjectStatisticsModel>> getProjectStatisticsData()async {
   try {
            final response = await api.get(EndPoints.kStatsProjects);
      final projectStatisticsResponse =
          ApiResponse<ProjectStatisticsModel>.fromJson(
            response,
            (data) => ProjectStatisticsModel.fromJson(data),
          );
      return right(projectStatisticsResponse.data!);

    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, SharesStatisticsModel>> getSharesStatisticsData()async {
   try {
            final response = await api.get(EndPoints.kStatsShares);
      final sharesStatisticsResponse =
          ApiResponse<SharesStatisticsModel>.fromJson(
            response,
            (data) => SharesStatisticsModel.fromJson(data),
          );
      return right(sharesStatisticsResponse.data!);

    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, BuyerStatsModel>> getBuyerStatsData() async {
    try {
      final response = await api.get(EndPoints.kStatsBuyer);
      final buyerStatsResponse = ApiResponse<BuyerStatsModel>.fromJson(
        response,
        (data) => BuyerStatsModel.fromJson(data),
      );
      return right(buyerStatsResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
