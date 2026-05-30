import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takween/Features/authentication/data/repos/auth_repo.dart';
import 'package:takween/core/data/secure_storage_service.dart';

part 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final AuthRepo authRepo;
  final SecureStorageService storage;

  CreateAccountCubit({required this.authRepo, required this.storage}) : super(CreateAccountInitialState());

  Future<void> createAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    required String password,
    required String confirmPassword,
  }) async {
    emit(CreateAccountLoadingState());

    final result = await authRepo.createAccount(
      firstName: firstName,
      lastName: lastName,
      email: email,
      role:role,
      password: password,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(CreateAccountFailureState(failure.errMessage)),
      (authResponse) async {
        await storage.saveToken(authResponse.token);
        await storage.saveRefreshToken(authResponse.refreshToken);

        emit(CreateAccountSuccessState());
      },
    );
  }
}
