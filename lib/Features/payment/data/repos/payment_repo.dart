import 'package:dartz/dartz.dart';
import 'package:takween/Features/payment/data/models/checkout_session.dart';
import 'package:takween/Features/payment/data/models/payment_reprocess_result.dart';
import 'package:takween/core/errors/failures.dart';

abstract class PaymentRepo {
  Future<Either<Failure, CheckoutSession>> createPropertyCheckout({
    required String projectId,
    required String offerId,
  });

  Future<Either<Failure, CheckoutSession>> createInvestmentCheckout({
    required String projectId,
    required String requestId,
  });

  Future<Either<Failure, CheckoutSession>> initPayment(String paymentId);

  Future<Either<Failure, PaymentReprocessResult>> reprocess(String paymentId);
}
