import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/services/auth_service.dart';
import 'package:takween/core/utils/helper/jwt_helper.dart';

/// API Interceptor for handling requests, responses, and errors
/// Provides centralized logging and error handling
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log request details
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📤 REQUEST[${options.method}] => PATH: ${options.path}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Query Parameters: ${options.queryParameters}');
    debugPrint('Body: ${options.data}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log response details
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint(
      '📥 RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    debugPrint('Data: ${response.data}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error details
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint(
      '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    debugPrint('Message: ${err.message}');
    debugPrint('Response: ${err.response?.data}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    handler.next(err);
  }
}

/// Authentication Interceptor
/// Automatically adds authentication token to requests
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final Future<String?> Function() getRefreshToken;
  final Future<String?> Function() getUserId;
  final Future<void> Function(String token) saveToken;

  final Dio dio;

  AuthInterceptor({
    required this.getToken,
    required this.getRefreshToken,
    required this.getUserId,
    required this.saveToken,
    required this.dio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    /// Skip auth endpoints
    if (options.path.endsWith('/login') ||
        options.path.endsWith('/register') ||
        options.path.endsWith('/refresh-token')) {
      return handler.next(options);
    }

    String? token = await getToken();
    if (token != null) {
      final tokenRemainingTime = JwtHelper.tokenRemainingTime(token);

      debugPrint(
        "⏳ Token remaining time: ${tokenRemainingTime.inSeconds} seconds",
      );
    }

    /// 🔥 CHECK BEFORE REQUEST
    if (token != null) {
      final remainingTime = JwtHelper.tokenRemainingTime(token);
      debugPrint("⏳ Token remaining: ${remainingTime.inSeconds}s");

      // Refresh if token has less than 1 minutes remaining
      if (remainingTime.inMinutes < 10) {
        debugPrint("⚠️ Token is about to expire, refreshing...");

        final refreshToken = await getRefreshToken();
        final userId = await getUserId();

        if (refreshToken != null && userId != null) {
          try {
            final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
            (refreshDio.httpClientAdapter as IOHttpClientAdapter)
                .onHttpClientCreate = (client) {
              client.badCertificateCallback =
                  (X509Certificate cert, String host, int port) => true;
              return client;
            };
            final response = await refreshDio.post(
              EndPoints.kRefershToken,
              data: {"refreshToken": refreshToken, "userId": userId},
            );

            token = response.data['data']['token'];
            debugPrint("✅ New token received (pre-request)");

            await saveToken(token ?? '');
          } catch (e) {
            debugPrint("❌ Refresh failed: $e");
            await AuthService.logout();
          }
        }
      }
    }

    /// Attach token
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;
  final Future<String?> Function() getRefreshToken;
  final Future<String?> Function() getUserId;
  final Future<void> Function(String token) saveToken;
  final Future<void> Function() onLogout;

  RefreshTokenInterceptor({
    required this.dio,
    required this.getRefreshToken,
    required this.getUserId,
    required this.saveToken,
    required this.onLogout,
  });

  @override
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint("🚨 onError triggered");

    /// ✅ 1. Only handle 401
    if (err.response?.statusCode != 401) {
      debugPrint("➡️ Not a 401, skipping...");
      return handler.next(err);
    }

    debugPrint("🔐 401 detected → trying refresh...");

    /// ❌ 2. Prevent infinite loop
    // if (err.requestOptions.path.contains(EndPoints.kRefershToken))
    if (err.requestOptions.path.endsWith('/refresh-token')) {
      debugPrint("❌ Refresh request itself failed → stopping");
      return handler.next(err);
    }

    final refreshToken = await getRefreshToken();
    final userId = await getUserId();

    if (refreshToken == null || userId == null) {
      debugPrint("❌ Missing refreshToken or userId → logging out");
      await onLogout();
      return handler.next(err);
    }

    try {
      debugPrint("🔄 Sending refresh request...");

      final refreshDio = Dio(
        BaseOptions(
          baseUrl: dio.options.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final response = await refreshDio.post(
        EndPoints.kRefershToken,
        data: {"refreshToken": refreshToken, "userId": userId},
      );

      final newToken = response.data['data']['token'];

      debugPrint("✅ Refresh SUCCESS → new token received");

      /// Save new token
      await saveToken(newToken);

      /// Retry request
      final requestOptions = err.requestOptions;

      requestOptions.headers['Authorization'] = 'Bearer $newToken';

      debugPrint("🔁 Retrying original request...");

      final cloneResponse = await dio.request(
        requestOptions.path,
        options: Options(
          method: requestOptions.method,
          headers: requestOptions.headers,
        ),
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
      );

      debugPrint("✅ Retry SUCCESS");

      return handler.resolve(cloneResponse);
    } catch (e) {
      debugPrint("❌ Refresh FAILED: $e → logging out");
      await onLogout();
      return handler.next(err);
    }
  }
}
