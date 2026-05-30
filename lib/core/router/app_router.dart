import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/authentication/presentation/views/signIn_view.dart';
import 'package:takween/Features/authentication/presentation/views/signUp_view.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_details/get_bid_details_cubit.dart';
import 'package:takween/Features/bid/presentation/views/bid_details_view.dart';
import 'package:takween/Features/bid/presentation/views/post_bids_view.dart';
import 'package:takween/Features/chat/presentation/viewmodels/chat/chat_cubit.dart';
import 'package:takween/Features/chat/presentation/views/chat_view.dart';
import 'package:takween/Features/contract/presentation/viewmodels/contract/contract_cubit.dart';
import 'package:takween/Features/contract/presentation/views/contract_view.dart';
import 'package:takween/Features/contractor/presentation/views/cost_settings_view.dart';
import 'package:takween/Features/listings/presentation/views/browse_listings_view.dart';
import 'package:takween/Features/listings/presentation/views/listing_details_view.dart';
import 'package:takween/Features/listings/presentation/views/listing_offers_view.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_project_details/get_project_details_cubit.dart';
import 'package:takween/Features/projects/presentation/views/project_details_view.dart';
import 'package:takween/Features/home/presentation/views/buyer/buyer_home_view.dart';
import 'package:takween/Features/home/presentation/views/contractor/contractor_home_view.dart';
import 'package:takween/Features/home/presentation/views/landowner/landowner_home_view.dart';
import 'package:takween/Features/maps/presentation/views/google_map_flutter.dart';
import 'package:takween/Features/onboarding/presentation/views/onboarding_view.dart';
import 'package:takween/Features/posts/presentation/views/edit_land_post_details_view.dart';
import 'package:takween/Features/posts/presentation/views/land_post_details_view.dart';
import 'package:takween/Features/splash/presentation/views/splash_view.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/router/route_transitions.dart';
import 'package:takween/Features/posts/presentation/views/post_view.dart';
import 'routes.dart';

class AppRouter {
  AppRouter._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    // redirect: (context, state) async {
    // final appPrefs = getIt<AppPreferences>();
    // final secureStorage = getIt<SecureStorageService>();
    // final bool isFirstTime = appPrefs.isFirstTime;
    // final bool isSignedIn = appPrefs.isSignedIn;
    // final String? token = await secureStorage.getToken();
    // final bool isSplash = state.matchedLocation == Routes.splash;
    // if (!isSplash) return null;
    // if (isFirstTime) {
    // return Routes.onBoarding;
    // }
    // if (!isFirstTime && isSignedIn && token != null) {
    // return Routes.home;
    // }
    // return Routes.signIn;
    // },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashView(),
      ),

      GoRoute(
        path: Routes.onBoarding,
        pageBuilder: (context, state) => RouteTransitions.slideTransition(
          state: state,
          child: const OnboardingView(),
        ),
      ),
      GoRoute(
        path: Routes.signIn,
        pageBuilder: (context, state) => RouteTransitions.slideTransition(
          state: state,
          child: const SigninView(),
        ),
      ),
      GoRoute(
        path: Routes.signUp,
        pageBuilder: (context, state) => RouteTransitions.slideTransition(
          state: state,
          child: const SignUpView(),
        ),
      ),
      GoRoute(
        path: Routes.landOwnerHome,
        pageBuilder: (context, state) => RouteTransitions.slideTransition(
          state: state,
          child: const LandOwnerHomeView(),
        ),
      ),
      GoRoute(
        path: Routes.post,
        pageBuilder: (context, state) => RouteTransitions.slideTransition(
          state: state,
          child: const PostView(),
        ),
      ),
      GoRoute(
        path: Routes.map,
        builder: (context, state) => const GoogleMapFlutter(),
      ),
    GoRoute(
  path: Routes.landPostDetails,
  pageBuilder: (context, state) {
    final data = state.extra as Map<String, dynamic>;

    return RouteTransitions.slideTransition(
      state: state,
      child: LandPostDetailsView(
        postId: data["postId"]as String,
        canEdit: data["canEdit"] ?? false,
        canDelete: data["canDelete"] ?? false,
        canViewBids: data["canViewBids"] ?? false,
      ),
    );
  },
),
      GoRoute(
        path: Routes.editLandPostDetails,
        pageBuilder: (context, state) => RouteTransitions.slideTransition(
          state: state,
          child: const EditLandPostDetailsView(),
        ),
      ),
      GoRoute(
        path: Routes.contractorHome,
        pageBuilder: (context, state) => RouteTransitions.slideTransition(
          state: state,
          child: const ContractorHomeView(),
        ),
      ),
      GoRoute(
        path: Routes.buyerHome,
        pageBuilder: (context, state) => RouteTransitions.slideTransition(
          state: state,
          child: const BuyerHomeView(),
        ),
      ),
      GoRoute(
        path: Routes.postBids,
        builder: (context, state) {
          final postId = state.extra as String;

          return PostBidsView(postId: postId);
        },
      ),

      GoRoute(
        path: Routes.bidDetails,
        builder: (context, state) {
          final bidId = state.extra as String;
          return BlocProvider(
            create: (_) => sl<GetBidDetailsCubit>(),
            child: BidDetailsView(bidId: bidId),
          );
        },
      ),
      GoRoute(
        path: Routes.chat,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final projectId = data['projectId'] as String;
          final projectTitle = (data['projectTitle'] as String?) ?? 'Chat';
          return BlocProvider(
            create: (_) => sl<ChatCubit>()..init(projectId),
            child: ChatView(
              projectId: projectId,
              projectTitle: projectTitle,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.contract,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final projectId = data['projectId'] as String;
          final projectTitle =
              (data['projectTitle'] as String?) ?? 'Project';
          return BlocProvider(
            create: (_) => sl<ContractCubit>()..load(projectId),
            child: ContractView(
              projectId: projectId,
              projectTitle: projectTitle,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.projectDetails,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final projectId = data['projectId'] as String;
          final projectTitle =
              (data['projectTitle'] as String?) ?? 'Project';
          return BlocProvider(
            create: (_) =>
                sl<GetProjectDetailsCubit>()..load(projectId),
            child: ProjectDetailsView(
              projectId: projectId,
              projectTitle: projectTitle,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.costSettings,
        builder: (context, state) => const CostSettingsView(),
      ),
      GoRoute(
        path: Routes.browseListings,
        builder: (context, state) => const BrowseListingsView(),
      ),
      GoRoute(
        path: Routes.listingDetails,
        builder: (context, state) {
          final id = state.extra as String;
          return ListingDetailsView(listingId: id);
        },
      ),
      GoRoute(
        path: Routes.listingOffers,
        builder: (context, state) {
          final id = state.extra as String;
          return ListingOffersView(listingId: id);
        },
      ),
    ],
  );
}
