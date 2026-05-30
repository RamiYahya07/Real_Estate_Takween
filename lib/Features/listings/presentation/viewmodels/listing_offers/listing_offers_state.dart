import 'package:equatable/equatable.dart';
import 'package:takween/Features/listings/data/models/purchase_offer_model.dart';

abstract class ListingOffersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListingOffersInitialState extends ListingOffersState {}

class ListingOffersLoadingState extends ListingOffersState {}

class ListingOffersLoadedState extends ListingOffersState {
  final List<PurchaseOfferModel> offers;
  final String? processingOfferId;

  ListingOffersLoadedState({
    required this.offers,
    this.processingOfferId,
  });

  ListingOffersLoadedState copyWith({
    List<PurchaseOfferModel>? offers,
    Object? processingOfferId = _sentinel,
  }) {
    return ListingOffersLoadedState(
      offers: offers ?? this.offers,
      processingOfferId: identical(processingOfferId, _sentinel)
          ? this.processingOfferId
          : processingOfferId as String?,
    );
  }

  @override
  List<Object?> get props => [offers, processingOfferId];
}

class ListingOffersFailureState extends ListingOffersState {
  final String message;
  ListingOffersFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class ListingOffersTransientError extends ListingOffersState {
  final String message;
  ListingOffersTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class ListingOffersActionSuccess extends ListingOffersState {
  final String message;
  ListingOffersActionSuccess(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

const _sentinel = Object();
