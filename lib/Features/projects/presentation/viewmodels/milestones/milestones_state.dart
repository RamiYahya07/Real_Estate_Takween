import 'package:equatable/equatable.dart';
import 'package:takween/Features/projects/data/models/milestone_model.dart';

abstract class MilestonesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MilestonesInitialState extends MilestonesState {}

class MilestonesLoadingState extends MilestonesState {}

class MilestonesLoadedState extends MilestonesState {
  final List<MilestoneModel> milestones;
  final bool isLandOwner;
  final bool isContractor;
  final String? currentUserId;
  final bool isAdding;
  final String? updatingId;

  MilestonesLoadedState({
    required this.milestones,
    required this.isLandOwner,
    required this.isContractor,
    required this.currentUserId,
    this.isAdding = false,
    this.updatingId,
  });

  MilestonesLoadedState copyWith({
    List<MilestoneModel>? milestones,
    bool? isLandOwner,
    bool? isContractor,
    String? currentUserId,
    bool? isAdding,
    Object? updatingId = _sentinel,
  }) {
    return MilestonesLoadedState(
      milestones: milestones ?? this.milestones,
      isLandOwner: isLandOwner ?? this.isLandOwner,
      isContractor: isContractor ?? this.isContractor,
      currentUserId: currentUserId ?? this.currentUserId,
      isAdding: isAdding ?? this.isAdding,
      updatingId: identical(updatingId, _sentinel)
          ? this.updatingId
          : updatingId as String?,
    );
  }

  @override
  List<Object?> get props => [
        milestones,
        isLandOwner,
        isContractor,
        currentUserId,
        isAdding,
        updatingId,
      ];
}

class MilestonesFailureState extends MilestonesState {
  final String message;
  MilestonesFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class MilestonesTransientError extends MilestonesState {
  final String message;
  MilestonesTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

const _sentinel = Object();
