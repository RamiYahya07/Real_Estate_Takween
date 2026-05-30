import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/feasibility/data/models/cashflow_feasibility_model.dart';
import 'package:takween/Features/feasibility/data/models/detailed_feasibility_model.dart';
import 'package:takween/Features/feasibility/data/repos/feasibility_repo.dart';
import 'package:takween/Features/feasibility/presentation/viewmodels/project_feasibility/project_feasibility_state.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/utils/constants.dart';

class ProjectFeasibilityCubit extends Cubit<ProjectFeasibilityState> {
  final FeasibilityRepo repo;
  final SecureStorageService storage;

  ProjectFeasibilityCubit(this.repo, this.storage)
      : super(ProjectFeasibilityInitialState(isAllowed: false));

  bool _isAllowed = false;
  bool _identityLoaded = false;
  bool _isRunningDetailed = false;
  bool _isRunningCashflow = false;
  DetailedFeasibilityModel? _detailed;
  CashflowFeasibilityModel? _cashflow;

  Future<void> _loadIdentity() async {
    if (_identityLoaded) return;
    final role = roleFromString(await storage.getRole());
    _isAllowed = role == Roles.LandOwner || role == Roles.Contractor;
    _identityLoaded = true;
  }

  Future<void> init() async {
    await _loadIdentity();
    _emitLoaded();
  }

  Future<void> runDetailed({
    required String projectId,
    required double marketPricePerSqmUsd,
    required double sellingExpensePercent,
    required double discountRatePercent,
    double? monthlyRentPerSqmUsd,
    required double annualMaintenancePercent,
    required double vacancyRatePercent,
  }) async {
    _isRunningDetailed = true;
    _emitLoaded();

    final result = await repo.detailed(
      projectId: projectId,
      marketPricePerSqmUsd: marketPricePerSqmUsd,
      sellingExpensePercent: sellingExpensePercent,
      discountRatePercent: discountRatePercent,
      monthlyRentPerSqmUsd: monthlyRentPerSqmUsd,
      annualMaintenancePercent: annualMaintenancePercent,
      vacancyRatePercent: vacancyRatePercent,
    );

    _isRunningDetailed = false;
    result.fold(
      (failure) {
        emit(ProjectFeasibilityTransientError(failure.errMessage));
        _emitLoaded();
      },
      (data) {
        _detailed = data;
        _emitLoaded();
      },
    );
  }

Future<void> runCashflow({
  required String projectId,
  required double marketPricePerSqmUsd,
  required double preSalePercent,
  required double constructionPaymentFrontLoadPercent,
}) async {
  _isRunningCashflow = true;
  _emitLoaded();

  final result = await repo.cashflow(
    projectId: projectId,
    marketPricePerSqmUsd: marketPricePerSqmUsd,
    preSalePercent: preSalePercent,
    constructionPaymentFrontLoadPercent:
        constructionPaymentFrontLoadPercent,
  );

  _isRunningCashflow = false;

  result.fold(
    (failure) {
      emit(ProjectFeasibilityTransientError(failure.errMessage));
      _emitLoaded();
    },
    (data) {
      _cashflow = data;
      _emitLoaded();
    },
  );
}
  void _emitLoaded() {
    emit(
      ProjectFeasibilityLoadedState(
        isAllowed: _isAllowed,
        isRunningDetailed: _isRunningDetailed,
        isRunningCashflow: _isRunningCashflow,
        detailed: _detailed,
        cashflow: _cashflow,
      ),
    );
  }
}
