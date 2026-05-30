part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState extends Equatable {
  const SignInState();
  @override
  List<Object?> get props => [];
}

final class SignInInitialState extends SignInState {}

final class SignInLoadingState extends SignInState {}

final class SignInSuccessState extends SignInState {
  final String role;
  SignInSuccessState(this.role );
}


final class SignInFailureState extends SignInState {
  final String errorMessage;
  const SignInFailureState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
