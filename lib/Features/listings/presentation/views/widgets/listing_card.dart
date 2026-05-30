import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/listings/data/models/listing_list_item_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class ListingCard extends StatelessWidget {
  final ListingListItemModel listing;
  final VoidCallback onTap;

  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
  });

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

  FaIconData _typeIcon(String type) {
    return type.toUpperCase() == 'RENT'
        ? FontAwesomeIcons.key
        : FontAwesomeIcons.handshake;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(listing.status);
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        padding: EdgeInsets.all(14.w),
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
                    _typeIcon(listing.type),
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainerLight,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              listing.type,
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          if (listing.city != null && listing.city!.isNotEmpty) ...[
                            FaIcon(
                              FontAwesomeIcons.locationDot,
                              size: 10.sp,
                              color: AppColors.textTertiaryLight,
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                listing.city!,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.textTertiaryLight,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    listing.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.dollarSign,
                  size: 12.sp,
                  color: AppColors.accent,
                ),
                SizedBox(width: 4.w),
                Text(
                  listing.priceUsd.toCurrency(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                const Spacer(),
                if (listing.areaSqm != null) ...[
                  FaIcon(
                    FontAwesomeIcons.rulerCombined,
                    size: 10.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${listing.areaSqm!.toStringAsFixed(0)} m²',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textTertiaryLight,
                    ),
                  ),
                ],
                if (listing.rooms != null) ...[
                  SizedBox(width: 10.w),
                  FaIcon(
                    FontAwesomeIcons.bed,
                    size: 10.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${listing.rooms} BR',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textTertiaryLight,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.envelopeOpenText,
                  size: 10.sp,
                  color: AppColors.textTertiaryLight,
                ),
                SizedBox(width: 4.w),
                Text(
                  '${listing.offerCount} offer${listing.offerCount == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
                const Spacer(),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 11.sp,
                  color: AppColors.primaryMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
