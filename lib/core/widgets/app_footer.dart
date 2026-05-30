
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/core/utils/extensions.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        textAlign: TextAlign.center,
        "Takween Platform v1.0.0 \n© 2026 Takween. All rights reserved.",
        style: TextStyle(
          color: context.theme.textTheme.bodySmall!.color,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
