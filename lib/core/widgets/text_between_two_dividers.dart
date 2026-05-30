import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/extensions.dart';

class TextBetweenTwoDividers extends StatelessWidget {
  const TextBetweenTwoDividers({super.key, this.title, this.color});
  final String? title;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color ?? Theme.of(context).dividerColor,
            thickness: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title ?? AppStrings.or.tr().capitalize(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  color ??
                  Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: color ?? Theme.of(context).dividerColor,
            thickness: 1.5,
          ),
        ),
      ],
    );
  }
}
