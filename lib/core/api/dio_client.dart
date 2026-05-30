import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:takween/core/api/api_interceptors.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/services/auth_service.dart';
import 'package:takween/core/utils/constants.dart';

class DioClient {
  static Dio createDio(SecureStorageService storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: kApi,
        connectTimeout: kConnectionTimeout,
        receiveTimeout: kReceiveTimeout,
        sendTimeout: kReceiveTimeout,
        headers: {'Content-Type': 'application/json'},
        followRedirects: true,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.interceptors.addAll([
      ApiInterceptor(),
      AuthInterceptor(
  dio: dio,
  getToken: () => storage.getToken(),
  getRefreshToken: () => storage.getRefreshToken(),
  getUserId: () => storage.getUserId(),
  saveToken: (token) => storage.saveToken(token),
),
      RefreshTokenInterceptor(
        dio: dio,
        getRefreshToken: () => storage.getRefreshToken(),
        getUserId: ()=>storage.getUserId(),
        saveToken: (token) => storage.saveToken(token),
        onLogout: AuthService.logout,
      ),
    ]);

    return dio;
  }
}
