import 'package:flutter/material.dart';
import 'package:takween/core/utils/extensions.dart';

Widget drawerItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  Widget? trailing,
}) {
  return ListTile(
    leading: Icon(icon, color: context.theme.textTheme.bodySmall!.color),
    title: Text(
      title,
      style: TextStyle(color: context.theme.textTheme.bodySmall!.color),
    ),
    trailing: trailing,
    onTap: onTap,
  );
}
