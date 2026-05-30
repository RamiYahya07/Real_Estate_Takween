
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageService {
  static void toggle(BuildContext context) {
    final current = context.locale.languageCode;

    if (current == 'en') {
      context.setLocale(const Locale('ar'));
    } else {
      context.setLocale(const Locale('en'));
    }
  }
}