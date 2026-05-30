import 'package:flutter/material.dart';
import 'package:takween/core/theme/colors.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundLight,
            AppColors.primaryContainerLight,
            AppColors.accent.withValues(alpha: 0.6),
          ],
        ),
      ),
    );
  }
}
