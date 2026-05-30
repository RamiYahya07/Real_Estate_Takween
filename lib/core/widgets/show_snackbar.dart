import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showSnackBar(
  BuildContext context,
  String message,
  Color backgroundColor, {
  IconData icon = Icons.check_circle_outline,
  Duration duration = const Duration(seconds: 3),
}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: backgroundColor,
    elevation: 6,
    duration: duration,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
    ),
    content: Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
