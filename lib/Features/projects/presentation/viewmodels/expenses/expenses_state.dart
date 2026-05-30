import 'package:equatable/equatable.dart';
import 'package:takween/Features/projects/data/models/expense_model.dart';

abstract class ExpensesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExpensesInitialState extends ExpensesState {}

class ExpensesLoadingState extends ExpensesState {}

class ExpensesLoadedState extends ExpensesState {
  final List<ExpenseModel> expenses;
  final bool isLandOwner;
  final bool isContractor;
  final String? currentUserId;
  final bool isAdding;

  ExpensesLoadedState({
    required this.expenses,
    required this.isLandOwner,
    required this.isContractor,
    required this.currentUserId,
    this.isAdding = false,
  });

  ExpensesLoadedState copyWith({
    List<ExpenseModel>? expenses,
    bool? isLandOwner,
    bool? isContractor,
    String? currentUserId,
    bool? isAdding,
  }) {
    return ExpensesLoadedState(
      expenses: expenses ?? this.expenses,
      isLandOwner: isLandOwner ?? this.isLandOwner,
      isContractor: isContractor ?? this.isContractor,
      currentUserId: currentUserId ?? this.currentUserId,
      isAdding: isAdding ?? this.isAdding,
    );
  }

  double get totalUsd =>
      expenses.fold<double>(0, (sum, e) => sum + e.amountUsd);

  @override
  List<Object?> get props => [
        expenses,
        isLandOwner,
        isContractor,
        currentUserId,
        isAdding,
      ];
}

class ExpensesFailureState extends ExpensesState {
  final String message;
  ExpensesFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class ExpensesTransientError extends ExpensesState {
  final String message;
  ExpensesTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}
