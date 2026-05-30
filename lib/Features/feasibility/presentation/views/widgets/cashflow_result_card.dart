import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/feasibility/data/models/cashflow_feasibility_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class CashflowResultCard extends StatelessWidget {
  final CashflowFeasibilityModel result;

  const CashflowResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final positive = result.netCashFlowUsd >= 0;
    final color = positive ? AppColors.success : AppColors.error;

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
                FontAwesomeIcons.moneyBillTrendUp,
                size: 14.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Real Cash Flow',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              if (result.paybackMonth != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Payback ${result.paybackMonth}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.arrowDown,
                  label: 'Total income',
                  value: result.totalIncomeUsd.toCurrency(),
                  color: AppColors.success,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.arrowUp,
                  label: 'Total expenses',
                  value: result.totalExpensesUsd.toCurrency(),
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.scaleBalanced,
                  label: 'Net cash flow',
                  value: result.netCashFlowUsd.toCurrency(),
                  color: color,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _Metric(
                  icon: FontAwesomeIcons.triangleExclamation,
                  label: 'Peak negative',
                  value: result.peakNegativeCashUsd.toCurrency(),
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          if (result.monthlyBreakdown.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Text(
              'Monthly breakdown',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8.h),
            for (final m in result.monthlyBreakdown)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 56.w,
                      child: Text(
                        m.month,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _MonthChip(
                            label: '+ ${m.incomeUsd.toCurrency()}',
                            color: AppColors.success,
                          ),
                          SizedBox(width: 4.w),
                          _MonthChip(
                            label: '- ${m.expensesUsd.toCurrency()}',
                            color: AppColors.error,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      m.cumulativeCashFlow.toCurrency(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: m.cumulativeCashFlow >= 0
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
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
  final Color color;

  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
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
                    color: color,
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

class _MonthChip extends StatelessWidget {
  final String label;
  final Color color;

  const _MonthChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
