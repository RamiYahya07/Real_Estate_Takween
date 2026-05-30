import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/unit_model.dart';
import 'package:takween/core/theme/colors.dart';

class UnitTile extends StatelessWidget {
  final UnitModel unit;

  const UnitTile({super.key, required this.unit});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ALLOCATED':
        return AppColors.success;
      case 'AVAILABLE':
        return AppColors.info;
      default:
        return AppColors.primaryMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(unit.status);
    final isAllocated = unit.status.toUpperCase() == 'ALLOCATED';

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
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: FaIcon(
              FontAwesomeIcons.doorOpen,
              size: 16.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      unit.unitNumber,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (unit.unitType != null &&
                        unit.unitType!.isNotEmpty) ...[
                      SizedBox(width: 6.w),
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
                          unit.unitType!,
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.layerGroup,
                      size: 10.sp,
                      color: AppColors.textTertiaryLight,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Floor ${unit.floor}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textTertiaryLight,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    FaIcon(
                      FontAwesomeIcons.rulerCombined,
                      size: 10.sp,
                      color: AppColors.textTertiaryLight,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${unit.areaSqm.toStringAsFixed(0)} m²',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
                if (isAllocated &&
                    unit.allocatedToName != null &&
                    unit.allocatedToName!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.userCheck,
                        size: 10.sp,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          unit.allocatedToName!,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              unit.status.replaceAll('_', ' '),
              style: TextStyle(
                color: statusColor,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
