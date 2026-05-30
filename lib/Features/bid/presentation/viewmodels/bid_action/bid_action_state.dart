import 'package:equatable/equatable.dart';

abstract class BidActionState extends Equatable {
  const BidActionState();

  @override
  List<Object?> get props => [];
}

class BidActionInitialState extends BidActionState {}

class BidActionLoadingState extends BidActionState {
  final String bidId;

  const BidActionLoadingState(this.bidId);

  @override
  List<Object?> get props => [bidId];
}

class BidActionSuccessState extends BidActionState {
  final String bidId;

  const BidActionSuccessState(this.bidId);

  @override
  List<Object?> get props => [bidId];
}

class BidActionFailureState extends BidActionState {
  final String message;

  const BidActionFailureState(this.message);

  @override
  List<Object?> get props => [message];
}