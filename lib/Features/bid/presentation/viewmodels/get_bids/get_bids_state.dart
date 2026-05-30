import 'package:equatable/equatable.dart';
import 'package:takween/Features/bid/data/models/bid_item_model.dart';

abstract class GetBidsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetBidsInitialState extends GetBidsState {}

class GetBidsLoadingState extends GetBidsState {}

class GetBidsSuccessState extends GetBidsState {
  final List<BidItemModel> bids;
  final bool hasNext;
  final bool isLoadingMore;
  final bool auctionClosed;

  GetBidsSuccessState({
    required this.bids,
    required this.hasNext,
    required this.isLoadingMore,
    this.auctionClosed = false,
  });

  @override
  List<Object?> get props => [bids, hasNext, isLoadingMore, auctionClosed];
}

class GetBidsFailureState extends GetBidsState {
  final String message;

  GetBidsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
