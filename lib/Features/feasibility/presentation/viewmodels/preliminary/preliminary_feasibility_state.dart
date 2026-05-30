import 'package:equatable/equatable.dart';
import 'package:takween/Features/feasibility/data/models/preliminary_feasibility_model.dart';

abstract class PreliminaryFeasibilityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PreliminaryFeasibilityInitialState extends PreliminaryFeasibilityState {
  final bool isAllowed;
  PreliminaryFeasibilityInitialState({required this.isAllowed});

  @override
  List<Object?> get props => [isAllowed];
}

class PreliminaryFeasibilityLoadingState extends PreliminaryFeasibilityState {}

class PreliminaryFeasibilitySuccessState extends PreliminaryFeasibilityState {
  final PreliminaryFeasibilityModel result;
  final bool isAllowed;
  PreliminaryFeasibilitySuccessState({
    required this.result,
    required this.isAllowed,
  });

  @override
  List<Object?> get props => [result, isAllowed];
}

class PreliminaryFeasibilityFailureState extends PreliminaryFeasibilityState {
  final String message;
  final bool isAllowed;
  PreliminaryFeasibilityFailureState({
    required this.message,
    required this.isAllowed,
  });

  @override
  List<Object?> get props => [message, isAllowed];
}
