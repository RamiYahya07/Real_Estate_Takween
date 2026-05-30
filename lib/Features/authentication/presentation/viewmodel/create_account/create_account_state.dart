part of 'create_account_cubit.dart';

sealed class CreateAccountState extends Equatable {
  const CreateAccountState();

  @override
  List<Object?> get props => [];
}

final class CreateAccountInitialState extends CreateAccountState {}

final class CreateAccountLoadingState extends CreateAccountState {}

final class CreateAccountSuccessState extends CreateAccountState {}

final class CreateAccountFailureState extends CreateAccountState {
  final String errorMessage;
  const CreateAccountFailureState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
