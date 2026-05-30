import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/authentication/data/repos/auth_repo.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/realtime/hub_client.dart';
import 'package:takween/core/router/app_router.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/utils/constants.dart';



class AuthService {
  static bool _isLoggingOut = false;

  static Future<void> logout() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;

    try {
      try {
        await sl<HubClient>(instanceName: kChatHubInstance).disconnect();
      } catch (_) {}
      try {
        await sl<HubClient>(instanceName: kBiddingHubInstance).disconnect();
      } catch (_) {}
      try {
        await sl<HubClient>(instanceName: kNotificationHubInstance).disconnect();
      } catch (_) {}

      await sl<AuthRepo>().logout();

      AppRouter.router.go(Routes.signIn);
    } finally {
      _isLoggingOut = false;
    }
  }


 static void navigateByRole(BuildContext context, String? roleString) {
  final role = roleFromString(roleString);
  switch (role) {
    case Roles.LandOwner:
      context.go(Routes.landOwnerHome);
      break;

    case Roles.Contractor:
      context.go(Routes.contractorHome);
      break;

    case Roles.Buyer:
      context.go(Routes.buyerHome);
      break;

    case Roles.Investor:
      context.go(Routes.buyerHome);
      break;
  }
}
}

// class AuthService {
//   static Future<void> logout() async {
//     await sl<AuthRepo>().logout();

//     AppRouter.navigatorKey.currentState?.pushNamedAndRemoveUntil(
//       Routes.signIn,
//       (route) => false,
//     );
//   }
// }