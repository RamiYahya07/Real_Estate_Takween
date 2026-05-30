import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/investments/data/models/investment_opportunity_model.dart';
import 'package:takween/Features/investments/data/models/my_investment_model.dart';
import 'package:takween/Features/investments/data/repos/investments_repo.dart';
import 'package:takween/Features/investments/presentation/viewmodels/invest/invest_state.dart';
import 'package:takween/Features/payment/data/repos/payment_repo.dart';

class InvestCubit extends Cubit<InvestState> {
  final InvestmentsRepo repo;
  final PaymentRepo paymentRepo;
  InvestCubit(this.repo, this.paymentRepo) : super(InvestInitial());

  List<InvestmentOpportunityModel> _opportunities = [];
  List<MyInvestmentModel> _myInvestments = [];

  Future<void> load() async {
    emit(InvestLoading());
    final oppRes = await repo.getOpenInvestments();
    final myRes = await repo.getMyInvestments();

    final oppFailure = oppRes.fold((f) => f.errMessage, (_) => null);
    final myFailure = myRes.fold((f) => f.errMessage, (_) => null);

    if (oppFailure != null && myFailure != null) {
      emit(InvestFailure('$oppFailure\n$myFailure'));
      return;
    }

    _opportunities = oppRes.fold((_) => <InvestmentOpportunityModel>[], (l) => l);
    _myInvestments = myRes.fold((_) => <MyInvestmentModel>[], (l) => l);

    emit(InvestLoaded(
      opportunities: List.unmodifiable(_opportunities),
      myInvestments: List.unmodifiable(_myInvestments),
    ));
  }

  Future<void> refresh() async {
    final oppRes = await repo.getOpenInvestments();
    final myRes = await repo.getMyInvestments();
    _opportunities = oppRes.fold((_) => _opportunities, (l) => l);
    _myInvestments = myRes.fold((_) => _myInvestments, (l) => l);
    emit(InvestLoaded(
      opportunities: List.unmodifiable(_opportunities),
      myInvestments: List.unmodifiable(_myInvestments),
    ));
  }

  Future<void> submit({
    required String projectId,
    required double amount,
    String? notes,
  }) async {
    if (state is InvestLoaded) {
      emit((state as InvestLoaded).copyWith(submitting: true));
    }
    final res = await repo.submit(
      projectId: projectId,
      investmentAmountUsd: amount,
      notes: notes,
    );
    res.fold(
      (f) {
        emit(InvestTransientError(f.errMessage));
        if (state is InvestLoaded) {
          emit((state as InvestLoaded).copyWith(submitting: false));
        }
      },
      (msg) {
        emit(InvestActionSuccess(msg));
        refresh();
      },
    );
  }

  Future<void> pay(MyInvestmentModel investment) async {
    if (state is InvestLoaded) {
      emit((state as InvestLoaded).copyWith(payingRequestId: investment.id));
    }

    final res = await paymentRepo.createInvestmentCheckout(
      projectId: investment.projectId,
      requestId: investment.id,
    );

    if (state is InvestLoaded) {
      emit((state as InvestLoaded).copyWith(clearPayingRequestId: true));
    }

    res.fold(
      (f) => emit(InvestTransientError(f.errMessage)),
      (session) {
        if (session.hasUrl) {
          emit(InvestCheckoutReady(
            checkoutUrl: session.checkoutUrl!,
            paymentId: session.paymentId,
          ));
        } else {
          emit(InvestTransientError('Could not start checkout'));
        }
      },
    );
  }

  Future<void> confirmPayment(String paymentId) async {
    final res = await paymentRepo.reprocess(paymentId);
    res.fold(
      (f) => emit(InvestTransientError(f.errMessage)),
      (result) {
        if (result.completed) {
          emit(InvestActionSuccess('Payment confirmed — shares allocated'));
        } else {
          emit(InvestTransientError(
            result.message ?? 'Payment not completed yet. Try again after paying.',
          ));
        }
        refresh();
      },
    );
  }
}
