import 'package:flutter/material.dart';
import 'package:takween/core/utils/assets.dart';

class AnimatedFadingLogo extends StatelessWidget {
  const AnimatedFadingLogo({
    super.key,
    required this.fadingAnimation,
  });

  final Animation<double> fadingAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadingAnimation,
      builder: (context, _) {
        return FadeTransition(
          opacity: fadingAnimation,
          child: Center(
            child: Image.asset(AppAssets.kLogoIcon, height: 250),
          ),
        );
      },
    );
  }
}
