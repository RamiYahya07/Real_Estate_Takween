import 'package:flutter/material.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/widgets/show_snackbar.dart';

import 'package:takween/core/widgets/show_loading.dart';
import 'package:takween/core/utils/assets.dart';

extension DialogExtensions on BuildContext {
  static bool _isDialogOpen = false;

  void showLoading({String? animation}) {
    if (DialogExtensions._isDialogOpen) return;

    DialogExtensions._isDialogOpen = true;

    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => LoadingDialog(
        loadingAnimation: animation ?? AppAssets.kSandyLoading,
      ),
    );
  }

  void hideLoading() {
    if (DialogExtensions._isDialogOpen) {
      Navigator.of(this, rootNavigator: true).pop();
      DialogExtensions._isDialogOpen = false;
    }
  }
}
extension LandPostStatusExtension on String {
  Color get statusColor {
    switch (this) {
      case 'OPEN':
        return AppColors.success;
      case 'DRAFT':
        return AppColors.warning;
      case 'CLOSED':
        return AppColors.error;
      default:
        return AppColors.primaryMuted;
    }
  }


  String get displayName {
    return replaceAll('_', ' ').capitalizeWords();
  }
}
/// String Extensions
extension StringExtension on String {
  /// Capitalizes first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes first letter of each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Checks if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(this);
  }

  /// Checks if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Removes all whitespace from string
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Truncates string to specified length with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }
}

/// Context Extensions
extension ContextExtension on BuildContext {
  /// Returns MediaQuery size
  Size get screenSize => MediaQuery.of(this).size;

  /// Returns screen width
  double get screenWidth => screenSize.width;

  /// Returns screen height
  double get screenHeight => screenSize.height;

  /// Returns current theme
  ThemeData get theme => Theme.of(this);

  /// Returns text theme
  TextTheme get textTheme => theme.textTheme;

  /// Returns color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Returns if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;



  //  Shows snackbar with message
  void showSnackBarMessage(
    String message, {
    Duration duration = const Duration(seconds: 3),
    IconData icon = Icons.info_outline,
    Color backgroundColor = Colors.black87,
  }) {
    showSnackBar(
      this,
      message,
      backgroundColor,
      icon: icon,
      duration: duration,
    );
  }

  void showErrorSnackBar(String message) {
    showSnackBar(
      this,
      message,
      AppColors.error,
      icon: Icons.error_outline,
      duration: const Duration(seconds: 4),
    );
  }

  void showSuccessSnackBar(String message) {
    showSnackBar(
      this,
      message,
      AppColors.success,
      icon: Icons.check_circle_outline,
      duration: const Duration(seconds: 3),
    );
  }

  /// Hides keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

/// DateTime Extensions
extension DateTimeExtension on DateTime {
  /// Formats date as 'dd/MM/yyyy'
  String get formattedDate {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Formats time as 'HH:mm'
  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Formats datetime as 'dd/MM/yyyy HH:mm'
  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }

  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns time ago string (e.g., '2 hours ago')
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

/// List Extensions
extension ListExtension<T> on List<T> {
  /// Returns true if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Returns true if list is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Returns first element or null if list is empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns last element or null if list is empty
  T? get lastOrNull => isEmpty ? null : last;
}

/// Num Extensions
extension NumExtension on num {
  /// Converts number to currency format
  String toCurrency({String symbol = '\$'}) {
    return '$symbol${toStringAsFixed(2)}';
  }

  /// Converts bytes to human readable format
  String toFileSize() {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(2)} KB';
    if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
