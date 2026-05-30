import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:takween/Features/authentication/data/repos/auth_repo.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/data/shared_prefs_service.dart';
import 'package:takween/core/utils/helper/jwt_helper.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepo authRepo;
  final SecureStorageService storage;
  final AppPreferences prefs;

  SignInCubit({
    required this.authRepo,
    required this.storage,
    required this.prefs,
  }) : super(SignInInitialState());


  Future<void> login({required String email, required String password}) async {
    emit(SignInLoadingState());

    final result = await authRepo.login(email: email, password: password);

    result.fold((failure) => emit(SignInFailureState(failure.errMessage)), (
      authResponse,
    ) async {
      final token = authResponse.token;
      await storage.saveToken(authResponse.token);
      await storage.saveRefreshToken(authResponse.refreshToken);

      /// Extract JWT data
      final userId = JwtHelper.getUserId(token);
      final role = JwtHelper.getRole(token);
      final username = JwtHelper.getUsername(token);

      /// Save in preferences
      await storage.saveUserId(userId??"");
      await storage.saveRole(role ?? "");
      await prefs.setUserName(username ?? "");
      await prefs.setSignedIn(true);

      emit(SignInSuccessState(role ?? ""));
    });
  }
}
