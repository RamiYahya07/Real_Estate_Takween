import 'package:equatable/equatable.dart';
import 'package:takween/Features/investments/data/models/investor_request_model.dart';

abstract class InvestorReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InvestorReviewInitial extends InvestorReviewState {}

class InvestorReviewLoading extends InvestorReviewState {}

class InvestorReviewLoaded extends InvestorReviewState {
  final List<InvestorRequestModel> requests;
  final String? processingRequestId;

  InvestorReviewLoaded({required this.requests, this.processingRequestId});

  InvestorReviewLoaded copyWith({
    List<InvestorRequestModel>? requests,
    String? processingRequestId,
    bool clearProcessing = false,
  }) {
    return InvestorReviewLoaded(
      requests: requests ?? this.requests,
      processingRequestId:
          clearProcessing ? null : (processingRequestId ?? this.processingRequestId),
    );
  }

  @override
  List<Object?> get props => [requests, processingRequestId];
}

class InvestorReviewFailure extends InvestorReviewState {
  final String message;
  InvestorReviewFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class InvestorReviewTransientError extends InvestorReviewState {
  final String message;
  InvestorReviewTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class InvestorReviewActionSuccess extends InvestorReviewState {
  final String message;
  InvestorReviewActionSuccess(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}
