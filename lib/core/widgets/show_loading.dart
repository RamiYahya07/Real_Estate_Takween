import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:takween/core/utils/assets.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    this.height,
    this.width,
    this.loadingAnimation,
  });
  final double? height, width;
  final String? loadingAnimation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width ?? 200.w,
        height: height ?? 200.h,
        child: Lottie.asset(loadingAnimation??AppAssets.kCityScape),
      ),
    );
  }
}
