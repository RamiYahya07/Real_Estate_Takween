import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:takween/Features/home/presentation/views/landowner/widgets/landowner_drawer.dart';
import 'package:takween/Features/notifications/presentation/views/widgets/notification_bell.dart';
import 'package:takween/Features/posts/presentation/views/myPosts_landOwner_view.dart';
import 'package:takween/Features/profile/presentation/views/profile_view.dart';
import 'package:takween/Features/projects/presentation/views/my_projects_view.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/extensions.dart';

import 'widgets/landowner_home_view_body.dart';

class LandOwnerHomeView extends StatefulWidget {
  const LandOwnerHomeView({super.key});

  @override
  State<LandOwnerHomeView> createState() => _LandOwnerHomeViewState();
}

class _LandOwnerHomeViewState extends State<LandOwnerHomeView> {
  int index = 0;

  final pages = const [
    LandownerHomeViewBody(),
    MypostsLandownerView(),
    MyProjectsView(),
    ProfileView(),
  ];

  final titles = [
    AppStrings.home.tr().capitalize(),
    AppStrings.myPosts.tr().capitalizeWords(),
    'Projects',
    AppStrings.profile.tr().capitalize(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]),
        actions: const [
          NotificationBell(),
        ],
      ),

      drawer: index == 0 ? const LandOwnerDrawer() : null,

      body: pages[index],

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (value) {
        setState(() => index = value);
      },
      height: 60,
      destinations: [
        _navItem(
          Icons.dashboard_outlined,
          Icons.dashboard_rounded,
          AppStrings.home.tr().capitalize(),
          0,
        ),
        _navItem(
          Icons.article_outlined,
          Icons.article,
          AppStrings.myPosts.tr().capitalizeWords(),
          1,
        ),
        _navItem(
          Icons.business_center_outlined,
          Icons.business_center,
          'Projects',
          2,
        ),
        _navItem(
          Icons.person_outline_rounded,
          Icons.person_rounded,
          AppStrings.profile.tr().capitalize(),
          3,
        ),
      ],
    );
  }

  NavigationDestination _navItem(
    IconData unselected,
    IconData selected,
    String label,
    int itemIndex,
  ) {
    final isSelected = index == itemIndex;

    return NavigationDestination(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          // Combines Scale and 360-degree Rotation
          return ScaleTransition(
            scale: animation,
            child: RotationTransition(
              turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: Icon(
          isSelected ? selected : unselected,
          key: ValueKey(isSelected),
        ),
      ),
      label: label,
    );
  }
}