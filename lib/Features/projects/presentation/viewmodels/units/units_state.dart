import 'package:equatable/equatable.dart';
import 'package:takween/Features/projects/data/models/allocation_result_model.dart';
import 'package:takween/Features/projects/data/models/unit_model.dart';

abstract class UnitsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnitsInitialState extends UnitsState {}

class UnitsLoadingState extends UnitsState {}

class UnitsLoadedState extends UnitsState {
  final List<UnitModel> units;
  final bool isLandOwner;
  final bool isContractor;
  final String? currentUserId;
  final bool isCreating;
  final bool isAllocating;
  final AllocationResultModel? lastAllocation;

  UnitsLoadedState({
    required this.units,
    required this.isLandOwner,
    required this.isContractor,
    required this.currentUserId,
    this.isCreating = false,
    this.isAllocating = false,
    this.lastAllocation,
  });

  UnitsLoadedState copyWith({
    List<UnitModel>? units,
    bool? isLandOwner,
    bool? isContractor,
    String? currentUserId,
    bool? isCreating,
    bool? isAllocating,
    Object? lastAllocation = _sentinel,
  }) {
    return UnitsLoadedState(
      units: units ?? this.units,
      isLandOwner: isLandOwner ?? this.isLandOwner,
      isContractor: isContractor ?? this.isContractor,
      currentUserId: currentUserId ?? this.currentUserId,
      isCreating: isCreating ?? this.isCreating,
      isAllocating: isAllocating ?? this.isAllocating,
      lastAllocation: identical(lastAllocation, _sentinel)
          ? this.lastAllocation
          : lastAllocation as AllocationResultModel?,
    );
  }

  @override
  List<Object?> get props => [
        units,
        isLandOwner,
        isContractor,
        currentUserId,
        isCreating,
        isAllocating,
        lastAllocation,
      ];
}

class UnitsFailureState extends UnitsState {
  final String message;
  UnitsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class UnitsTransientError extends UnitsState {
  final String message;
  UnitsTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class UnitsAllocationSuccess extends UnitsState {
  final AllocationResultModel result;
  UnitsAllocationSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

const _sentinel = Object();
