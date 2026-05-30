import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors.dart';

Widget infoItem({required IconData icon, required String value}) {
  return Row(
    children: [
      Icon(icon, size: 14.sp, color: AppColors.primaryMuted),
      SizedBox(width: 4.w),
      Text(
        value,
        style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondaryLight),
      ),
    ],
  );
}