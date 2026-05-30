import 'package:equatable/equatable.dart';
import 'package:takween/Features/bid/data/models/bid_summary_model.dart';

abstract class GetBidSummaryState extends Equatable {
  const GetBidSummaryState();

  @override
  List<Object?> get props => [];
}

class GetBidSummaryInitialState
    extends GetBidSummaryState {}

class GetBidSummaryLoadingState
    extends GetBidSummaryState {}

class GetBidSummarySuccessState
    extends GetBidSummaryState {
  final BidSummaryModel data;

  const GetBidSummarySuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class GetBidSummaryFailureState
    extends GetBidSummaryState {
  final String message;

  const GetBidSummaryFailureState(this.message);

  @override
  List<Object?> get props => [message];
}