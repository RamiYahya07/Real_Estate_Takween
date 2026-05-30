import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_open_land_post/get_open_land_post_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_open_land_post/get_open_land_post_state.dart';
import 'package:takween/Features/posts/presentation/views/widgets/land_post_card.dart';
import 'package:takween/Features/posts/presentation/views/widgets/show_request_bid_bottom_sheet.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/constants.dart';
import 'package:takween/core/utils/helper/refresh.dart';
import 'package:takween/core/widgets/show_loading.dart';

class PostsContractorViewBody extends StatefulWidget {
  const PostsContractorViewBody({super.key});

  @override
  State<PostsContractorViewBody> createState() =>
      _PostsContractorViewBodyState();
}

class _PostsContractorViewBodyState extends State<PostsContractorViewBody> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          final metrics = notification.metrics;

          if (metrics.pixels >= metrics.maxScrollExtent - 200) {
            context.read<GetOpenLandPostsCubit>().loadMore();
          }
        }
        return false;
      },
      child: BlocBuilder<GetOpenLandPostsCubit, GetOpenLandPostsState>(
        builder: (context, state) {
          /// 🔹 Loading (first load)
          if (state is GetOpenLandPostsLoadingState) {
            return LoadingDialog();
          }

          /// 🔹 Failure
          if (state is GetOpenLandPostsFailure) {
            return Center(child: Text(state.errMessage));
          }

          /// 🔹 Success
          if (state is GetOpenLandPostsSuccessState) {
            final posts = state.posts;

            return RefreshWidget(
              keyRefresh: _refreshKey,
              onRefresh: () async {
                await context.read<GetOpenLandPostsCubit>().getOpenLandPosts();
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
                    viewerType: Roles.Contractor,
                    action: IconButton(
                      onPressed: () {
                        final type = investmentTypeFromString(
                          item.investmentType,
                        );

                        showRequestBidBottomSheet(
                          context: context,
                          type: type,
                          post: item,
                        );
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: AppColors.accent,
                        size: 22.sp,
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
