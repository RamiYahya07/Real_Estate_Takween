import 'package:dartz/dartz.dart';
import 'package:takween/Features/contract/data/models/contract_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class ContractRepo {
  Future<Either<Failure, ContractModel?>> getContract(String projectId);
  Future<Either<Failure, void>> generateContract(String projectId);
  Future<Either<Failure, void>> signContract({
    required String projectId,
    required String passphrase,
  });
}
