import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/statistics/data/models/buyer_stats_model.dart';
import 'package:takween/Features/statistics/data/models/contractor_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/landOwner_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/listing_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/project_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/shares_statistics_model.dart';
import 'package:takween/Features/statistics/presentation/viewmodels/dashboard/dashboard_cubit.dart';
import 'package:takween/Features/statistics/presentation/viewmodels/dashboard/dashboard_state.dart';
import 'package:takween/Features/statistics/presentation/views/widgets/shares_breakdown_card.dart';
import 'package:takween/Features/statistics/presentation/views/widgets/stat_metric_card.dart';
import 'package:takween/Features/statistics/presentation/views/widgets/stats_section.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/colors.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>()..load(),
      child: const _DashboardViewBody(),
    );
  }
}

class _DashboardViewBody extends StatelessWidget {
  const _DashboardViewBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardInitialState || state is DashboardLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DashboardFailureState) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<DashboardCubit>().load(),
          );
        }
        if (state is DashboardLoadedState) {
          if (state.buyer != null) {
            return RefreshIndicator(
              onRefresh: () => context.read<DashboardCubit>().refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                children: _buyerSections(state.buyer!),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                if (state.landowner != null) ...[
                  _CreatePostCard(),
                  SizedBox(height: 14.h),
                  _landownerSection(state.landowner!),
                  SizedBox(height: 18.h),
                ],
                if (state.contractor != null) ...[
                  _contractorSection(state.contractor!),
                  SizedBox(height: 18.h),
                ],
                if (state.projects != null) ...[
                  _projectsSection(state.projects!),
                  SizedBox(height: 18.h),
                ],
                if (state.shares != null) ...[
                  _sharesSection(state.shares!),
                  SizedBox(height: 18.h),
                ],
                if (state.listings != null) ...[
                  _listingsSection(state.listings!),
                ],
                if (state.partialErrorMessage != null) ...[
                  SizedBox(height: 18.h),
                  _PartialErrorBanner(message: state.partialErrorMessage!),
                ],
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _landownerSection(LandownerDashboardModel m) => StatsSection(
    icon: FontAwesomeIcons.userTie,
    title: 'My Posts',
    tiles: [
      StatMetricCard(
        icon: FontAwesomeIcons.fileLines,
        label: 'Total posts',
        value: m.totalPosts.toString(),
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.unlock,
        label: 'Open',
        value: m.openPosts.toString(),
        accent: AppColors.success,
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.lock,
        label: 'Closed',
        value: m.closedPosts.toString(),
        accent: AppColors.primaryMuted,
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.fileCircleQuestion,
        label: 'Drafts',
        value: m.draftPosts.toString(),
        accent: AppColors.warning,
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.gavel,
        label: 'Received bids',
        value: m.receivedBids.toString(),
        accent: AppColors.info,
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.hourglassHalf,
        label: 'Pending bids',
        value: m.pendingBids.toString(),
        accent: AppColors.warning,
      ),
    ],
  );

  Widget _contractorSection(ContractorDashboardModel m) => StatsSection(
    icon: FontAwesomeIcons.helmetSafety,
    title: 'My Bids',
    tiles: [
      StatMetricCard(
        icon: FontAwesomeIcons.gavel,
        label: 'Total bids',
        value: m.totalBids.toString(),
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.hourglassHalf,
        label: 'Pending',
        value: m.pendingBids.toString(),
        accent: AppColors.warning,
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.circleCheck,
        label: 'Accepted',
        value: m.acceptedBids.toString(),
        accent: AppColors.success,
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.circleXmark,
        label: 'Rejected',
        value: m.rejectedBids.toString(),
        accent: AppColors.error,
      ),
    ],
  );

  Widget _projectsSection(ProjectStatisticsModel m) => StatsSection(
    icon: FontAwesomeIcons.buildingFlag,
    title: 'Projects',
    tiles: [
      StatMetricCard(
        icon: FontAwesomeIcons.layerGroup,
        label: 'Total',
        value: m.totalProjects.toString(),
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.personDigging,
        label: 'Active',
        value: m.activeProjects.toString(),
        accent: AppColors.info,
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.flagCheckered,
        label: 'Completed',
        value: m.completedProjects.toString(),
        accent: AppColors.success,
      ),
    ],
  );

  Widget _sharesSection(SharesStatisticsModel m) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StatsSection(
        icon: FontAwesomeIcons.chartPie,
        title: 'Shares',
        tiles: [
          StatMetricCard(
            icon: FontAwesomeIcons.coins,
            label: 'Total shares owned',
            value: m.totalSharesOwned.toString(),
          ),
          StatMetricCard(
            icon: FontAwesomeIcons.buildingFlag,
            label: 'Projects with shares',
            value: m.projectsWithShares.toString(),
            accent: AppColors.info,
          ),
          StatMetricCard(
            icon: FontAwesomeIcons.percent,
            label: 'Avg %',
            value: '${m.averageSharePercentage.toStringAsFixed(1)}%',
            accent: AppColors.accent,
          ),
        ],
      ),
      if (m.breakdown.isNotEmpty) ...[
        SizedBox(height: 12.h),
        SharesBreakdownCard(items: m.breakdown),
      ],
    ],
  );

  List<Widget> _buyerSections(BuyerStatsModel m) => [
    StatsSection(
      icon: FontAwesomeIcons.bagShopping,
      title: 'My Property Offers',
      tiles: [
        StatMetricCard(
          icon: FontAwesomeIcons.tag,
          label: 'Total offers',
          value: m.totalOffers.toString(),
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.hourglassHalf,
          label: 'Pending',
          value: m.pendingOffers.toString(),
          accent: AppColors.warning,
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.circleCheck,
          label: 'Accepted',
          value: m.acceptedOffers.toString(),
          accent: AppColors.success,
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.circleXmark,
          label: 'Rejected',
          value: m.rejectedOffers.toString(),
          accent: AppColors.error,
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.key,
          label: 'Units owned',
          value: m.unitsOwned.toString(),
          accent: AppColors.info,
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.bookmark,
          label: 'Saved',
          value: m.savedListings.toString(),
          accent: AppColors.accent,
        ),
      ],
    ),
    SizedBox(height: 18.h),
    StatsSection(
      icon: FontAwesomeIcons.handHoldingDollar,
      title: 'My Investments',
      tiles: [
        StatMetricCard(
          icon: FontAwesomeIcons.fileInvoiceDollar,
          label: 'Total requests',
          value: m.totalInvestmentRequests.toString(),
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.hourglassHalf,
          label: 'Pending',
          value: m.pendingInvestmentRequests.toString(),
          accent: AppColors.warning,
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.circleCheck,
          label: 'Approved',
          value: m.approvedInvestmentRequests.toString(),
          accent: AppColors.success,
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.circleXmark,
          label: 'Rejected',
          value: m.rejectedInvestmentRequests.toString(),
          accent: AppColors.error,
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.moneyBillTransfer,
          label: 'Paid',
          value: m.paidInvestmentRequests.toString(),
          accent: AppColors.info,
        ),
      ],
    ),
    SizedBox(height: 18.h),
    StatsSection(
      icon: FontAwesomeIcons.chartPie,
      title: 'My Shares',
      tiles: [
        StatMetricCard(
          icon: FontAwesomeIcons.coins,
          label: 'Shares owned',
          value: m.totalSharesOwned.toString(),
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.buildingFlag,
          label: 'Projects with shares',
          value: m.projectsWithShares.toString(),
          accent: AppColors.info,
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.percent,
          label: 'Avg %',
          value: '${m.averageSharePercentage.toStringAsFixed(1)}%',
          accent: AppColors.accent,
        ),
        StatMetricCard(
          icon: FontAwesomeIcons.layerGroup,
          label: 'Projects (total)',
          value: m.projectsParticipating.toString(),
          accent: AppColors.primary,
        ),
      ],
    ),
    if (m.sharesBreakdown.isNotEmpty) ...[
      SizedBox(height: 12.h),
      SharesBreakdownCard(items: m.sharesBreakdown),
    ],
  ];

  Widget _listingsSection(ListingStatisticsModel m) => StatsSection(
    icon: FontAwesomeIcons.house,
    title: 'Listings',
    tiles: [
      StatMetricCard(
        icon: FontAwesomeIcons.list,
        label: 'Total',
        value: m.totalListings.toString(),
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.boltLightning,
        label: 'Active',
        value: m.activeListings.toString(),
        accent: AppColors.success,
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.handshake,
        label: 'Sold',
        value: m.soldListings.toString(),
        accent: AppColors.info,
      ),
      StatMetricCard(
        icon: FontAwesomeIcons.bell,
        label: 'Pending offers',
        value: m.pendingOffers.toString(),
        accent: AppColors.warning,
      ),
    ],
  );
}

class _PartialErrorBanner extends StatelessWidget {
  final String message;

  const _PartialErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.circleInfo,
            size: 14.sp,
            color: AppColors.warning,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Some data failed to load:\n$message',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.warning,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatePostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(Routes.post);
      },
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Publish a new land investment opportunity.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
