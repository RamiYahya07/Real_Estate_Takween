import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/share_allocation_model.dart';
import 'package:takween/core/theme/colors.dart';

class ShareAllocationTile extends StatelessWidget {
  final ShareAllocationModel allocation;

  const ShareAllocationTile({super.key, required this.allocation});

  Color _roleColor(String role) {
    switch (role.toUpperCase()) {
      case 'LANDOWNER':
        return AppColors.primary;
      case 'CONTRACTOR':
        return AppColors.info;
      case 'INVESTOR':
        return AppColors.accent;
      default:
        return AppColors.primaryMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roleColor = _roleColor(allocation.role);
    final initial =
        allocation.userName.isEmpty ? '?' : allocation.userName[0].toUpperCase();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
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
            backgroundColor: roleColor.withValues(alpha: 0.15),
            child: Text(
              initial,
              style: TextStyle(
                color: roleColor,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allocation.userName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
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
                        color: roleColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        allocation.role.replaceAll('_', ' '),
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: roleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    if (allocation.contributionType.isNotEmpty)
                      Flexible(
                        child: Text(
                          allocation.contributionType.replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textTertiaryLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.layerGroup,
                    size: 10.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${allocation.shareCount}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                '${allocation.percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
