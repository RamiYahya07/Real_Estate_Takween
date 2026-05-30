class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final String? message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.statusCode,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic data)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
     data: json['data'] != null && fromJsonT != null
    ? fromJsonT(json['data'])
    : null,
    );
  }
}