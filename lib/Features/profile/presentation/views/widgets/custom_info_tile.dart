import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInfoTile extends StatelessWidget {
  const CustomInfoTile({
    super.key,
    required this.isEditing,
    required this.label,
    required this.controller,
    this.isEnable = true,
    this.hideTextWhenNotEditing = false,
  });

  final bool isEditing;
  final bool isEnable;
  final bool hideTextWhenNotEditing;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isEditing && hideTextWhenNotEditing) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label
          Text(
            label.toUpperCase(),
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
              letterSpacing: 1.1,
            ),
          ),

          SizedBox(height: 4.h),

          /// Field
          isEditing
              ? TextField(
                  controller: controller,
                  enabled: isEnable,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                )
              : Text(
                  controller.text.isEmpty ? '-' : controller.text,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

          Divider(height: 20.h),
        ],
      ),
    );
  }
}