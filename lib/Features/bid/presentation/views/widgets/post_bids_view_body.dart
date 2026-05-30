import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/bid/data/models/bid_item_model.dart';
import 'package:takween/Features/bid/presentation/viewmodels/bid_action/bid_action_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/bid_action/bid_action_state.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_summary/get_bid_summary_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_summary/get_bid_summary_state.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bids/get_bids_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bids/get_bids_state.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/utils/helper/refresh.dart';
import 'package:takween/core/widgets/custom_button.dart';

class PostBidsViewBody extends StatefulWidget {
  final String postId;

  const PostBidsViewBody({super.key, required this.postId});

  @override
  State<PostBidsViewBody> createState() => _PostBidsViewBodyState();
}

class _PostBidsViewBodyState extends State<PostBidsViewBody> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    context.read<GetBidsCubit>().getBids(widget.postId);
    context.read<GetBidSummaryCubit>().getBidSummary(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BidActionCubit, BidActionState>(
      listener: (context, state) {
        if (state is BidActionLoadingState) {
          context.showLoading();
        }

        if (state is BidActionSuccessState) {
          Navigator.pop(context);

          context.read<GetBidsCubit>().getBids(widget.postId);
          context.read<GetBidSummaryCubit>().getBidSummary(widget.postId);
          context.showSuccessSnackBar("Action completed");
        }

        if (state is BidActionFailureState) {
          Navigator.pop(context);
          context.showErrorSnackBar(state.message);
        }
      },
      child: Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              final metrics = notification.metrics;

              if (metrics.pixels >= metrics.maxScrollExtent - 200) {
                context.read<GetBidsCubit>().loadMore(widget.postId);
              }
            }
            return false;
          },
          child: BlocBuilder<GetBidsCubit, GetBidsState>(
            builder: (context, state) {
              /// 🔹 Loading
              if (state is GetBidsLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              /// 🔹 Failure
              if (state is GetBidsFailureState) {
                return Center(child: Text(state.message));
              }

              /// 🔹 Success
              if (state is GetBidsSuccessState) {
                final bids = state.bids;

                if (bids.isEmpty) {
                  return const Center(child: Text("No bids yet"));
                }

                return Column(
                  children: [
                    _BidSummarySection(postId: widget.postId),
                    Expanded(
                      child: RefreshWidget(
                        keyRefresh: _refreshKey,
                        onRefresh: () async {
                          await context.read<GetBidsCubit>().getBids(
                            widget.postId,
                          );
                          await context
                              .read<GetBidSummaryCubit>()
                              .getBidSummary(widget.postId);
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount:
                              bids.length + (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            /// 🔹 Loader at bottom
                            if (index == bids.length) {
                              return const Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final bid = bids[index];

                            return _BidCard(bid: bid);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _BidCard extends StatelessWidget {
  final BidItemModel bid;

  const _BidCard({required this.bid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () {
        context.push(Routes.bidDetails, extra: bid.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Contractor + Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    bid.contractorName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _statusBadge(bid.status),
              ],
            ),

            SizedBox(height: 8.h),

            /// Info
            Text(
              "Cost: \$${bid.estimatedConstructionCostUsd.toStringAsFixed(0)}",
            ),
            Text("Timeline: ${bid.estimatedTimelineMonths} months"),

            if (bid.offerPriceUsd != null)
              Text("Offer: \$${bid.offerPriceUsd}"),
            if (bid.status == "PENDING") ...[
              SizedBox(height: 10.h),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: "Accept",
                      icon: Icons.check,
                      color: Colors.green,
                      onTap: () {
                        context.read<BidActionCubit>().acceptBid(bid.id);
                      },
                    ),
                    // child: ElevatedButton(
                    //   onPressed: () {
                    //     context.read<BidActionCubit>().acceptBid(bid.id);
                    //   },
                    //   child: const Text("Accept"),
                    // ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      title: "Reject",
                      icon: Icons.close,
                      color: Colors.red,
                      onTap: () {
                        context.read<BidActionCubit>().rejectBid(bid.id);
                      },
                    ),
                    // child: OutlinedButton(
                    //   onPressed: () {
                    //     context.read<BidActionCubit>().rejectBid(bid.id);
                    //   },
                    //   child: const Text("Reject"),
                    // ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(height: 10.h),
              Text(
                bid.status == "ACCEPTED"
                    ? "This bid has been accepted"
                    : "This bid was rejected",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: bid.status == "ACCEPTED" ? Colors.green : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case "PENDING":
        color = Colors.orange;
        break;
      case "ACCEPTED":
        color = Colors.green;
        break;
      case "REJECTED":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BidSummarySection extends StatelessWidget {
  final String postId;

  const _BidSummarySection({required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBidSummaryCubit, GetBidSummaryState>(
      builder: (context, state) {
        if (state is GetBidSummaryLoadingState) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: LinearProgressIndicator(),
          );
        }

        if (state is GetBidSummaryFailureState) {
          return const SizedBox();
        }

        if (state is GetBidSummarySuccessState) {
          final summary = state.data;

          return Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _summaryItem(
                        "Total",
                        summary.totalBids.toString(),
                        Icons.gavel,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _summaryItem(
                        "Pending",
                        summary.pendingBids.toString(),
                        Icons.pending_actions,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                Row(
                  children: [
                    Expanded(
                      child: _summaryItem(
                        "Avg Cost",
                        "\$${summary.averageConstructionCostUsd}",
                        Icons.attach_money,
                        Colors.green,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _summaryItem(
                        "Timeline",
                        "${summary.shortestTimelineMonths}m",
                        Icons.timer,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  margin: EdgeInsets.only(top: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.black.withValues(alpha: 0.03),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 2.h,
                      ),
                      childrenPadding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.analytics_outlined,
                          color: Colors.blue,
                          size: 20.sp,
                        ),
                      ),
                      title: Text(
                        "More Statistics",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "Tap to view detailed bid analytics",
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                      children: [
                        _rowItem(
                          "Lowest Offer",
                          summary.lowestOfferUsd == null
                              ? "--"
                              : "\$${summary.lowestOfferUsd}",
                        ),

                        _rowItem(
                          "Highest Offer",
                          summary.highestOfferUsd == null
                              ? "--"
                              : "\$${summary.highestOfferUsd}",
                        ),

                        _rowItem(
                          "Average Offer",
                          summary.averageOfferUsd == null
                              ? "--"
                              : "\$${summary.averageOfferUsd}",
                        ),

                        _rowItem(
                          "Longest Timeline",
                          "${summary.longestTimelineMonths} months",
                        ),

                        _rowItem(
                          "Latest Bid",
                          "${summary.latestBidAt.day}/${summary.latestBidAt.month}/${summary.latestBidAt.year}",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

Widget _summaryItem(String title, String value, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    ),
  );
}

Widget _rowItem(String title, String value) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(title),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      const Divider(height: 1),
    ],
  );
}
