import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takween/Features/posts/data/models/land_post_item_model.dart';
import 'package:takween/Features/posts/data/repos/land_post_repo.dart';

part 'get_land_posts_state.dart';

class GetLandPostsCubit extends Cubit<GetLandPostsState> {
  final LandPostRepo repo;
  GetLandPostsCubit(this.repo) : super(GetLandPostsInitialState());
  List<LandPostItemModel> posts = [];

  int page = 1;
  final int pageSize = 10;
  bool hasNext = true;
  bool isLoadingMore = false;

  /// -------- INITIAL LOAD --------
  Future<void> getLandPosts() async {
    emit(GetLandPostsLoadingState());

    page = 1;
    hasNext = true;
    posts.clear();

    final result = await repo.getLandPosts(page: page, pageSize: pageSize);

    result.fold((failure) => emit(GetLandPostsFailure(failure.errMessage)), (
      data,
    ) {
      posts = data;
      hasNext = data.length == pageSize;

      emit(
        GetLandPostsSuccessState(
          posts: posts,
          hasNext: hasNext,
          isLoadingMore: false,
        ),
      );
    });
  }

  /// -------- LOAD MORE --------
  Future<void> loadMore() async {
    if (isLoadingMore || !hasNext) return;

    isLoadingMore = true;

    emit(
      GetLandPostsSuccessState(posts: posts, hasNext: hasNext, isLoadingMore: true),
    );

    page++;

    final result = await repo.getLandPosts(page: page, pageSize: pageSize);

    result.fold(
      (failure) {
        isLoadingMore = false;
        emit(GetLandPostsFailure(failure.errMessage));
      },
      (data) {
        isLoadingMore = false;

        posts.addAll(data);
        hasNext = data.length == pageSize;

        emit(
          GetLandPostsSuccessState(
            posts: posts,
            hasNext: hasNext,
            isLoadingMore: false,
          ),
        );
      },
    );
  }
}
