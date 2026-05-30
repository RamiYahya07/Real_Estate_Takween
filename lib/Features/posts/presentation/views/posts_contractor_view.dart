import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/bid/presentation/viewmodels/request_bid/request_bid_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_open_land_post/get_open_land_post_cubit.dart';
import 'package:takween/Features/posts/presentation/views/widgets/posts_contractor_view_body.dart';
import 'package:takween/core/di/injection.dart';

class PostsContractorView extends StatelessWidget {
  const PostsContractorView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<RequestBidCubit>()),
        BlocProvider(
          create: (_) => sl<GetOpenLandPostsCubit>()..getOpenLandPosts(),
        ),
      ],
      child: Scaffold(body: PostsContractorViewBody()),
    );
  }
}
