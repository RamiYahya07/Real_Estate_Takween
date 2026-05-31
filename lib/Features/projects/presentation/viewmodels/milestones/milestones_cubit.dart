import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/projects/data/models/milestone_model.dart';
import 'package:takween/Features/projects/data/repos/project_repo.dart';
import 'package:takween/Features/projects/presentation/viewmodels/milestones/milestones_state.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/utils/constants.dart';

class MilestonesCubit extends Cubit<MilestonesState> {
  final ProjectRepo repo;
  final SecureStorageService storage;

  MilestonesCubit(this.repo, this.storage) : super(MilestonesInitialState());

  String? _currentUserId;
  bool _isLandOwner = false;
  bool _isContractor = false;
  bool _identityLoaded = false;

  List<MilestoneModel> _milestones = [];
  bool _isAdding = false;
  String? _updatingId;

  Future<void> _loadIdentity() async {
    if (_identityLoaded) return;
    _currentUserId = await storage.getUserId();
    final role = roleFromString(await storage.getRole());
    _isLandOwner = role == Roles.LandOwner;
    _isContractor = role == Roles.Contractor;
    _identityLoaded = true;
  }

  Future<void> load(String projectId) async {
    emit(MilestonesLoadingState());
    await _loadIdentity();

    final result = await repo.getMilestones(projectId);
    result.fold((failure) => emit(MilestonesFailureState(failure.errMessage)), (
      milestones,
    ) {
      _milestones = milestones;
      _emitLoaded();
    });
  }

  Future<void> refresh(String projectId) async {
    final result = await repo.getMilestones(projectId);
    result.fold(
      (failure) => emit(MilestonesTransientError(failure.errMessage)),
      (milestones) {
        _milestones = milestones;
        _emitLoaded();
      },
    );
  }

  Future<void> addMilestone({
    required String projectId,
    required String title,
    String? description,
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      emit(MilestonesTransientError('Title is required'));
      _emitLoaded();
      return;
    }

    _isAdding = true;
    _emitLoaded();

    final result = await repo.addMilestone(
      projectId: projectId,
      title: trimmedTitle,
      description: description?.trim(),
    );
    result.fold(
      (failure) {
        _isAdding = false;
        emit(MilestonesTransientError(failure.errMessage));
        _emitLoaded();
      },
      (_) async {
        _isAdding = false;
        _emitLoaded();
        await refresh(projectId);
      },
    );
  }

Future<void> updateStatus({
  required String projectId,
  required String milestoneId,
  required String newStatus,
}) async {
  _updatingId = milestoneId;
  _emitLoaded();

  final result = await repo.updateMilestoneStatus(
    projectId: projectId,
    milestoneId: milestoneId,
    status: newStatus,
  );

  result.fold(
    (failure) {
      _updatingId = null;
      emit(MilestonesTransientError(failure.errMessage));
      _emitLoaded();
    },
    (_) async {
      _updatingId = null;
      _emitLoaded();

      // Reload milestones from server
      await refresh(projectId);
    },
  );
}
  void _emitLoaded() {
    emit(
      MilestonesLoadedState(
        milestones: List.unmodifiable(_milestones),
        isLandOwner: _isLandOwner,
        isContractor: _isContractor,
        currentUserId: _currentUserId,
        isAdding: _isAdding,
        updatingId: _updatingId,
      ),
    );
  }
}
