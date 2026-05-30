
import 'package:equatable/equatable.dart';
import 'package:takween/Features/posts/data/models/land_post_item_model.dart';

sealed class GetOpenLandPostsState extends Equatable {
  const GetOpenLandPostsState();

  @override
  List<Object> get props => [];
}

final class GetOpenLandPostsInitialState
    extends GetOpenLandPostsState {}

final class GetOpenLandPostsLoadingState
    extends GetOpenLandPostsState {}

final class GetOpenLandPostsFailure
    extends GetOpenLandPostsState {
  final String errMessage;

  const GetOpenLandPostsFailure(this.errMessage);

  @override
  List<Object> get props => [errMessage];
}

final class GetOpenLandPostsSuccessState
    extends GetOpenLandPostsState {
  final List<LandPostItemModel> posts;
  final bool hasNext;
  final bool isLoadingMore;

  const GetOpenLandPostsSuccessState({
    required this.posts,
    required this.hasNext,
    required this.isLoadingMore,
  });

  @override
  List<Object> get props => [
        posts,
        hasNext,
        isLoadingMore,
      ];
}