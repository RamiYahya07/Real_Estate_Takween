import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/projects/data/models/expense_model.dart';
import 'package:takween/Features/projects/data/repos/project_repo.dart';
import 'package:takween/Features/projects/presentation/viewmodels/expenses/expenses_state.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/utils/constants.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final ProjectRepo repo;
  final SecureStorageService storage;

  ExpensesCubit(this.repo, this.storage) : super(ExpensesInitialState());

  String? _currentUserId;
  bool _isLandOwner = false;
  bool _isContractor = false;
  bool _identityLoaded = false;

  List<ExpenseModel> _expenses = [];
  bool _isAdding = false;

  Future<void> _loadIdentity() async {
    if (_identityLoaded || isClosed) return;

    _currentUserId = await storage.getUserId();
    if (isClosed) return;

    final role = roleFromString(await storage.getRole());
    if (isClosed) return;

    _isLandOwner = role == Roles.LandOwner;
    _isContractor = role == Roles.Contractor;

    _identityLoaded = true;
  }

  Future<void> load(String projectId) async {
    emit(ExpensesLoadingState());

    await _loadIdentity();
    if (isClosed) return;

    final result = await repo.getExpenses(projectId);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(ExpensesFailureState(failure.errMessage));
      },
      (expenses) {
        if (isClosed) return;
        _expenses = expenses;
        _emitLoaded();
      },
    );
  }

  Future<void> refresh(String projectId) async {
    final result = await repo.getExpenses(projectId);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(ExpensesTransientError(failure.errMessage));
      },
      (expenses) {
        if (isClosed) return;
        _expenses = expenses;
        _emitLoaded();
      },
    );
  }

  Future<void> addExpense({
    required String projectId,
    required String category,
    required String description,
    required double amountUsd,
    required DateTime paidAt,
  }) async {
    if (amountUsd <= 0) {
      if (!isClosed) {
        emit(ExpensesTransientError('Amount must be greater than 0'));
        _emitLoaded();
      }
      return;
    }

    if (description.trim().isEmpty) {
      if (!isClosed) {
        emit(ExpensesTransientError('Description is required'));
        _emitLoaded();
      }
      return;
    }

    _isAdding = true;
    _emitLoaded();

    final result = await repo.addExpense(
      projectId: projectId,
      category: category,
      description: description.trim(),
      amountUsd: amountUsd,
      paidAt: paidAt,
    );

    _isAdding = false;

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(ExpensesTransientError(failure.errMessage));
        _emitLoaded();
      },
      (_) async {
        if (isClosed) return;
        _emitLoaded();
        await refresh(projectId);
      },
    );
  }

  void _emitLoaded() {
    if (isClosed) return;

    emit(
      ExpensesLoadedState(
        expenses: List.unmodifiable(_expenses),
        isLandOwner: _isLandOwner,
        isContractor: _isContractor,
        currentUserId: _currentUserId,
        isAdding: _isAdding,
      ),
    );
  }
}
