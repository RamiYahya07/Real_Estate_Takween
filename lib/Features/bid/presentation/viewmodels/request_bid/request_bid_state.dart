import 'package:equatable/equatable.dart';

abstract class RequestBidState extends Equatable {
const RequestBidState();

  @override
  List<Object?> get props => [];
}

class RequestBidInitialState extends RequestBidState {}

class RequestBidLoadingState extends RequestBidState {}

class RequestBidSuccessState extends RequestBidState {}

class RequestBidFailureState extends RequestBidState {
  final String message;

  const RequestBidFailureState(this.message);

  @override
  List<Object?> get props => [message];
}