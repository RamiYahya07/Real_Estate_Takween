import 'package:takween/Features/bid/data/models/bid_details_model.dart';
import 'package:equatable/equatable.dart';

abstract class GetBidDetailsState extends Equatable {
  const GetBidDetailsState();

  @override
  List<Object?> get props => [];
}

class GetBidDetailsInitialState extends GetBidDetailsState {
  const GetBidDetailsInitialState();
}

class GetBidDetailsLoadingState extends GetBidDetailsState {
  const GetBidDetailsLoadingState();
}

class GetBidDetailsSuccessState extends GetBidDetailsState {
  final BidDetailsModel data;

  const GetBidDetailsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class GetBidDetailsFailureState extends GetBidDetailsState {
  final String message;

  const GetBidDetailsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}