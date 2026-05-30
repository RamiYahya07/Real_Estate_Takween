import 'package:flutter/material.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class CurvedWidget extends StatelessWidget {
  const CurvedWidget({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
        height: context.screenHeight * 0.35,
        color: color ?? AppColors.primaryContainerDark,
      ),
    );
  }
}

// Custom Curve Clipper
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 80);

    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
