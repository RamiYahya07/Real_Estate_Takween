import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/payment/data/models/checkout_session.dart';
import 'package:takween/Features/payment/data/models/payment_reprocess_result.dart';
import 'package:takween/Features/payment/data/repos/payment_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class PaymentRepoImpl implements PaymentRepo {
  final ApiConsumer api;

  PaymentRepoImpl(this.api);

  @override
  Future<Either<Failure, CheckoutSession>> createPropertyCheckout({
    required String projectId,
    required String offerId,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kPaymentCheckout,
        body: {
          'projectId': projectId,
          'type': 'PROPERTY_PURCHASE',
          'referenceId': offerId,
        },
      );
      final apiResponse = ApiResponse<CheckoutSession>.fromJson(
        response,
        (data) => CheckoutSession.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Could not start checkout'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, CheckoutSession>> createInvestmentCheckout({
    required String projectId,
    required String requestId,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kPaymentCheckout,
        body: {
          'projectId': projectId,
          'type': 'INVESTOR_DEPOSIT',
          'referenceId': requestId,
        },
      );
      final apiResponse = ApiResponse<CheckoutSession>.fromJson(
        response,
        (data) => CheckoutSession.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Could not start checkout'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, CheckoutSession>> initPayment(
    String paymentId,
  ) async {
    try {
      final response = await api.post(EndPoints.kPaymentInit(paymentId));
      final apiResponse = ApiResponse<CheckoutSession>.fromJson(
        response,
        (data) => CheckoutSession.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Could not start checkout'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, PaymentReprocessResult>> reprocess(
    String paymentId,
  ) async {
    try {
      final response = await api.post(EndPoints.kPaymentReprocess(paymentId));
      final apiResponse = ApiResponse<PaymentReprocessResult>.fromJson(
        response,
        (data) => PaymentReprocessResult.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Could not confirm payment'),
        );
      }
      return right(
        apiResponse.data ??
            PaymentReprocessResult(message: apiResponse.message),
      );
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
