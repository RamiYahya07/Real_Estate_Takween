/// Application Configuration
enum Environment { development, staging, production }

class AppConfig {
  AppConfig._();

  static const String appName = 'Takween App';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  static const Environment environment = Environment.development;

  // Environment
  static bool get isProduction => environment == Environment.production;
  static bool get enableLogging => !isProduction;

  // API Configuration
  static String get baseUrl {
    switch (environment) {
      case Environment.production:
        return 'https://api.production.com';
      case Environment.staging:
        return 'https://api.staging.com';
      case Environment.development:
        return 'https://api.development.com';
    }
  }

}
