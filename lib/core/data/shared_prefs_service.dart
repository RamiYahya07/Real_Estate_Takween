import 'package:shared_preferences/shared_preferences.dart';
import 'package:takween/core/utils/constants.dart';

class AppPreferences {
  final SharedPreferences prefs;

  AppPreferences(this.prefs);

  ///  Dark Mode
  bool get isDarkMode => prefs.getBool(kIsDarkMode) ?? false;

  Future<void> setDarkMode(bool value) => prefs.setBool(kIsDarkMode, value);

  Future<void> toggleDarkMode() async {
    final current = isDarkMode;
    await setDarkMode(!current);
  }

  /// Language
String get localeCode => prefs.getString(kLocaledCode) ?? 'en';
  Future<void> setLocaleCode(String value) =>
      prefs.setString(kLocaledCode, value);

  ///  First Time (OnBoarding)
  bool get isFirstTime => prefs.getBool(kIsFirstTime) ?? true;

  Future<void> setFirstTimeFalse() => prefs.setBool(kIsFirstTime, false);

  ///  Signed In Flag
  bool get isSignedIn => prefs.getBool(kIsSignedIn) ?? false;

  Future<void> setSignedIn(bool value) => prefs.setBool(kIsSignedIn, value);

  /// UserName
  String get userName => prefs.getString(kUserName) ?? "";
  Future<void> setUserName(String value) => prefs.setString(kUserName, value);

  ///  Clear All Preferences
  Future<void> clearAll() => prefs.clear();
}
