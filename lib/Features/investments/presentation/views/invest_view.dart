import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/investments/data/models/investment_opportunity_model.dart';
import 'package:takween/Features/investments/data/models/my_investment_model.dart';
import 'package:takween/Features/investments/presentation/viewmodels/invest/invest_cubit.dart';
import 'package:takween/Features/investments/presentation/viewmodels/invest/invest_state.dart';
import 'package:takween/Features/investments/presentation/views/widgets/submit_investment_sheet.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class InvestView extends StatelessWidget {
  const InvestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InvestCubit>()..load(),
      child: const _InvestViewBody(),
    );
  }
}

class _InvestViewBody extends StatelessWidget {
  const _InvestViewBody();

  Future<void> _handleCheckout(
    BuildContext context,
    InvestCheckoutReady state,
  ) async {
    final cubit = context.read<InvestCubit>();
    final uri = Uri.tryParse(state.checkoutUrl);
    if (uri == null) {
      context.showErrorSnackBar('Invalid checkout link');
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      if (context.mounted) context.showErrorSnackBar('Could not open checkout');
      return;
    }
    if (!context.mounted) return;
    final paid = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Complete payment'),
        content: const Text(
          'Finish the payment in your browser, then tap "I\'ve paid" to confirm.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("I've paid"),
          ),
        ],
      ),
    );
    if (paid != true) return;
    await cubit.confirmPayment(state.paymentId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocConsumer<InvestCubit, InvestState>(
        listener: (context, state) {
          if (state is InvestTransientError) {
            context.showErrorSnackBar(state.message);
          }
          if (state is InvestActionSuccess) {
            context.showSuccessSnackBar(state.message);
          }
          if (state is InvestCheckoutReady) {
            _handleCheckout(context, state);
          }
        },
        buildWhen: (prev, curr) =>
            curr is! InvestTransientError &&
            curr is! InvestActionSuccess &&
            curr is! InvestCheckoutReady,
        builder: (context, state) {
          return Column(
            children: [
              Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.primaryMuted,
                  indicatorColor: AppColors.primary,
                  labelStyle:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: TextStyle(fontSize: 13.sp),
                  tabs: const [
                    Tab(text: 'Opportunities'),
                    Tab(text: 'My Investments'),
                  ],
                ),
              ),
              Expanded(child: _content(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context, InvestState state) {
    if (state is InvestInitial || state is InvestLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is InvestFailure) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 28.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(state.message, textAlign: TextAlign.center),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () => context.read<InvestCubit>().load(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (state is InvestLoaded) {
      return TabBarView(
        children: [
          _OpportunitiesList(items: state.opportunities),
          _MyInvestmentsList(
            items: state.myInvestments,
            payingRequestId: state.payingRequestId,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

class _OpportunitiesList extends StatelessWidget {
  final List<InvestmentOpportunityModel> items;
  const _OpportunitiesList({required this.items});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InvestCubit>();
    if (items.isEmpty) {
      return _EmptyState(
        icon: FontAwesomeIcons.magnifyingGlassChart,
        message: 'No open investment opportunities right now.',
      );
    }
    return RefreshIndicator(
      onRefresh: cubit.refresh,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: items.length,
        itemBuilder: (_, i) => _OpportunityCard(
          item: items[i],
          onInvest: () => _openSubmitSheet(context, items[i]),
        ),
      ),
    );
  }

  void _openSubmitSheet(BuildContext context, InvestmentOpportunityModel item) {
    final cubit = context.read<InvestCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: SubmitInvestmentSheet(opportunity: item),
      ),
    );
  }
}

class _MyInvestmentsList extends StatelessWidget {
  final List<MyInvestmentModel> items;
  final String? payingRequestId;
  const _MyInvestmentsList({required this.items, this.payingRequestId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InvestCubit>();
    if (items.isEmpty) {
      return _EmptyState(
        icon: FontAwesomeIcons.fileInvoiceDollar,
        message: 'You have not submitted any investment requests yet.',
      );
    }
    return RefreshIndicator(
      onRefresh: cubit.refresh,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: items.length,
        itemBuilder: (_, i) => _MyInvestmentCard(
          item: items[i],
          isPaying: payingRequestId == items[i].id,
          onPay: () => cubit.pay(items[i]),
        ),
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final InvestmentOpportunityModel item;
  final VoidCallback onInvest;

  const _OpportunityCard({required this.item, required this.onInvest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  item.projectStatus,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '${item.city} • ${item.neighborhood}',
            style: TextStyle(fontSize: 11.sp, color: AppColors.primaryMuted),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _MetaItem(
                  label: 'Available shares',
                  value: '${item.availableShares} / 2400',
                ),
              ),
              Expanded(
                child: _MetaItem(
                  label: 'Investors',
                  value: item.currentInvestorCount.toString(),
                ),
              ),
            ],
          ),
          if (item.estimatedCostUsd != null) ...[
            SizedBox(height: 8.h),
            _MetaItem(
              label: 'Estimated cost',
              value: item.estimatedCostUsd!.toCurrency(),
            ),
          ],
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onInvest,
              icon: const Icon(Icons.handshake_rounded),
              label: const Text('Invest'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyInvestmentCard extends StatelessWidget {
  final MyInvestmentModel item;
  final bool isPaying;
  final VoidCallback onPay;

  const _MyInvestmentCard({
    required this.item,
    required this.isPaying,
    required this.onPay,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.error;
      case 'PAID':
        return AppColors.info;
      case 'PENDING':
        return AppColors.warning;
      default:
        return AppColors.primaryMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.projectTitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _statusColor(item.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(item.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            item.projectCity,
            style: TextStyle(fontSize: 11.sp, color: AppColors.primaryMuted),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _MetaItem(
                  label: 'Amount',
                  value: item.investmentAmountUsd.toCurrency(),
                ),
              ),
              Expanded(
                child: _MetaItem(
                  label: 'Shares',
                  value: '${item.requestedShares} / 2400',
                ),
              ),
            ],
          ),
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              item.notes!,
              style: TextStyle(fontSize: 11.sp, color: AppColors.primaryMuted),
            ),
          ],
          if (item.status.toUpperCase() == 'APPROVED') ...[
            SizedBox(height: 12.h),
            isPaying
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(6.h),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : CustomButton(
                    title: 'Pay Now',
                    icon: Icons.payment_rounded,
                    color: AppColors.primary,
                    onTap: onPay,
                  ),
          ],
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;
  const _MetaItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: AppColors.primaryMuted),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final FaIconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 32.sp, color: AppColors.primaryMuted),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.primaryMuted),
            ),
          ),
        ],
      ),
    );
  }
}
