import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/milestone_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class MilestoneTile extends StatelessWidget {
  final MilestoneModel milestone;
  final bool isUpdating;
  final VoidCallback? onTap;

  const MilestoneTile({
    super.key,
    required this.milestone,
    this.isUpdating = false,
    this.onTap,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'VERIFIED':
        return AppColors.success;
      case 'COMPLETED':
        return AppColors.warning;
      case 'IN_PROGRESS':
        return AppColors.info;
      case 'PENDING':
      default:
        return AppColors.primaryMuted;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'VERIFIED':
        return Icons.verified_outlined;
      case 'COMPLETED':
        return Icons.check_circle_outline;
      case 'IN_PROGRESS':
        return Icons.hourglass_top_outlined;
      case 'PENDING':
      default:
        return Icons.pending_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(milestone.status??'');
    final hasDescription =
        milestone.description != null && milestone.description!.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: isUpdating ? null : onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                _statusIcon(milestone.status??''),
                size: 20.sp,
                color: statusColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          '#${milestone.orderIndex }',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          milestone.title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (hasDescription) ...[
                    SizedBox(height: 4.h),
                    Text(
                      milestone.description!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textTertiaryLight,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          milestone.status?.replaceAll('_', ' ') ?? '',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      FaIcon(
                        FontAwesomeIcons.calendar,
                        size: 9.sp,
                        color: AppColors.textTertiaryLight,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        milestone.createdAt.toLocal().formattedDate,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppColors.textTertiaryLight,
                        ),
                      ),
                      if (milestone.completedAt != null) ...[
                        SizedBox(width: 8.w),
                        FaIcon(
                          FontAwesomeIcons.circleCheck,
                          size: 9.sp,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          milestone.completedAt!.toLocal().formattedDate,
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (isUpdating)
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            else if (onTap != null)
              FaIcon(
                FontAwesomeIcons.chevronRight,
                size: 11.sp,
                color: AppColors.primaryMuted,
              ),
          ],
        ),
      ),
    );
  }
}
