import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/data/shared_prefs_service.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/services/auth_service.dart';
import 'package:takween/core/utils/constants.dart';
import 'animated_fading_logo.dart';
import 'animated_sliding_image.dart';
import 'curved_widget.dart';
import 'splash_background.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;
  late Animation<double> fadingAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
          ),
        );
    fadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    animationController.forward();
    _checkUser();
  }

  Future<void> _checkUser() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    final appPrefs = sl<AppPreferences>();
    final secureStorage = sl<SecureStorageService>();

    final bool isFirstTime = appPrefs.isFirstTime;
    final bool isSignedIn = appPrefs.isSignedIn;
    final String? token = await secureStorage.getToken();
    final String? roleString = await secureStorage.getRole();
    final Roles role = roleFromString(roleString);

    if (!mounted) return;

    if (isFirstTime) {
      context.go(Routes.onBoarding);
    } else if (isSignedIn && token != null) {
      switch (role) {
        case Roles.Contractor:
          print("dkfj");
        default:
          print("");
      }
      debugPrint('Token issss: $token \n ');
      debugPrint('isSignedIn: $isSignedIn');

//! don't forget to edit it
  AuthService.navigateByRole(context, roleString);
    } else {
      debugPrint('isSignedIn: $isSignedIn');
      debugPrint('Token: $token');
      context.go(Routes.signIn);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SplashBackground(),
          const Align(alignment: Alignment.bottomCenter, child: CurvedWidget()),
          AnimatedSlidingImage(slidingAnimation: slidingAnimation),
          AnimatedFadingLogo(fadingAnimation: fadingAnimation),
        ],
      ),
    );
  }
}
