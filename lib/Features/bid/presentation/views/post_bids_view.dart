import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/bid/presentation/viewmodels/bid_action/bid_action_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_details/get_bid_details_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_summary/get_bid_summary_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bids/get_bids_cubit.dart';
import 'package:takween/Features/bid/presentation/views/widgets/post_bids_view_body.dart';
import 'package:takween/core/di/injection.dart';

class PostBidsView extends StatelessWidget {
  final String postId;

  const PostBidsView({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<GetBidsCubit>()),
        BlocProvider(create: (_) => sl<BidActionCubit>()),
        BlocProvider(create: (_) => sl<GetBidSummaryCubit>()),
        // BlocProvider(create: (_) => sl<GetBidDetailsCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("Bids")),
        body: PostBidsViewBody(postId: postId),
      ),
    );
  }
}
