import 'package:dartz/dartz.dart';
import 'package:takween/Features/feasibility/data/models/cashflow_feasibility_model.dart';
import 'package:takween/Features/feasibility/data/models/detailed_feasibility_model.dart';
import 'package:takween/Features/feasibility/data/models/preliminary_feasibility_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class FeasibilityRepo {
  Future<Either<Failure, PreliminaryFeasibilityModel>> preliminary({
    required String landPostId,
    required double marketPricePerSqmUsd,
  });

  Future<Either<Failure, DetailedFeasibilityModel>> detailed({
    required String projectId,
    required double marketPricePerSqmUsd,
    required double sellingExpensePercent,
    required double discountRatePercent,
    double? monthlyRentPerSqmUsd,
    required double annualMaintenancePercent,
    required double vacancyRatePercent,
  });

  Future<Either<Failure, CashflowFeasibilityModel>> cashflow({
 required String projectId,
  required double marketPricePerSqmUsd,
  required double preSalePercent,
  required double constructionPaymentFrontLoadPercent,}
   );
}
