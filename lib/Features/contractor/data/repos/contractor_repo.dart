import 'package:dartz/dartz.dart';
import 'package:takween/Features/contractor/data/models/cost_rates_model.dart';
import 'package:takween/Features/contractor/data/models/cost_settings_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class ContractorRepo {
  Future<Either<Failure, CostSettingsModel>> getCostSettings();
  Future<Either<Failure, void>> updateCostSettings(CostRatesModel rates);
}
