import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/theme_cubit.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/utils/helper/dialog_helper.dart';
import 'package:takween/core/utils/helper/language_helper.dart';
import 'package:takween/core/widgets/app_footer.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_drawer_item.dart';
import 'package:takween/core/widgets/custom_switch_listTile.dart';
import 'package:takween/core/widgets/text_between_two_dividers.dart';

class LandOwnerDrawer extends StatelessWidget {
  final bool isContractor;

  const LandOwnerDrawer({super.key, this.isContractor = false});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Drawer(
      backgroundColor: context.theme.primaryColor,

      /// MENU
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 16),

          drawerItem(
            context,
            icon: Icons.home,
            title: AppStrings.home.tr().capitalize(),
            onTap: () {},
          ),

          const SizedBox(height: 6),

          drawerItem(
            context,
            icon: Icons.article,
            title: AppStrings.myPosts.tr().capitalizeWords(),
            onTap: () {},
          ),

          const SizedBox(height: 6),

          drawerItem(
            context,
            icon: Icons.notifications,
            title: AppStrings.notifications.tr().capitalizeWords(),
            onTap: () {},
          ),

          if (isContractor) ...[
            const SizedBox(height: 6),
            drawerItem(
              context,
              icon: Icons.calculate_outlined,
              title: 'Cost Settings',
              onTap: () {
                Navigator.of(context).maybePop();
                context.push(Routes.costSettings);
              },
            ),
          ],

          const SizedBox(height: 6),
          drawerItem(
            context,
            icon: Icons.home_work_outlined,
            title: 'Property Listings',
            onTap: () {
              Navigator.of(context).maybePop();
              context.push(Routes.browseListings);
            },
          ),

          const SizedBox(height: 20),

          TextBetweenTwoDividers(
            title: AppStrings.settings.tr().capitalize(),
            color: context.theme.colorScheme.secondary,
          ),

          const SizedBox(height: 14),

          drawerItem(
            context,
            icon: Icons.language,
            title: context.locale.languageCode == 'en'
                ? 'Arabic'
                : 'الانجليزية',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => LanguageService.toggle(context),
          ),

          const SizedBox(height: 6),

          CustomSwitchListTile(
            color: context.theme.colorScheme.secondary,
            leadingIcon: Icons.brightness_6_rounded,
            label: isDark
                ? AppStrings.lightMode.tr().capitalize()
                : AppStrings.darkMode.tr().capitalize(),
            value: isDark,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme(value);
            },
          ),

          const SizedBox(height: 6),

          drawerItem(
            context,
            icon: Icons.security,
            title: AppStrings.security.tr().capitalize(),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),

          const SizedBox(height: 6),

          drawerItem(
            context,
            icon: Icons.info,
            title: AppStrings.about.tr().capitalize(),
            onTap: () {},
          ),

          const SizedBox(height: 32),

          /// FOOTER SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              icon: Icons.logout_rounded,
              textColor: context.theme.colorScheme.error,
              title: AppStrings.logout.tr().capitalize(),
              color: context.theme.colorScheme.error.withOpacity(.1),
              onTap: () => confirmLogout(context),
            ),
          ),

          const SizedBox(height: 32),

          const AppFooter(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
