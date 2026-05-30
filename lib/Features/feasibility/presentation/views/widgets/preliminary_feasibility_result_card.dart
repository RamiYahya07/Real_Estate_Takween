import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/feasibility/data/models/preliminary_feasibility_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class PreliminaryFeasibilityResultCard extends StatelessWidget {
  final PreliminaryFeasibilityModel result;

  const PreliminaryFeasibilityResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.chartLine,
                size: 14.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Estimate',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _MetricCell(
                  icon: FontAwesomeIcons.rulerCombined,
                  label: 'Land',
                  value: '${result.landAreaSqm.toStringAsFixed(0)} m²',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _MetricCell(
                  icon: FontAwesomeIcons.layerGroup,
                  label: 'Floors',
                  value: result.maxFloors.toString(),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _MetricCell(
                  icon: FontAwesomeIcons.building,
                  label: 'Buildable',
                  value: '${result.totalBuildableAreaSqm.toStringAsFixed(0)} m²',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _MetricCell(
                  icon: FontAwesomeIcons.tag,
                  label: 'Sellable',
                  value: '${result.totalSellableAreaSqm.toStringAsFixed(0)} m²',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _MetricCell(
                  icon: FontAwesomeIcons.buildingUser,
                  label: 'Est. Units',
                  value: result.estimatedUnits.toString(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _MetricCell(
                  icon: FontAwesomeIcons.dollarSign,
                  label: 'Gross Revenue',
                  value: result.estimatedGrossRevenueUsd.toCurrency(),
                  highlight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _MetricCell({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = highlight
        ? AppColors.success.withValues(alpha: 0.08)
        : AppColors.primaryContainerLight.withValues(alpha: 0.6);
    final color = highlight ? AppColors.success : AppColors.primary;
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 12.sp, color: color),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: highlight ? AppColors.success : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
