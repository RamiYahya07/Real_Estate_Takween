import 'package:equatable/equatable.dart';
import 'package:takween/Features/listings/data/models/my_offer_model.dart';

abstract class MyOffersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyOffersInitial extends MyOffersState {}

class MyOffersLoading extends MyOffersState {}

class MyOffersLoaded extends MyOffersState {
  final List<MyOfferModel> offers;
  final String? payingOfferId;

  MyOffersLoaded({required this.offers, this.payingOfferId});

  @override
  List<Object?> get props => [offers, payingOfferId];
}

class MyOffersFailure extends MyOffersState {
  final String message;
  MyOffersFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class MyOffersTransientError extends MyOffersState {
  final String message;
  MyOffersTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class MyOffersActionSuccess extends MyOffersState {
  final String message;
  MyOffersActionSuccess(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class MyOffersCheckoutReady extends MyOffersState {
  final String checkoutUrl;
  final String paymentId;

  MyOffersCheckoutReady({required this.checkoutUrl, required this.paymentId});

  @override
  List<Object?> get props =>
      [checkoutUrl, paymentId, DateTime.now().microsecondsSinceEpoch];
}
