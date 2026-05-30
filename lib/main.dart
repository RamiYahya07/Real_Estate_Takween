import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/notifications/presentation/viewmodels/notifications_cubit.dart';
import 'package:takween/app.dart';
import 'package:takween/bloc_observer.dart';
// import 'package:takween/core/data/shared_prefs_service.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/localization/localization_manager.dart';
import 'package:takween/core/network/dev_http_overrides.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = DevHttpOverrides();
  await initGetIt();
  // sl<AppPreferences>().clearAll();
  Bloc.observer = SimpleBlocObserver();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.translationsPath,
      fallbackLocale: LocalizationManager.fallbackLocale,
      // startLocale: LocalizationManager.fallbackLocale,
      child: const TakweenApp(),
    ),
  );
}
