import 'package:flutter/material.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/constants.dart';

class DarkTheme {
  DarkTheme._();

  static ThemeData theme = ThemeData(
    fontFamily: kPoppinsFont,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primarySoft,
        //
      textTheme: const TextTheme(
    bodyLarge: TextStyle(fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontWeight: FontWeight.w600),
            bodySmall: TextStyle(color: AppColors.textQuaternaryDark),

  ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primarySoft,
      secondary: AppColors.accent,
      surface: AppColors.surfaceDark,
      error: AppColors.errorDark,
      onPrimary: Colors.white,
      onSurface: AppColors.textPrimaryDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      elevation: 0,
      centerTitle: true,
    ),

    cardColor: AppColors.surfaceRaisedDark,
    dividerColor: AppColors.dividerDark,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primarySoft,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.accent),
      ),
      hintStyle: const TextStyle(color: AppColors.textQuaternaryDark),
    ),
  );
}