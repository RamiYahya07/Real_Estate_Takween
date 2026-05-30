import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/listings/presentation/viewmodels/listing_offers/listing_offers_cubit.dart';
import 'package:takween/Features/listings/presentation/viewmodels/listing_offers/listing_offers_state.dart';
import 'package:takween/Features/listings/presentation/views/widgets/offer_tile.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class ListingOffersView extends StatelessWidget {
  final String listingId;

  const ListingOffersView({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ListingOffersCubit>()..load(listingId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Offers')),
        body: _Body(listingId: listingId),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String listingId;
  const _Body({required this.listingId});

  Future<void> _confirm({
    required BuildContext context,
    required String offerId,
    required bool approve,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: Text(approve ? 'Accept offer' : 'Reject offer'),
        content: Text(
          approve
              ? 'Accepting will close this listing and mark it as sold/rented.'
              : 'This offer will be marked as rejected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dCtx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: approve ? AppColors.success : AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(approve ? 'Accept' : 'Reject'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context
        .read<ListingOffersCubit>()
        .review(listingId: listingId, offerId: offerId, approve: approve);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListingOffersCubit, ListingOffersState>(
      listener: (context, state) {
        if (state is ListingOffersTransientError) {
          context.showErrorSnackBar(state.message);
        }
        if (state is ListingOffersActionSuccess) {
          context.showSuccessSnackBar(state.message);
        }
      },
      buildWhen: (prev, curr) =>
          curr is! ListingOffersTransientError &&
          curr is! ListingOffersActionSuccess,
      builder: (context, state) {
        if (state is ListingOffersInitialState ||
            state is ListingOffersLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ListingOffersFailureState) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<ListingOffersCubit>().load(listingId),
          );
        }
        if (state is ListingOffersLoadedState) {
          if (state.offers.isEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<ListingOffersCubit>().refresh(listingId),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 100.h),
                  Center(
                    child: FaIcon(
                      FontAwesomeIcons.envelopeOpenText,
                      size: 56.sp,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Center(
                    child: Text(
                      'No offers yet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<ListingOffersCubit>().refresh(listingId),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              itemCount: state.offers.length,
              itemBuilder: (context, index) {
                final o = state.offers[index];
                return OfferTile(
                  offer: o,
                  isProcessing: state.processingOfferId == o.id,
                  onAccept: () => _confirm(
                    context: context,
                    offerId: o.id,
                    approve: true,
                  ),
                  onReject: () => _confirm(
                    context: context,
                    offerId: o.id,
                    approve: false,
                  ),
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
