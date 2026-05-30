import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/feasibility/data/models/detailed_feasibility_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class DetailedFeasibilityResultCard extends StatelessWidget {
  final DetailedFeasibilityModel result;

  const DetailedFeasibilityResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final positive = result.netProfitUsd >= 0;
    final headlineColor = positive ? AppColors.success : AppColors.error;

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
                FontAwesomeIcons.chartPie,
                size: 14.sp,
                color: AppColors.accent,
              ),
              SizedBox(width: 8.w),
              Text(
                'Detailed Estimate',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: headlineColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Net Profit',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  result.netProfitUsd.toCurrency(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: headlineColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${result.profitMarginPercent.toStringAsFixed(1)}% margin',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.percent,
                  label: 'ROI',
                  value: '${result.roiPercent.toStringAsFixed(1)}%',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.chartLine,
                  label: 'IRR (annual)',
                  value: '${result.annualizedIRRPercent.toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.coins,
                  label: 'NPV',
                  value: result.npv.toCurrency(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.hammer,
                  label: 'Construction',
                  value: result.constructionCostUsd.toCurrency(),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.tag,
                  label: 'Gross Revenue',
                  value: result.grossRevenueUsd.toCurrency(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.buildingUser,
                  label: 'Units',
                  value: result.estimatedUnits.toString(),
                ),
              ),
            ],
          ),
          if (result.rentalAnalysis != null) ...[
            SizedBox(height: 14.h),
            Divider(color: theme.dividerColor.withValues(alpha: 0.4)),
            SizedBox(height: 8.h),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.house,
                  size: 12.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Rental Analysis',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    icon: FontAwesomeIcons.calendar,
                    label: 'Annual net',
                    value: result.rentalAnalysis!.annualNetIncomeUsd
                        .toCurrency(),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _Metric(
                    icon: FontAwesomeIcons.percent,
                    label: 'Cap rate',
                    value:
                        '${result.rentalAnalysis!.capRatePercent.toStringAsFixed(1)}%',
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    icon: FontAwesomeIcons.arrowTrendUp,
                    label: 'Gross yield',
                    value:
                        '${result.rentalAnalysis!.grossYieldPercent.toStringAsFixed(1)}%',
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _Metric(
                    icon: FontAwesomeIcons.arrowTrendDown,
                    label: 'Net yield',
                    value:
                        '${result.rentalAnalysis!.netYieldPercent.toStringAsFixed(1)}%',
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

class _Metric extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;

  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 12.sp, color: AppColors.primary),
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
