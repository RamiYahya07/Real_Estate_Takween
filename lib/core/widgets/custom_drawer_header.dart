import 'package:flutter/material.dart';
import 'package:takween/core/utils/assets.dart';
import 'package:takween/core/utils/extensions.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        color: context.theme.textTheme.bodySmall!.color,
      ),
      child: Image.asset(
        AppAssets.kLogoIcon,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}
