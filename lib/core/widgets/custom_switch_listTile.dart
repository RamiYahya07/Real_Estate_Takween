import 'package:flutter/material.dart';


class CustomSwitchListTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? color;
  final IconData? leadingIcon;

  const CustomSwitchListTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.color,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    // final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return SwitchListTile(
      activeThumbColor: color,
      secondary: leadingIcon != null
          ? Icon(
              leadingIcon,
              color: Theme.of(context).textTheme.bodySmall!.color,
            )
          : null,
      title: Text(
        label,
        style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
