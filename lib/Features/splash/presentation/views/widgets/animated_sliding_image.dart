
import 'package:flutter/material.dart';
import 'package:takween/core/utils/assets.dart';

class AnimatedSlidingImage extends StatelessWidget {
  const AnimatedSlidingImage({
    super.key,
    required this.slidingAnimation,
  });

  final Animation<Offset> slidingAnimation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: slidingAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: slidingAnimation,
            child: child,
          );
        },
        child: Image.asset(AppAssets.kBuildingImage),
      ),
    );
  }
}