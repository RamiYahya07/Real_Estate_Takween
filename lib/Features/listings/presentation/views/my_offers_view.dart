import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/listings/data/models/my_offer_model.dart';
import 'package:takween/Features/listings/presentation/viewmodels/my_offers/my_offers_cubit.dart';
import 'package:takween/Features/listings/presentation/viewmodels/my_offers/my_offers_state.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MyOffersView extends StatelessWidget {
  const MyOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyOffersCubit>()..load(),
      child: const _MyOffersViewBody(),
    );
  }
}

class _MyOffersViewBody extends StatelessWidget {
  const _MyOffersViewBody();

  Future<void> _handleCheckout(
    BuildContext context,
    MyOffersCheckoutReady state,
  ) async {
    final cubit = context.read<MyOffersCubit>();
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
    return BlocConsumer<MyOffersCubit, MyOffersState>(
      listener: (context, state) {
        if (state is MyOffersTransientError) {
          context.showErrorSnackBar(state.message);
        }
        if (state is MyOffersActionSuccess) {
          context.showSuccessSnackBar(state.message);
        }
        if (state is MyOffersCheckoutReady) {
          _handleCheckout(context, state);
        }
      },
      buildWhen: (prev, curr) =>
          curr is! MyOffersTransientError &&
          curr is! MyOffersActionSuccess &&
          curr is! MyOffersCheckoutReady,
      builder: (context, state) {
        if (state is MyOffersInitial || state is MyOffersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MyOffersFailure) {
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
                Text(state.message, textAlign: TextAlign.center),
                SizedBox(height: 10.h),
                TextButton(
                  onPressed: () => context.read<MyOffersCubit>().load(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is MyOffersLoaded) {
          if (state.offers.isEmpty) {
            return _EmptyOffers();
          }
          return RefreshIndicator(
            onRefresh: () => context.read<MyOffersCubit>().refresh(),
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.offers.length,
              itemBuilder: (_, i) {
                final offer = state.offers[i];
                return _MyOfferCard(
                  offer: offer,
                  isPaying: state.payingOfferId == offer.id,
                  onPay: () => context.read<MyOffersCubit>().pay(offer),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _MyOfferCard extends StatelessWidget {
  final MyOfferModel offer;
  final bool isPaying;
  final VoidCallback onPay;

  const _MyOfferCard({
    required this.offer,
    required this.isPaying,
    required this.onPay,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.error;
      case 'COUNTERED':
        return AppColors.info;
      case 'PENDING':
        return AppColors.warning;
      default:
        return AppColors.primaryMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAccepted = offer.status.toUpperCase() == 'ACCEPTED';
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
                  offer.listingTitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _statusColor(offer.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  offer.status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(offer.status),
                  ),
                ),
              ),
            ],
          ),
          if (offer.listingCity != null) ...[
            SizedBox(height: 4.h),
            Text(
              offer.listingCity!,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.primaryMuted,
              ),
            ),
          ],
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _MetaItem(
                  label: 'Your offer',
                  value: offer.offerPriceUsd.toCurrency(),
                ),
              ),
              Expanded(
                child: _MetaItem(
                  label: 'Asking',
                  value: offer.listingAskingPriceUsd.toCurrency(),
                ),
              ),
            ],
          ),
          if (isAccepted) ...[
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

class _EmptyOffers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.fileInvoiceDollar,
            size: 32.sp,
            color: AppColors.primaryMuted,
          ),
          SizedBox(height: 12.h),
          Text(
            'You have not made any offers yet.',
            style: TextStyle(fontSize: 13.sp, color: AppColors.primaryMuted),
          ),
        ],
      ),
    );
  }
}
