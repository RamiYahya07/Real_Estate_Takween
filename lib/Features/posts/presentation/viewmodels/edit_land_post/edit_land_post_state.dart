part of 'edit_land_post_cubit.dart';

abstract class EditLandPostState extends Equatable {
  const EditLandPostState();

  @override
  List<Object?> get props => [];
}

/// initial
class EditLandPostInitialState extends EditLandPostState {}

/// loading
class EditLandPostLoadingState extends EditLandPostState {}

/// success
class EditLandPostSuccessState extends EditLandPostState {}

/// failure
class EditLandPostFailure extends EditLandPostState {
  final String errMessage;

  const EditLandPostFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
