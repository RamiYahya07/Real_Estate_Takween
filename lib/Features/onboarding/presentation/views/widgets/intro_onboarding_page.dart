//checked
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/core/theme/colors.dart';

class IntroPage extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;

  const IntroPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha:0.4),
                      blurRadius: 12.r,
                      spreadRadius: 3.r,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset(
                    widget.image,
                    width: 280.w,
                    height: 280.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              AnimatedOpacity(
                duration:const Duration(seconds: 1),
                opacity: _opacity,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                 
                    color:AppColors.textPrimaryLight,
                    letterSpacing: 1.2,
                    height: 1.5.h,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1200),
                opacity: _opacity,
                child: Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    
                    color: AppColors.textSecondaryLight,
                    letterSpacing: 1.1,
                    height: 1.5.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
