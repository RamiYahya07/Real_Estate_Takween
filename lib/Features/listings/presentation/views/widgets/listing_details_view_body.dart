import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/listings/data/models/property_listing_model.dart';
import 'package:takween/Features/listings/presentation/viewmodels/listing_details/listing_details_cubit.dart';
import 'package:takween/Features/listings/presentation/viewmodels/listing_details/listing_details_state.dart';
import 'package:takween/Features/listings/presentation/views/widgets/make_offer_bottom_sheet.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';

class ListingDetailsViewBody extends StatelessWidget {
  final String listingId;

  const ListingDetailsViewBody({super.key, required this.listingId});

  void _openOfferSheet(BuildContext context, ListingDetailsLoadedState s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<ListingDetailsCubit>(),
        child: BlocBuilder<ListingDetailsCubit, ListingDetailsState>(
          builder: (innerCtx, state) {
            final submitting = state is ListingDetailsLoadedState &&
                state.isSubmittingOffer;
            return MakeOfferBottomSheet(
              listingPrice: s.listing.priceUsd,
              isSubmitting: submitting,
              onSubmit: ({required offerPriceUsd, message}) async {
                await innerCtx.read<ListingDetailsCubit>().makeOffer(
                      listingId: listingId,
                      offerPriceUsd: offerPriceUsd,
                      message: message,
                    );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListingDetailsCubit, ListingDetailsState>(
      listener: (context, state) {
        if (state is ListingDetailsTransientError) {
          context.showErrorSnackBar(state.message);
        }
        if (state is ListingOfferSubmittedState) {
          context.showSuccessSnackBar('Offer submitted');
        }
      },
      buildWhen: (prev, curr) =>
          curr is! ListingDetailsTransientError &&
          curr is! ListingOfferSubmittedState,
      builder: (context, state) {
        if (state is ListingDetailsInitialState ||
            state is ListingDetailsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ListingDetailsFailureState) {
          return _ErrorView(
            message: state.message,
            onRetry: () =>
                context.read<ListingDetailsCubit>().load(listingId),
          );
        }
        if (state is ListingDetailsLoadedState) {
          final l = state.listing;
          return RefreshIndicator(
            onRefresh: () =>
                context.read<ListingDetailsCubit>().refresh(listingId),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                _HeaderCard(listing: l),
                SizedBox(height: 14.h),
                if (l.description != null && l.description!.isNotEmpty) ...[
                  _SectionHeader(
                    icon: FontAwesomeIcons.fileLines,
                    title: 'Description',
                  ),
                  SizedBox(height: 8.h),
                  _DescriptionCard(text: l.description!),
                  SizedBox(height: 14.h),
                ],
                _SectionHeader(
                  icon: FontAwesomeIcons.circleInfo,
                  title: 'Details',
                ),
                SizedBox(height: 8.h),
                _DetailsCard(listing: l),
                SizedBox(height: 14.h),
                _SectionHeader(
                  icon: FontAwesomeIcons.user,
                  title: 'Owner',
                ),
                SizedBox(height: 8.h),
                _OwnerCard(name: l.createdByName),
                SizedBox(height: 18.h),
                if (state.canMakeOffer)
                  CustomButton(
                    title: 'Make Offer',
                    icon: Icons.gavel_outlined,
                    color: AppColors.accent,
                    onTap: () => _openOfferSheet(context, state),
                  ),
                if (state.isOwner) ...[
                  CustomButton(
                    title: 'View Offers (${l.offerCount})',
                    icon: Icons.list_alt_outlined,
                    color: AppColors.primary,
                    onTap: () => context.push(
                      Routes.listingOffers,
                      extra: l.id,
                    ),
                  ),
                ],
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final PropertyListingModel listing;
  const _HeaderCard({required this.listing});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return AppColors.success;
      case 'SOLD':
      case 'RENTED':
        return AppColors.info;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.primaryMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(listing.status);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: FaIcon(
                  listing.type.toUpperCase() == 'RENT'
                      ? FontAwesomeIcons.key
                      : FontAwesomeIcons.handshake,
                  color: AppColors.primary,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  listing.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  listing.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.dollarSign,
                size: 16.sp,
                color: AppColors.accent,
              ),
              SizedBox(width: 6.w),
              Text(
                listing.priceUsd.toCurrency(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainerLight,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  listing.type,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (listing.city != null && listing.city!.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.locationDot,
                  size: 11.sp,
                  color: AppColors.textTertiaryLight,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    [
                      if (listing.city != null) listing.city,
                      if (listing.neighborhood != null) listing.neighborhood,
                    ].whereType<String>().join(', '),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final String text;
  const _DescriptionCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp, height: 1.5),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final PropertyListingModel listing;
  const _DetailsCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          if (listing.areaSqm != null)
            _row(FontAwesomeIcons.rulerCombined, 'Area',
                '${listing.areaSqm!.toStringAsFixed(0)} m²'),
          if (listing.rooms != null)
            _row(FontAwesomeIcons.bed, 'Rooms', '${listing.rooms}'),
          if (listing.floor != null)
            _row(FontAwesomeIcons.layerGroup, 'Floor', '${listing.floor}'),
          _row(
            FontAwesomeIcons.envelopeOpenText,
            'Offers received',
            listing.offerCount.toString(),
          ),
          _row(
            FontAwesomeIcons.calendar,
            'Listed on',
            listing.createdAt.toLocal().formattedDate,
          ),
        ],
      ),
    );
  }

  Widget _row(FaIconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          FaIcon(icon, size: 12.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textTertiaryLight,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _OwnerCard extends StatelessWidget {
  final String name;
  const _OwnerCard({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              initial,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              name.isEmpty ? '—' : name,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final FaIconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 14.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
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
