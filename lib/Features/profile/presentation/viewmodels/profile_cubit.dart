import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/profile/data/repos/profile_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit( this.profileRepo) : super(ProfileInitialState());

  /// ---------------- GET PROFILE ----------------
  Future<void> getProfile() async {
    emit(ProfileLoadingState());

    final result = await profileRepo.getProfile();

    result.fold(
      (failure) => emit(ProfileFailureState(failure.errMessage)),
      (profile) => emit(ProfileSuccessState(profile)),
    );
  }

  /// ---------------- EDIT PROFILE ----------------
  Future<void> editProfile({
    required String fullName,
    required String bio,
    required String city,
    required String phoneNumber,
    required String nationalId,
  }) async {
    emit(ProfileUpdating());

    final result = await profileRepo.editProfile(
      fullName: fullName,
      bio: bio,
      city: city,
      phoneNumber: phoneNumber,
      nationalId: nationalId,
    );

    result.fold(
      (failure) => emit(ProfileUpdateFailureState(failure.errMessage)),
      (_) => emit(ProfileUpdatedState()),
    );
  }

  /// ---------------- UPLOAD IMAGE ----------------
  Future<void> uploadProfileImage(File file) async {
    emit(UploadImageLoadingState());

    final result = await profileRepo.uploadProfilePicture(
      imageFile: file,
    );

    result.fold(
      (failure) => emit(UploadImageFailureState(failure.errMessage)),
      (_) => emit(UploadImageSuccessState()),
    );
  }
}