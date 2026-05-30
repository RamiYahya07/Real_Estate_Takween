import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/feasibility/data/repos/feasibility_repo.dart';
import 'package:takween/Features/feasibility/presentation/viewmodels/preliminary/preliminary_feasibility_state.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/utils/constants.dart';

class PreliminaryFeasibilityCubit extends Cubit<PreliminaryFeasibilityState> {
  final FeasibilityRepo repo;
  final SecureStorageService storage;

  PreliminaryFeasibilityCubit(this.repo, this.storage)
      : super(PreliminaryFeasibilityInitialState(isAllowed: false));

  bool _isAllowed = false;
  bool _identityLoaded = false;

  Future<void> loadIdentity() async {
    if (_identityLoaded) return;
    final role = roleFromString(await storage.getRole());
    _isAllowed = role == Roles.LandOwner || role == Roles.Contractor;
    _identityLoaded = true;
    emit(PreliminaryFeasibilityInitialState(isAllowed: _isAllowed));
  }

  Future<void> run({
    required String landPostId,
    required double marketPricePerSqmUsd,
  }) async {
    if (marketPricePerSqmUsd <= 0) {
      emit(
        PreliminaryFeasibilityFailureState(
          message: 'Market price per sqm must be greater than 0',
          isAllowed: _isAllowed,
        ),
      );
      return;
    }
    emit(PreliminaryFeasibilityLoadingState());
    final result = await repo.preliminary(
      landPostId: landPostId,
      marketPricePerSqmUsd: marketPricePerSqmUsd,
    );
    result.fold(
      (failure) => emit(
        PreliminaryFeasibilityFailureState(
          message: failure.errMessage,
          isAllowed: _isAllowed,
        ),
      ),
      (data) => emit(
        PreliminaryFeasibilitySuccessState(
          result: data,
          isAllowed: _isAllowed,
        ),
      ),
    );
  }

  void reset() {
    emit(PreliminaryFeasibilityInitialState(isAllowed: _isAllowed));
  }
}
