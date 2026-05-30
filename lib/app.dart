import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takween/Features/authentication/presentation/viewmodel/create_account/create_account_cubit.dart';
import 'package:takween/Features/authentication/presentation/viewmodel/sign_in/sign_in_cubit.dart';
import 'package:takween/Features/notifications/presentation/viewmodels/notifications_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_land_post/get_land_posts_cubit.dart';
import 'package:takween/core/data/shared_prefs_service.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/router/app_router.dart';
import 'package:takween/core/theme/dark_theme.dart';
import 'package:takween/core/theme/light_theme.dart';
import 'package:takween/core/theme/theme_cubit.dart';
import 'package:takween/Features/profile/presentation/viewmodels/profile_cubit.dart';

class TakweenApp extends StatelessWidget {
  const TakweenApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<SignInCubit>()),
            BlocProvider(create: (_) => ThemeCubit(sl<AppPreferences>())),

            BlocProvider(create: (_) => sl<CreateAccountCubit>()),
            BlocProvider(create: (_) => sl<ProfileCubit>()),
            BlocProvider(create: (_) => sl<GetLandPostsCubit>()),
            // BlocProvider(create: (_) => sl<NotificationsCubit>()..start()),
            // BlocProvider(create: (_) => sl<GetOpenLandPostsCubit>()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: LightTheme.theme,
                darkTheme: DarkTheme.theme,
                themeMode: themeMode,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                routerConfig: AppRouter.router,
              );
            },
          ),
        );
      },
    );
  }
}
