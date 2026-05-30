import 'package:equatable/equatable.dart';
import 'package:takween/Features/investments/data/models/investment_opportunity_model.dart';
import 'package:takween/Features/investments/data/models/my_investment_model.dart';

abstract class InvestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InvestInitial extends InvestState {}

class InvestLoading extends InvestState {}

class InvestLoaded extends InvestState {
  final List<InvestmentOpportunityModel> opportunities;
  final List<MyInvestmentModel> myInvestments;
  final bool submitting;
  final String? payingRequestId;

  InvestLoaded({
    required this.opportunities,
    required this.myInvestments,
    this.submitting = false,
    this.payingRequestId,
  });

  InvestLoaded copyWith({
    List<InvestmentOpportunityModel>? opportunities,
    List<MyInvestmentModel>? myInvestments,
    bool? submitting,
    String? payingRequestId,
    bool clearPayingRequestId = false,
  }) {
    return InvestLoaded(
      opportunities: opportunities ?? this.opportunities,
      myInvestments: myInvestments ?? this.myInvestments,
      submitting: submitting ?? this.submitting,
      payingRequestId: clearPayingRequestId
          ? null
          : (payingRequestId ?? this.payingRequestId),
    );
  }

  @override
  List<Object?> get props =>
      [opportunities, myInvestments, submitting, payingRequestId];
}

class InvestCheckoutReady extends InvestState {
  final String checkoutUrl;
  final String paymentId;

  InvestCheckoutReady({required this.checkoutUrl, required this.paymentId});

  @override
  List<Object?> get props =>
      [checkoutUrl, paymentId, DateTime.now().microsecondsSinceEpoch];
}

class InvestFailure extends InvestState {
  final String message;
  InvestFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class InvestTransientError extends InvestState {
  final String message;
  InvestTransientError(this.message);
  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class InvestActionSuccess extends InvestState {
  final String message;
  InvestActionSuccess(this.message);
  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}
