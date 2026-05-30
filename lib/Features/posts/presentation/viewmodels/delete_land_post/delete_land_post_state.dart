part of 'delete_land_post_cubit.dart';

abstract class DeleteLandPostState extends Equatable {
  const DeleteLandPostState();

  @override
  List<Object?> get props => [];
}

/// initial
class DeleteLandPostInitialState extends DeleteLandPostState {}

/// loading
class DeleteLandPostLoadingState extends DeleteLandPostState {}

/// success
class DeleteLandPostSuccessState extends DeleteLandPostState {}

/// failure
class DeleteLandPostFailure extends DeleteLandPostState {
  final String errMessage;

  const DeleteLandPostFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
