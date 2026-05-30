import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/share_listing_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class ShareListingTile extends StatelessWidget {
  final ShareListingModel listing;
  final bool isProcessing;
  final bool canBuy;
  final bool canCancel;
  final VoidCallback? onBuy;
  final VoidCallback? onCancel;

  const ShareListingTile({
    super.key,
    required this.listing,
    required this.isProcessing,
    required this.canBuy,
    required this.canCancel,
    this.onBuy,
    this.onCancel,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return AppColors.info;
      case 'SOLD':
        return AppColors.success;
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
    final isOpen = listing.status.toUpperCase() == 'OPEN';
    final initial = listing.sellerName.isEmpty
        ? '?'
        : listing.sellerName[0].toUpperCase();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  initial,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.sellerName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Listed ${listing.createdAt.toLocal().formattedDate}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  listing.status.replaceAll('_', ' '),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: FontAwesomeIcons.layerGroup,
                  label: 'Shares',
                  value: listing.shareCount.toString(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _Stat(
                  icon: FontAwesomeIcons.tag,
                  label: 'Per share',
                  value: listing.pricePerShareUsd.toCurrency(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _Stat(
                  icon: FontAwesomeIcons.dollarSign,
                  label: 'Total',
                  value: listing.totalPriceUsd.toCurrency(),
                ),
              ),
            ],
          ),
          if (isOpen && (canBuy || canCancel)) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                if (canBuy)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isProcessing ? null : onBuy,
                      icon: isProcessing
                          ? SizedBox(
                              width: 14.w,
                              height: 14.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.shopping_cart_outlined),
                      label: const Text('Buy'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                if (canBuy && canCancel) SizedBox(width: 8.w),
                if (canCancel)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isProcessing ? null : onCancel,
                      icon: const Icon(Icons.close),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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

class _Stat extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;

  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, size: 11.sp, color: AppColors.primary),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
