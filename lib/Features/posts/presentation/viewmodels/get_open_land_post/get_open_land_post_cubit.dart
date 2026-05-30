import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/posts/data/models/land_post_item_model.dart';
import 'package:takween/Features/posts/data/repos/land_post_repo.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_open_land_post/get_open_land_post_state.dart';


class GetOpenLandPostsCubit
    extends Cubit<GetOpenLandPostsState> {
  final LandPostRepo repo;

  GetOpenLandPostsCubit(this.repo)
      : super(GetOpenLandPostsInitialState());

  List<LandPostItemModel> posts = [];

  int page = 1;
  final int pageSize = 10;

  bool hasNext = true;
  bool isLoadingMore = false;

  /// -------- INITIAL LOAD --------
  Future<void> getOpenLandPosts() async {
    emit(GetOpenLandPostsLoadingState());

    page = 1;
    hasNext = true;
    posts.clear();

    final result = await repo.getOpenLandPosts(
      page: page,
      pageSize: pageSize,
    );

    result.fold(
      (failure) {
        emit(GetOpenLandPostsFailure(failure.errMessage));
      },
      (data) {
        posts = data;

        hasNext = data.length == pageSize;

        emit(
          GetOpenLandPostsSuccessState(
            posts: posts,
            hasNext: hasNext,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// -------- LOAD MORE --------
  Future<void> loadMore() async {
    if (isLoadingMore || !hasNext) return;

    isLoadingMore = true;

    emit(
      GetOpenLandPostsSuccessState(
        posts: posts,
        hasNext: hasNext,
        isLoadingMore: true,
      ),
    );

    page++;

    final result = await repo.getOpenLandPosts(
      page: page,
      pageSize: pageSize,
    );

    result.fold(
      (failure) {
        isLoadingMore = false;

        emit(
          GetOpenLandPostsFailure(
            failure.errMessage,
          ),
        );
      },
      (data) {
        isLoadingMore = false;

        posts.addAll(data);

        hasNext = data.length == pageSize;

        emit(
          GetOpenLandPostsSuccessState(
            posts: posts,
            hasNext: hasNext,
            isLoadingMore: false,
          ),
        );
      },
    );
  }
}