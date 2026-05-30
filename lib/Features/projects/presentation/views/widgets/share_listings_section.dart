import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/Features/projects/data/models/share_listing_model.dart';
import 'package:takween/Features/projects/presentation/viewmodels/share_listings/share_listings_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/share_listings/share_listings_state.dart';
import 'package:takween/Features/projects/presentation/views/widgets/create_share_listing_bottom_sheet.dart';
import 'package:takween/Features/projects/presentation/views/widgets/share_listing_tile.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareListingsSection extends StatelessWidget {
  final ProjectModel project;

  const ShareListingsSection({super.key, required this.project});

  static const _activeStatuses = {
    'CONTRACT_SIGNED',
    'IN_PROGRESS',
    'INSPECTION',
    'COMPLETED',
  };

  @override
  Widget build(BuildContext context) {
    final status = project.status.toUpperCase();
    if (!_activeStatuses.contains(status)) return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => sl<ShareListingsCubit>()..load(project.id),
      child: _ShareListingsSectionView(project: project),
    );
  }
}

class _ShareListingsSectionView extends StatelessWidget {
  final ProjectModel project;

  const _ShareListingsSectionView({required this.project});

  int _ownedShares(ShareListingsLoadedState state) {
    final me = state.currentUserId;
    if (me == null) return 0;
    return project.shares
        .where((s) => s.userId == me)
        .fold<int>(0, (sum, s) => sum + s.shareCount);
  }

  int _alreadyListedShares(ShareListingsLoadedState state) {
    final me = state.currentUserId;
    if (me == null) return 0;
    return state.listings
        .where(
          (l) =>
              l.sellerUserId == me && l.status.toUpperCase() == 'OPEN',
        )
        .fold<int>(0, (sum, l) => sum + l.shareCount);
  }

  bool _canCreateListing(ShareListingsLoadedState state) {
    if (!(state.isLandOwner || state.isContractor)) return false;
    return _ownedShares(state) - _alreadyListedShares(state) > 0;
  }

  bool _canBuy(ShareListingsLoadedState state, ShareListingModel listing) {
    if (listing.status.toUpperCase() != 'OPEN') return false;
    if (listing.sellerUserId == state.currentUserId) return false;
    return state.isBuyer || state.isContractor;
  }

  bool _canCancel(
    ShareListingsLoadedState state,
    ShareListingModel listing,
  ) {
    if (listing.status.toUpperCase() != 'OPEN') return false;
    if (listing.sellerUserId != state.currentUserId) return false;
    return state.isLandOwner || state.isContractor;
  }

  void _openCreate(BuildContext context, ShareListingsLoadedState state) {
    final maxAvailable =
        _ownedShares(state) - _alreadyListedShares(state);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<ShareListingsCubit>(),
        child: BlocBuilder<ShareListingsCubit, ShareListingsState>(
          builder: (innerCtx, s) {
            final creating =
                s is ShareListingsLoadedState && s.isCreating;
            return CreateShareListingBottomSheet(
              isCreating: creating,
              maxAvailableShares: maxAvailable,
              onSubmit: ({
                required shareCount,
                required pricePerShareUsd,
              }) async {
                await innerCtx.read<ShareListingsCubit>().createListing(
                      projectId: project.id,
                      shareCount: shareCount,
                      pricePerShareUsd: pricePerShareUsd,
                    );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmBuy(
    BuildContext context,
    ShareListingModel listing,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Buy shares'),
        content: Text(
          'Purchase ${listing.shareCount} shares from ${listing.sellerName} '
          'for ${listing.totalPriceUsd.toCurrency()}?',
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
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<ShareListingsCubit>().purchase(
          projectId: project.id,
          listingId: listing.id,
        );
  }

  Future<void> _handleCheckout(
    BuildContext context,
    ShareListingsCheckoutReady state,
  ) async {
    final cubit = context.read<ShareListingsCubit>();
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
    await cubit.confirmPayment(
      paymentId: state.paymentId,
      projectId: state.projectId,
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    ShareListingModel listing,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Cancel listing'),
        content: Text(
          'Remove your listing of ${listing.shareCount} shares?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel listing'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<ShareListingsCubit>().cancel(
          projectId: project.id,
          listingId: listing.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShareListingsCubit, ShareListingsState>(
      listener: (context, state) {
        if (state is ShareListingsTransientError) {
          context.showErrorSnackBar(state.message);
        }
        if (state is ShareListingsActionSuccess) {
          context.showSuccessSnackBar(state.message);
        }
        if (state is ShareListingsCheckoutReady) {
          _handleCheckout(context, state);
        }
      },
      buildWhen: (prev, curr) =>
          curr is! ShareListingsTransientError &&
          curr is! ShareListingsActionSuccess &&
          curr is! ShareListingsCheckoutReady,
      builder: (context, state) {
        if (state is ShareListingsInitialState ||
            state is ShareListingsLoadingState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ShareListingsFailureState) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 14.sp,
                  color: AppColors.error,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.error,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<ShareListingsCubit>().load(project.id),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ShareListingsLoadedState) {
          final canCreate = _canCreateListing(state);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.handshakeAngle,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Share Marketplace (${state.listings.length})',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              if (state.listings.isEmpty)
                _EmptyListings(canCreate: canCreate)
              else
                ...state.listings.map(
                  (l) => ShareListingTile(
                    listing: l,
                    isProcessing: state.processingListingId == l.id,
                    canBuy: _canBuy(state, l),
                    canCancel: _canCancel(state, l),
                    onBuy: () => _confirmBuy(context, l),
                    onCancel: () => _confirmCancel(context, l),
                  ),
                ),
              if (canCreate) ...[
                SizedBox(height: 10.h),
                CustomButton(
                  title: 'List Shares',
                  icon: Icons.sell_outlined,
                  color: AppColors.accent,
                  onTap: () => _openCreate(context, state),
                ),
              ],
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _EmptyListings extends StatelessWidget {
  final bool canCreate;

  const _EmptyListings({required this.canCreate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.handshakeAngle,
            size: 16.sp,
            color: AppColors.primaryMuted,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              canCreate
                  ? 'No open listings. List some of your shares to start.'
                  : 'No open listings yet.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primaryMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
