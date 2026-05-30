import 'package:equatable/equatable.dart';
import 'package:takween/Features/feasibility/data/models/cashflow_feasibility_model.dart';
import 'package:takween/Features/feasibility/data/models/detailed_feasibility_model.dart';

abstract class ProjectFeasibilityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectFeasibilityInitialState extends ProjectFeasibilityState {
  final bool isAllowed;
  ProjectFeasibilityInitialState({required this.isAllowed});

  @override
  List<Object?> get props => [isAllowed];
}

class ProjectFeasibilityLoadedState extends ProjectFeasibilityState {
  final bool isAllowed;
  final bool isRunningDetailed;
  final bool isRunningCashflow;
  final DetailedFeasibilityModel? detailed;
  final CashflowFeasibilityModel? cashflow;

  ProjectFeasibilityLoadedState({
    required this.isAllowed,
    this.isRunningDetailed = false,
    this.isRunningCashflow = false,
    this.detailed,
    this.cashflow,
  });

  ProjectFeasibilityLoadedState copyWith({
    bool? isAllowed,
    bool? isRunningDetailed,
    bool? isRunningCashflow,
    Object? detailed = _sentinel,
    Object? cashflow = _sentinel,
  }) {
    return ProjectFeasibilityLoadedState(
      isAllowed: isAllowed ?? this.isAllowed,
      isRunningDetailed: isRunningDetailed ?? this.isRunningDetailed,
      isRunningCashflow: isRunningCashflow ?? this.isRunningCashflow,
      detailed: identical(detailed, _sentinel)
          ? this.detailed
          : detailed as DetailedFeasibilityModel?,
      cashflow: identical(cashflow, _sentinel)
          ? this.cashflow
          : cashflow as CashflowFeasibilityModel?,
    );
  }

  @override
  List<Object?> get props => [
        isAllowed,
        isRunningDetailed,
        isRunningCashflow,
        detailed,
        cashflow,
      ];
}

class ProjectFeasibilityTransientError extends ProjectFeasibilityState {
  final String message;
  ProjectFeasibilityTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

const _sentinel = Object();
