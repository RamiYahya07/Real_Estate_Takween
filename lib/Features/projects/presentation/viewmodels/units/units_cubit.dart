import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/projects/data/models/allocation_result_model.dart';
import 'package:takween/Features/projects/data/models/unit_model.dart';
import 'package:takween/Features/projects/data/repos/project_repo.dart';
import 'package:takween/Features/projects/presentation/viewmodels/units/units_state.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/utils/constants.dart';

class UnitsCubit extends Cubit<UnitsState> {
  final ProjectRepo repo;
  final SecureStorageService storage;

  UnitsCubit(this.repo, this.storage) : super(UnitsInitialState());

  String? _currentUserId;
  bool _isLandOwner = false;
  bool _isContractor = false;
  bool _identityLoaded = false;

  List<UnitModel> _units = [];
  bool _isCreating = false;
  bool _isAllocating = false;
  AllocationResultModel? _lastAllocation;

  Future<void> _loadIdentity() async {
    if (_identityLoaded) return;
    _currentUserId = await storage.getUserId();
    final role = roleFromString(await storage.getRole());
    _isLandOwner = role == Roles.LandOwner;
    _isContractor = role == Roles.Contractor;
    _identityLoaded = true;
  }

  Future<void> load(String projectId) async {
    emit(UnitsLoadingState());
    await _loadIdentity();

    final result = await repo.getUnits(projectId);
    result.fold(
      (failure) => emit(UnitsFailureState(failure.errMessage)),
      (units) {
        _units = units;
        _emitLoaded();
      },
    );
  }

  Future<void> refresh(String projectId) async {
    final result = await repo.getUnits(projectId);
    result.fold(
      (failure) => emit(UnitsTransientError(failure.errMessage)),
      (units) {
        _units = units;
        _emitLoaded();
      },
    );
  }

  Future<void> createUnits({
    required String projectId,
    required List<Map<String, dynamic>> units,
  }) async {
    if (units.isEmpty) {
      emit(UnitsTransientError('Add at least one unit'));
      _emitLoaded();
      return;
    }

    _isCreating = true;
    _emitLoaded();

    final result =
        await repo.createUnits(projectId: projectId, units: units);
    final failureMsg =
        result.fold<String?>((f) => f.errMessage, (_) => null);

    _isCreating = false;
    if (failureMsg != null) {
      emit(UnitsTransientError(failureMsg));
      _emitLoaded();
      return;
    }

    await refresh(projectId);
  }

  Future<void> allocate(String projectId) async {
    _isAllocating = true;
    _emitLoaded();

    final result = await repo.allocateUnits(projectId);

    _isAllocating = false;
    result.fold(
      (failure) {
        emit(UnitsTransientError(failure.errMessage));
        _emitLoaded();
      },
      (allocation) {
        _lastAllocation = allocation;
        emit(UnitsAllocationSuccess(allocation));
        _emitLoaded();
        refresh(projectId);
      },
    );
  }

  void _emitLoaded() {
    emit(
      UnitsLoadedState(
        units: List.unmodifiable(_units),
        isLandOwner: _isLandOwner,
        isContractor: _isContractor,
        currentUserId: _currentUserId,
        isCreating: _isCreating,
        isAllocating: _isAllocating,
        lastAllocation: _lastAllocation,
      ),
    );
  }
}
