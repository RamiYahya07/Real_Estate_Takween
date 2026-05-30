import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:takween/core/services/auth_service.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';

/// Logout Confirmation Dialog
void confirmLogout(BuildContext context) {
  final theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(   
      backgroundColor: theme.colorScheme.surface,
      title: Text(AppStrings.logout.tr(), style: theme.textTheme.titleMedium),
      content: Text(
        AppStrings.logoutMessage.tr(),
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.cancel.tr(),
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        CustomButton(
          color: theme.colorScheme.error,
          title: AppStrings.logout.tr().capitalize(),
          onTap: () async {
            Navigator.pop(context);

            // await sl<AuthRepo>().logout();
           await AuthService.logout();
            // if (context.mounted) {
            //   context.go(Routes.signIn);
            // }
          },
        ),
      ],
    ),
  );
}
