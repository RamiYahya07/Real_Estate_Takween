import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/feasibility/data/models/cashflow_feasibility_model.dart';
import 'package:takween/Features/feasibility/data/models/detailed_feasibility_model.dart';
import 'package:takween/Features/feasibility/data/models/preliminary_feasibility_model.dart';
import 'package:takween/Features/feasibility/data/repos/feasibility_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class FeasibilityRepoImpl implements FeasibilityRepo {
  final ApiConsumer api;

  FeasibilityRepoImpl(this.api);

  @override
  Future<Either<Failure, PreliminaryFeasibilityModel>> preliminary({
    required String landPostId,
    required double marketPricePerSqmUsd,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kPreliminaryFeasibility(landPostId),
        body: {'marketPricePerSqmUsd': marketPricePerSqmUsd},
      );
      final apiResponse = ApiResponse<PreliminaryFeasibilityModel>.fromJson(
        response,
        (data) =>
            PreliminaryFeasibilityModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(
            apiResponse.message ?? 'Feasibility calculation failed',
          ),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, DetailedFeasibilityModel>> detailed({
    required String projectId,
    required double marketPricePerSqmUsd,
    required double sellingExpensePercent,
    required double discountRatePercent,
    double? monthlyRentPerSqmUsd,
    required double annualMaintenancePercent,
    required double vacancyRatePercent,
  }) async {
    try {
      final body = <String, dynamic>{
        'marketPricePerSqmUsd': marketPricePerSqmUsd,
        'sellingExpensePercent': sellingExpensePercent,
        'discountRatePercent': discountRatePercent,
        'annualMaintenancePercent': annualMaintenancePercent,
        'vacancyRatePercent': vacancyRatePercent,
      };
      if (monthlyRentPerSqmUsd != null && monthlyRentPerSqmUsd > 0) {
        body['monthlyRentPerSqmUsd'] = monthlyRentPerSqmUsd;
      }
      final response = await api.post(
        EndPoints.kDetailedFeasibility(projectId),
        body: body,
      );
      final apiResponse = ApiResponse<DetailedFeasibilityModel>.fromJson(
        response,
        (data) =>
            DetailedFeasibilityModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Detailed feasibility failed'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
Future<Either<Failure, CashflowFeasibilityModel>> cashflow({
  required String projectId,
  required double marketPricePerSqmUsd,
  required double preSalePercent,
  required double constructionPaymentFrontLoadPercent,
}) async {
  try {
    final response = await api.post(
      EndPoints.kCashflowFeasibility(projectId),
      body: {
        'marketPricePerSqmUsd': marketPricePerSqmUsd,
        'preSalePercent': preSalePercent,
        'constructionPaymentFrontLoadPercent':
            constructionPaymentFrontLoadPercent,
      },
    );
      final apiResponse = ApiResponse<CashflowFeasibilityModel>.fromJson(
        response,
        (data) =>
            CashflowFeasibilityModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Cashflow feasibility failed'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
