import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:takween/core/utils/constants.dart';

class SecureStorageService {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  ///  Access Token

  Future<void> saveToken(String token) =>
      storage.write(key: kAccessTokenKey, value: token);

  Future<String?> getToken() => storage.read(key: kAccessTokenKey);

  Future<void> deleteToken() => storage.delete(key: kAccessTokenKey);

  ///  Refresh Token
  Future<void> saveRefreshToken(String token) =>
      storage.write(key: kRefreshTokenKey, value: token);

  Future<String?> getRefreshToken() => storage.read(key: kRefreshTokenKey);

  Future<void> deleteRefreshToken() => storage.delete(key: kRefreshTokenKey);

  ///  Role

  Future<void> saveRole(String role) => storage.write(key: kRole, value: role);

  Future<String?> getRole() => storage.read(key: kRole);

  Future<void> deleteRole() => storage.delete(key: kRole);

  Future<void> saveUserId(String userId) =>
      storage.write(key: kUserId, value: userId);
        Future<String?> getUserId() => storage.read(key: kUserId);
  Future<void> deleteuserId() => storage.delete(key: kUserId);

  /// Clear Secure Storage
  Future<void> clearAll() => storage.deleteAll();
}
