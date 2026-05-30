import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/bid/presentation/viewmodels/request_bid/request_bid_cubit.dart';
import 'package:takween/Features/posts/presentation/views/widgets/request_bid_form.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/utils/constants.dart';

void showRequestBidBottomSheet({
  required BuildContext context,
  required InvestmentType type,
  required dynamic post,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return BlocProvider(
        create: (_) => sl<RequestBidCubit>(),
        child: RequestBidForm(type: type, post: post),
      );
    },
  );
}
