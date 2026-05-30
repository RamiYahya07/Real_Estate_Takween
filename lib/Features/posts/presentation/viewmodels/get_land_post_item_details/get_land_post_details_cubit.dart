import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/posts/data/repos/land_post_repo.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_land_post_item_details/get_land_post_details_state.dart';

class GetLandPostDetailsCubit extends Cubit<GetLandPostDetailsState> {
  final LandPostRepo repo;

  GetLandPostDetailsCubit(this.repo)
      : super(GetLandPostDetailsInitialState());

  Future<void> getDetails(String postId) async {
    emit(GetLandPostDetailsLoadingState());

    final result = await repo.getLandPostDetails(postId);

    result.fold(
      (failure) => emit(GetLandPostDetailsFailureState(failure.errMessage)),
      (data) => emit(GetLandPostDetailsSuccessState(data)),
    );
  }
}