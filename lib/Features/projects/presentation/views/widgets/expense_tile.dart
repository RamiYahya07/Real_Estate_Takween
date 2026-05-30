import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/expense_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseTile({super.key, required this.expense});

  FaIconData _categoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'MATERIALS':
        return FontAwesomeIcons.cubes;
      case 'LABOR':
        return FontAwesomeIcons.peopleGroup;
      case 'EQUIPMENT':
        return FontAwesomeIcons.truck;
      case 'FINISHING':
        return FontAwesomeIcons.paintRoller;
      case 'PERMITS':
        return FontAwesomeIcons.stamp;
      case 'OTHER':
      default:
        return FontAwesomeIcons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              _categoryIcon(expense.category),
              size: 14.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
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
                        expense.category.replaceAll('_', ' '),
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    FaIcon(
                      FontAwesomeIcons.calendar,
                      size: 10.sp,
                      color: AppColors.textTertiaryLight,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      expense.paidAt.toLocal().formattedDate,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            expense.amountUsd.toCurrency(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
