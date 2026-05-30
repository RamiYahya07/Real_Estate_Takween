import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/contract/data/models/contract_model.dart';
import 'package:takween/Features/contract/data/repos/contract_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class ContractRepoImpl implements ContractRepo {
  final ApiConsumer api;

  ContractRepoImpl(this.api);

  @override
  Future<Either<Failure, ContractModel?>> getContract(String projectId) async {
    try {
      final response = await api.get(EndPoints.kProjectContract(projectId));
      final apiResponse = ApiResponse<ContractModel?>.fromJson(
        response,
        (data) =>
            data == null ? null : ContractModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success) {
        if (apiResponse.statusCode == 404) {
          return const Right(null);
        }
        return left(ServerFailure(apiResponse.message ?? 'Failed to load contract'));
      }
      return right(apiResponse.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Right(null);
      }
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> generateContract(String projectId) async {
    try {
      final response = await api.post(EndPoints.kProjectContract(projectId));
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success) {
        return left(ServerFailure(apiResponse.message ?? 'Failed to generate contract'));
      }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> signContract({
    required String projectId,
    required String passphrase,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kProjectContractSign(projectId),
        body: {'signaturePassphrase': passphrase},
      );
      // final apiResponse = ApiResponse<ContractModel>.fromJson(
      //   response,
      //   (data) => ContractModel.fromJson(data as Map<String, dynamic>),
      // );
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success ) {
        return left(ServerFailure(apiResponse.message ?? 'Failed to sign contract'));
      }
      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
