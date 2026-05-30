import 'package:equatable/equatable.dart';

abstract class PendingPaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PendingPaymentIdle extends PendingPaymentState {}

class PendingPaymentLoading extends PendingPaymentState {}

class PendingPaymentCheckoutReady extends PendingPaymentState {
  final String checkoutUrl;
  final String paymentId;

  PendingPaymentCheckoutReady({
    required this.checkoutUrl,
    required this.paymentId,
  });

  @override
  List<Object?> get props =>
      [checkoutUrl, paymentId, DateTime.now().microsecondsSinceEpoch];
}

class PendingPaymentTransientError extends PendingPaymentState {
  final String message;
  PendingPaymentTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class PendingPaymentSuccess extends PendingPaymentState {
  final String message;
  PendingPaymentSuccess(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}
