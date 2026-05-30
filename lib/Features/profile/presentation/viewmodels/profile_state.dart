import 'package:equatable/equatable.dart';
import 'package:takween/Features/profile/data/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial
class ProfileInitialState extends ProfileState {}

/// ---------------- GET PROFILE ----------------
class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfileModel profile;

  const ProfileSuccessState(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileFailureState extends ProfileState {
  final String message;

  const ProfileFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- EDIT PROFILE ----------------
class ProfileUpdating extends ProfileState {}

class ProfileUpdatedState extends ProfileState {

  const ProfileUpdatedState();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateFailureState extends ProfileState {
  final String message;

  const ProfileUpdateFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- UPLOAD IMAGE ----------------
class UploadImageLoadingState extends ProfileState {}

class UploadImageSuccessState extends ProfileState {}

class UploadImageFailureState extends ProfileState {
  final String message;

  const UploadImageFailureState(this.message);

  @override
  List<Object?> get props => [message];
}