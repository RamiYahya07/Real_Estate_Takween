/// Application Constants
/// Centralized constant definitions
class AppConstants {
  AppConstants._();
}

// API Configuration
const String baseUrl = 'https://api.example.com';
const String apiVersion = 'v1';
const Duration kConnectionTimeout = Duration(seconds: 60);
const Duration kReceiveTimeout = Duration(seconds: 30);

// Storage Keys
const String kIsDarkMode = 'isDarkMode';
const String kIsFirstTime = 'isFirstTime';
const String kIsSignedIn = 'isSignedIn';
const String kAccessTokenKey = 'access_token';
const String kRefreshTokenKey = 'refresh_token';
const String kRole = 'role';
const String kUserId = 'user_id';
const String kUserName = 'user_name';
const String kLocaledCode = 'locale_code';

const String userDataKey = 'user_data';
const String themeKey = 'theme_mode';
const String languageKey = 'language_code';
const String onboardingKey = 'onboarding_completed';

// Pagination
const int defaultPageSize = 20;
const int maxPageSize = 100;

// Animation Durations
const Duration shortAnimationDuration = Duration(milliseconds: 200);
const Duration mediumAnimationDuration = Duration(milliseconds: 300);
const Duration longAnimationDuration = Duration(milliseconds: 500);

//Fonts
const String kPoppinsFont = 'Poppins';
const String kMontserratFont = 'Montserrat';
const String kPacificoFont = 'Pacifico';

// Spacing
const double spacingXS = 4.0;
const double spacingSM = 8.0;
const double spacingMD = 16.0;
const double spacingLG = 24.0;
const double spacingXL = 32.0;

// Border Radius
const double radiusSM = 4.0;
const double radiusMD = 8.0;
const double radiusLG = 12.0;
const double radiusXL = 16.0;
const double radiusRound = 999.0;

// Icon Sizes
const double iconSizeSM = 16.0;
const double iconSizeMD = 24.0;
const double iconSizeLG = 32.0;
const double iconSizeXL = 48.0;

// Image Sizes
const double avatarSizeSM = 32.0;
const double avatarSizeMD = 48.0;
const double avatarSizeLG = 64.0;
const double avatarSizeXL = 96.0;

// Validation
const int minPasswordLength = 8;
const int maxPasswordLength = 128;
const int minUsernameLength = 3;
const int maxUsernameLength = 30;

// File Upload
const int maxFileSize = 10 * 1024 * 1024; // 10 MB
const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
const List<String> allowedDocumentExtensions = ['pdf', 'doc', 'docx'];

// Date Formats
const String dateFormat = 'dd/MM/yyyy';
const String timeFormat = 'HH:mm';
const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

// Regular Expressions
final RegExp emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);
final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
final RegExp urlRegex = RegExp(
  r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
);

// Error Messages
const String genericErrorMessage = 'Something went wrong. Please try again.';
const String networkErrorMessage =
    'No internet connection. Please check your network.';
const String timeoutErrorMessage = 'Request timeout. Please try again.';
const String unauthorizedErrorMessage = 'Unauthorized. Please login again.';

// Actors
enum Roles { LandOwner, Contractor, Buyer, Investor }
Roles roleFromString(String? role) {
  switch (role) {
    case "LandOwner":
      return Roles.LandOwner;
    case "Contractor":
      return Roles.Contractor;
    case "Buyer":
      return Roles.Buyer;
    case "Investor":
      return Roles.Buyer;
    default:
      return Roles.Buyer; // fallback
  }
}


// Roles roleFromString(String? role) {
//   return Roles.values.firstWhere(
//     (e) => e.name == role,
//     orElse: () => Roles.guest,
//   );
// }

const ownershipMap = {
  "DIRECT_OWNERSHIP": 0,
  "INHERITED": 1,
  "COURT_ORDERED": 2,
  "PURCHASED_REGISTERED": 3,
  "PURCHASED_INFORMAL": 4,
};

const buildingTypeMap = {
  "RESIDENTIAL": 0,
  "COMMERCIAL": 1,
  "MIXED_USE": 2,
};

const investmentTypeMap = {
  "MUQASAMA": 0,
  "JOINT_INVESTMENT": 1,
  "DIRECT_SALE": 2,
  "SHARE_OFFERING": 3,
};

enum InvestmentType {
  muqasama,
  jointInvestment,
  directSale,
  shareOffering,
}
InvestmentType investmentTypeFromString(String type) {
  switch (type) {
    case "MUQASAMA":
      return InvestmentType.muqasama;
    case "JOINT_INVESTMENT":
      return InvestmentType.jointInvestment;
    case "DIRECT_SALE":
      return InvestmentType.directSale;
    case "SHARE_OFFERING":
      return InvestmentType.shareOffering;
    default:
      throw Exception("Unknown investment type: $type");
  }
}