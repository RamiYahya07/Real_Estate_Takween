import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/posts/data/models/land_post_item_model.dart';
import 'package:takween/Features/posts/presentation/views/widgets/info_item_widget.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/constants.dart';
import 'package:takween/core/utils/extensions.dart';

class LandPostCard extends StatelessWidget {
  final LandPostItemModel item;
  
final Roles viewerType;
  /// optional action button
  final Widget? action;

  /// refresh callback
  final VoidCallback? onReturned;

  const LandPostCard({
    super.key,
     required this.viewerType,
    required this.item,
    this.action,
    this.onReturned,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await context.push(
          Routes.landPostDetails,
          extra: {
      "postId": item.id,
            "canEdit": viewerType == Roles.LandOwner,
      "canDelete": viewerType == Roles.LandOwner,
      "canViewBids": viewerType == Roles.LandOwner,
    },
        );

        if (result == true) {
          onReturned?.call();
        }
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (action != null) ...[
                    action!,
                    SizedBox(width: 8.w),
                  ],

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: item.status.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      item.status.displayName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: item.status.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              /// LOCATION
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      '${item.city}, ${item.neighborhood}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              /// INFO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  infoItem(
                    icon: Icons.square_foot,
                    value: '${item.areaSqm} m²',
                  ),
                  infoItem(
                    icon: Icons.home_work,
                    value: item.desiredBuildingType,
                  ),
                  infoItem(
                    icon: Icons.gavel,
                    value: '${item.bidCount} bids',
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              /// FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.priceUsd != null
                        ? '\$${item.priceUsd!.toStringAsFixed(0)}'
                        : 'N/A',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),

                  Text(
                    item.investmentType.displayName,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}