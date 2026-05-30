import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/core/data/shared_prefs_service.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/assets.dart';
import 'intro_onboarding_page.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingViewBody> {
  final PageController pageController = PageController();
  int currentPage = 0;
  bool isAnimationShown = false;

  void nextPage() async {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      final appPrefs = sl<AppPreferences>();
      await appPrefs.setFirstTimeFalse();

      if (!mounted) return;
      context.go(Routes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                currentPage = value;
              });
            },
            children: [
              IntroPage(
                image: AppAssets.kOnboardingImag1,
                title: AppStrings.onboardingTitle1.tr(),
                subtitle: AppStrings.onboardingSubtitle1.tr(),
              ),
              IntroPage(
                image: AppAssets.kOnboardingImag2,
                title: AppStrings.onboardingTitle2.tr(),
                subtitle: AppStrings.onboardingSubtitle2.tr(),
              ),
              IntroPage(
                image: AppAssets.kOnboardingImag3,
                title: AppStrings.onboardingTitle3.tr(),
                subtitle: AppStrings.onboardingSubtitle3.tr(),
              ),
            ],
          ),

          if (currentPage == 0 && !isAnimationShown)
            Center(
              child: Lottie.asset(
               AppAssets.kSwipLeft,
                onLoaded: (composition) {
                  Future.delayed(const Duration(seconds: 3), () {
                    setState(() {
                      isAnimationShown = true;
                    });
                  });
                },
              ),
            ),

          /// Bottom Section
          Positioned(
            bottom: 40.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.accent,
                    dotColor: isDark
                        ? AppColors.dividerDark
                        : AppColors.dividerLight,
                    dotHeight: 6.h,
                    dotWidth: 6.w,
                    expansionFactor: 3,
                  ),
                ),
                SizedBox(height: 25.h),

                /// Premium Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      currentPage == 2
                          ? AppStrings.getStarted.tr()
                          : AppStrings.next.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
