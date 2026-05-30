import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/core/theme/colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final double? height;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    this.textColor,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final buttonColor = color ?? colorScheme.primary;
    final buttonTextColor = textColor ?? colorScheme.onPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          height: height ?? 50.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: buttonColor,
            boxShadow: [
              BoxShadow(
                color: buttonColor.withValues(alpha: 0.1),
                blurRadius: 25,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ICON
                if (icon != null) ...[
                  Icon(icon, color: buttonTextColor, size: 20.sp),
                  SizedBox(width: 8.w),
                ],

                /// TEXT
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: buttonTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Optional factory for circular button if needed
  static ElevatedButton circularButton({
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.primary,
    double horizontalPadding = 100,
    double verticalPadding = 15,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding.w,
          vertical: verticalPadding.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
