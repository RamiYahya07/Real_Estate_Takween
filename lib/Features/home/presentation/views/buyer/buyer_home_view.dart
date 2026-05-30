import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/home/presentation/views/landowner/widgets/landowner_drawer.dart';
import 'package:takween/Features/investments/presentation/views/invest_view.dart';
import 'package:takween/Features/notifications/presentation/views/widgets/notification_bell.dart';
import 'package:takween/Features/listings/presentation/viewmodels/browse_listings/browse_listings_cubit.dart';
import 'package:takween/Features/listings/presentation/views/my_offers_view.dart';
import 'package:takween/Features/listings/presentation/views/widgets/browse_listings_view_body.dart';
import 'package:takween/Features/profile/presentation/views/profile_view.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_my_projects/get_my_projects_cubit.dart';
import 'package:takween/Features/projects/presentation/views/widgets/my_projects_view_body.dart';
import 'package:takween/Features/statistics/presentation/views/widgets/dashboard_view.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/extensions.dart';

class BuyerHomeView extends StatefulWidget {
  const BuyerHomeView({super.key});

  @override
  State<BuyerHomeView> createState() => _BuyerHomeViewState();
}

class _BuyerHomeViewState extends State<BuyerHomeView> {
  int index = 0;

  final pages = const [
    DashboardView(),
    _MarketplaceTab(),
      _MyProjectsTab(),
    InvestView(),
    MyOffersView(),
    ProfileView(),
  ];

  final titles = [
    AppStrings.home.tr().capitalize(),
    'Marketplace',
    'Invest',
    'My Offers',
    AppStrings.profile.tr().capitalize(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]),
        actions: const [NotificationBell()],
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
        _navItem(Icons.home_work_outlined, Icons.home_work, 'Market', 1),
        _navItem(Icons.work_outline, Icons.work, 'Projects', 2),
_navItem(Icons.trending_up_outlined, Icons.trending_up, 'Invest', 3),
_navItem(Icons.local_offer_outlined, Icons.local_offer, 'My Offers', 4),
        _navItem(
          Icons.person_outline_rounded,
          Icons.person_rounded,
          AppStrings.profile.tr().capitalize(),
          5,
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

class _MarketplaceTab extends StatelessWidget {
  const _MarketplaceTab();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BrowseListingsCubit>(),
      child: const BrowseListingsViewBody(),
    );
  }
}
class _MyProjectsTab extends StatelessWidget {
  const _MyProjectsTab();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GetMyProjectsCubit>()..load(),
      child: const MyProjectsViewBody(),
    );
  }
}