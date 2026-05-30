import 'package:dio/dio.dart';
import 'package:takween/core/api/api_consumer.dart';

class ApiConusmerImpl implements ApiConsumer {
  final Dio dio;
  ApiConusmerImpl(this.dio);

  /// get
  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response.data;
  }

  /// post
  @override
  Future post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.post(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response.data;
  }

  /// post with a JSON array body
  @override
  Future postList(
    String path, {
    required List<dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.post(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response.data;
  }

  /// put
  @override
  Future put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.put(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response.data;
  }

  /// delete
  @override
  Future delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.delete(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response.data;
  }

  /// patch
  @override
  Future patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await dio.patch(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response.data;
  }

 
@override
Future postFormData(
  String path, {
  required FormData formData,
  Map<String, dynamic>? queryParameters,
  Map<String, String>? headers,
}) async {
  final response = await dio.post(
    path,
    data: formData,
    queryParameters: queryParameters,
    options: Options(
      headers: {
        ...?headers,
        "Content-Type": "multipart/form-data",
      },
    ),
  );

  return response.data;
}
}
