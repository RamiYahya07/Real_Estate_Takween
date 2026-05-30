import 'package:dartz/dartz.dart';
import 'package:takween/Features/investments/data/models/investment_opportunity_model.dart';
import 'package:takween/Features/investments/data/models/investor_request_model.dart';
import 'package:takween/Features/investments/data/models/my_investment_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class InvestmentsRepo {
  Future<Either<Failure, List<InvestmentOpportunityModel>>> getOpenInvestments({
    int page = 1,
    int pageSize = 12,
  });

  Future<Either<Failure, List<MyInvestmentModel>>> getMyInvestments({
    int page = 1,
    int pageSize = 20,
    String? status,
  });

  Future<Either<Failure, String>> submit({
    required String projectId,
    required double investmentAmountUsd,
    String? notes,
  });

  Future<Either<Failure, List<InvestorRequestModel>>> getProjectRequests(
    String projectId,
  );

  Future<Either<Failure, String>> review({
    required String projectId,
    required String requestId,
    required bool approve,
  });
}
