import 'package:jwt_decoder/jwt_decoder.dart';

class JwtHelper {
  /// Decode full JWT payload
  static Map<String, dynamic> decode(String token) {
    return JwtDecoder.decode(token);
  }

  /// Check if token expired
  static bool isExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  /// Get expiration date
  static DateTime getExpiration(String token) {
    return JwtDecoder.getExpirationDate(token);
  }

  /// Get token life
  static Duration tokenLife(String token) {
    return JwtDecoder.getTokenTime(token);
  }

/// Get remaining time
  static Duration tokenRemainingTime(String token) {
    return JwtDecoder.getRemainingTime(token);
  }

  /// Extract userId from JWT
  static String? getUserId(String token) {
    final decoded = JwtDecoder.decode(token);
    return decoded['sub'];
  }

  /// Extract role from JWT
  static String? getRole(String token) {
    final decoded = JwtDecoder.decode(token);
    return decoded['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
  }

  /// Extract username
  static String? getUsername(String token) {
    final decoded = JwtDecoder.decode(token);
    return decoded['name'];
  }
}
