import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/core/data/shared_prefs_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
    final AppPreferences prefs;

  ThemeCubit(this.prefs) : super(ThemeMode.light) {
    _loadTheme(); // Load saved theme on init
  }

void toggleTheme(bool value) async {
  final newTheme = value ? ThemeMode.dark : ThemeMode.light;

  await prefs.setDarkMode(value);

  emit(newTheme);
}

void _loadTheme() {
  final isDark = prefs.isDarkMode;
  emit(isDark ? ThemeMode.dark : ThemeMode.light);
}
}
