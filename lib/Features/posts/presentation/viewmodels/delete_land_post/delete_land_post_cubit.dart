import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takween/Features/posts/data/repos/land_post_repo.dart';

part 'delete_land_post_state.dart';

class DeleteLandPostCubit extends Cubit<DeleteLandPostState> {
  final LandPostRepo repo;
  DeleteLandPostCubit(this.repo) : super(DeleteLandPostInitialState());

  Future<void> deleteLandPost(String postId) async {
    emit(DeleteLandPostLoadingState());

    final result = await repo.deleteLandPost(postId);

    result.fold(
      (failure) => emit(DeleteLandPostFailure(failure.errMessage)),
      (_) => emit(DeleteLandPostSuccessState()),
    );
  }
}
