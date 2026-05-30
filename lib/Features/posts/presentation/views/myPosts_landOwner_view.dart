import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_land_post/get_land_posts_cubit.dart';
import 'package:takween/Features/posts/presentation/views/widgets/landOwenrPostCard.dart';
import 'package:takween/Features/posts/presentation/views/widgets/land_post_card.dart';
import 'package:takween/core/utils/constants.dart';
import 'package:takween/core/utils/helper/refresh.dart';
import 'package:takween/core/widgets/show_loading.dart';

class MypostsLandownerView extends StatefulWidget {
  const MypostsLandownerView({super.key});

  @override
  State<MypostsLandownerView> createState() => _MypostsLandownerViewState();
}

class _MypostsLandownerViewState extends State<MypostsLandownerView> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    context.read<GetLandPostsCubit>().getLandPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            final metrics = notification.metrics;

            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              context.read<GetLandPostsCubit>().loadMore();
            }
          }
          return false;
        },
        child: BlocBuilder<GetLandPostsCubit, GetLandPostsState>(
          builder: (context, state) {
            /// 🔹 Loading (first load)
            if (state is GetLandPostsLoadingState) {
              return LoadingDialog(height: 250.h, width: 250.w);
            }

            /// 🔹 Failure
            if (state is GetLandPostsFailure) {
              return Center(child: Text(state.errMessage));
            }

            /// 🔹 Success
            if (state is GetLandPostsSuccessState) {
              final posts = state.posts;

              return RefreshWidget(
                keyRefresh: _refreshKey,
                onRefresh: () async {
                  await context.read<GetLandPostsCubit>().getLandPosts();
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: posts.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    /// 🔹 Loader at bottom
                    if (index == posts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = posts[index];

                    return LandPostCard(
                      item: item,
                      viewerType: Roles.LandOwner,
                      onReturned: () {
                        context.read<GetLandPostsCubit>().getLandPosts();
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
