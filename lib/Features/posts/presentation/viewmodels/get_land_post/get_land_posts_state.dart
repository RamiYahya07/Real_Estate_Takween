part of 'get_land_posts_cubit.dart';

abstract class GetLandPostsState extends Equatable {
  const GetLandPostsState();

  @override
  List<Object?> get props => [];
}

/// initial
class GetLandPostsInitialState extends GetLandPostsState {}

/// first loading
class GetLandPostsLoadingState extends GetLandPostsState {}

/// success
class GetLandPostsSuccessState extends GetLandPostsState {
  final List<LandPostItemModel> posts;
  final bool hasNext;
  final bool isLoadingMore;

  const GetLandPostsSuccessState({
    required this.posts,
    required this.hasNext,
    required this.isLoadingMore,
  });

  @override
  List<Object?> get props => [posts, hasNext, isLoadingMore];
}

/// failure
class GetLandPostsFailure extends GetLandPostsState {
  final String errMessage;

  const GetLandPostsFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}