import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/investments/data/models/investment_opportunity_model.dart';
import 'package:takween/Features/investments/data/models/investor_request_model.dart';
import 'package:takween/Features/investments/data/models/my_investment_model.dart';
import 'package:takween/Features/investments/data/repos/investments_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class InvestmentsRepoImpl implements InvestmentsRepo {
  final ApiConsumer api;
  InvestmentsRepoImpl(this.api);

  @override
  Future<Either<Failure, List<InvestmentOpportunityModel>>> getOpenInvestments({
    int page = 1,
    int pageSize = 12,
  }) async {
    try {
      final response = await api.get(
        EndPoints.kOpenInvestments,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load opportunities'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final list = items
          .map((e) => InvestmentOpportunityModel.fromJson(e))
          .toList();
      return right(list);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<MyInvestmentModel>>> getMyInvestments({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    try {
      final response = await api.get(
        EndPoints.kMyInvestments,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load investments'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final list = items.map((e) => MyInvestmentModel.fromJson(e)).toList();
      return right(list);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, String>> submit({
    required String projectId,
    required double investmentAmountUsd,
    String? notes,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kProjectInvestorRequests(projectId),
        body: {
          'investmentAmountUsd': investmentAmountUsd,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to submit request'),
        );
      }
      return right(apiResponse.message ?? 'Investment request submitted');
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<InvestorRequestModel>>> getProjectRequests(
    String projectId,
  ) async {
    try {
      final response = await api.get(
        EndPoints.kProjectInvestorRequests(projectId),
      );
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load requests'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final list = items.map((e) => InvestorRequestModel.fromJson(e)).toList();
      return right(list);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, String>> review({
    required String projectId,
    required String requestId,
    required bool approve,
  }) async {
    try {
      final response = await api.put(
        EndPoints.kProjectInvestorRequestById(projectId, requestId),
        body: {'approve': approve},
      );
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to review request'),
        );
      }
      return right(
        apiResponse.message ?? (approve ? 'Request approved' : 'Request rejected'),
      );
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
