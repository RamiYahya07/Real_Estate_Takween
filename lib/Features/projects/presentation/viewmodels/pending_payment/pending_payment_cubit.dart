import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/payment/data/repos/payment_repo.dart';
import 'package:takween/Features/projects/presentation/viewmodels/pending_payment/pending_payment_state.dart';

class PendingPaymentCubit extends Cubit<PendingPaymentState> {
  final PaymentRepo paymentRepo;

  PendingPaymentCubit(this.paymentRepo) : super(PendingPaymentIdle());

  Future<void> pay(String paymentId) async {
    emit(PendingPaymentLoading());
    final res = await paymentRepo.initPayment(paymentId);
    res.fold(
      (failure) {
        emit(PendingPaymentTransientError(failure.errMessage));
        emit(PendingPaymentIdle());
      },
      (session) {
        if (session.hasUrl) {
          emit(PendingPaymentCheckoutReady(
            checkoutUrl: session.checkoutUrl!,
            paymentId: session.paymentId,
          ));
          emit(PendingPaymentIdle());
        } else {
          emit(PendingPaymentTransientError('Could not start checkout'));
          emit(PendingPaymentIdle());
        }
      },
    );
  }

  Future<void> confirmPayment(String paymentId) async {
    final res = await paymentRepo.reprocess(paymentId);
    res.fold(
      (failure) {
        emit(PendingPaymentTransientError(failure.errMessage));
        emit(PendingPaymentIdle());
      },
      (result) {
        if (result.completed) {
          emit(PendingPaymentSuccess('Payment confirmed'));
        } else {
          emit(PendingPaymentTransientError(
            result.message ?? 'Payment not completed yet. Try again after paying.',
          ));
        }
        emit(PendingPaymentIdle());
      },
    );
  }
}
