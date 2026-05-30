import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/contract/data/repos/contract_repo.dart';
import 'package:takween/Features/contract/presentation/viewmodels/contract/contract_state.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/utils/constants.dart';

class ContractCubit extends Cubit<ContractState> {
  final ContractRepo repo;
  final SecureStorageService storage;

  ContractCubit(this.repo, this.storage) : super(ContractInitialState());

  String? _currentUserId;
  bool _isLandOwner = false;

  Future<void> _loadIdentity() async {
    if (_currentUserId != null) return;
    _currentUserId = await storage.getUserId();
    final role = await storage.getRole();
    _isLandOwner = roleFromString(role) == Roles.LandOwner;
  }

  Future<void> load(String projectId) async {
    emit(ContractLoadingState());
    await _loadIdentity();

    final result = await repo.getContract(projectId);
    result.fold(
      (failure) => emit(ContractFailureState(failure.errMessage)),
      (contract) {
        if (contract == null) {
          emit(ContractNotGeneratedState(isLandOwner: _isLandOwner));
        } else {
          emit(ContractLoadedState(
            contract: contract,
            isLandOwner: _isLandOwner,
            currentUserId: _currentUserId,
          ));
        }
      },
    );
  }

  Future<void> refresh(String projectId) async {
    final current = state;
    if (current is ContractLoadedState) {
      final result = await repo.getContract(projectId);
      result.fold(
        (failure) => emit(ContractTransientError(failure.errMessage)),
        (contract) {
          if (contract == null) {
            emit(ContractNotGeneratedState(isLandOwner: _isLandOwner));
          } else {
            emit(current.copyWith(contract: contract));
          }
        },
      );
    } else {
      await load(projectId);
    }
  }

  Future<void> generate(String projectId) async {
    final current = state;
    if (current is ContractNotGeneratedState) {
      emit(current.copyWith(isGenerating: true));
    }

    final result = await repo.generateContract(projectId);
    final failureMsg =
        result.fold<String?>((f) => f.errMessage, (_) => null);

    if (failureMsg != null) {
      emit(ContractTransientError(failureMsg));
      if (current is ContractNotGeneratedState) {
        emit(current.copyWith(isGenerating: false));
      }
      return;
    }

    await load(projectId);
  }

  Future<void> sign({
    required String projectId,
    required String passphrase,
  }) async {
    final current = state;
    if (current is! ContractLoadedState) return;
    if (passphrase.trim().isEmpty) {
      emit(ContractTransientError('Passphrase is required'));
      emit(current);
      return;
    }

    emit(current.copyWith(isSigning: true));

    final result = await repo.signContract(
      projectId: projectId,
      passphrase: passphrase,
    );

    result.fold(
      (failure) {
        emit(ContractTransientError(failure.errMessage));
        emit(current.copyWith(isSigning: false));
      },
      (_) {
      emit(current.copyWith(isSigning: false));
  emit(ContractSignSuccessState());
      },
    );
  }
}
