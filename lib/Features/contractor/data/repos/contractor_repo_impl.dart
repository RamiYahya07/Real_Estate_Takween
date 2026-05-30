import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/contractor/data/models/cost_rates_model.dart';
import 'package:takween/Features/contractor/data/models/cost_settings_model.dart';
import 'package:takween/Features/contractor/data/repos/contractor_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class ContractorRepoImpl implements ContractorRepo {
  final ApiConsumer api;

  ContractorRepoImpl(this.api);

  @override
  Future<Either<Failure, CostSettingsModel>> getCostSettings() async {
    try {
      final response = await api.get(EndPoints.kCostSettings);
      final apiResponse = ApiResponse<CostSettingsModel>.fromJson(
        response,
        (data) => CostSettingsModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load cost settings'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateCostSettings(CostRatesModel rates) async {
    try {
      final response = await api.put(
        EndPoints.kCostSettings,
        body: {'rates': rates.toJson()},
      );
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to update cost settings'),
        );
      }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
