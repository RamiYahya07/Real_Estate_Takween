import 'package:equatable/equatable.dart';
import 'package:takween/Features/listings/data/models/property_listing_model.dart';

abstract class ListingDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListingDetailsInitialState extends ListingDetailsState {}

class ListingDetailsLoadingState extends ListingDetailsState {}

class ListingDetailsLoadedState extends ListingDetailsState {
  final PropertyListingModel listing;
  final bool isBuyer;
  final bool isContractor;
  final bool isLandOwner;
  final String? currentUserId;
  final bool isSubmittingOffer;

  ListingDetailsLoadedState({
    required this.listing,
    required this.isBuyer,
    required this.isContractor,
    required this.isLandOwner,
    required this.currentUserId,
    this.isSubmittingOffer = false,
  });

  ListingDetailsLoadedState copyWith({
    PropertyListingModel? listing,
    bool? isBuyer,
    bool? isContractor,
    bool? isLandOwner,
    String? currentUserId,
    bool? isSubmittingOffer,
  }) {
    return ListingDetailsLoadedState(
      listing: listing ?? this.listing,
      isBuyer: isBuyer ?? this.isBuyer,
      isContractor: isContractor ?? this.isContractor,
      isLandOwner: isLandOwner ?? this.isLandOwner,
      currentUserId: currentUserId ?? this.currentUserId,
      isSubmittingOffer: isSubmittingOffer ?? this.isSubmittingOffer,
    );
  }

  bool get isOwner => currentUserId != null &&
      currentUserId == listing.createdByUserId;

  bool get canMakeOffer =>
      (isBuyer || isContractor) &&
      !isOwner &&
      listing.status.toUpperCase() == 'ACTIVE';

  @override
  List<Object?> get props => [
        listing,
        isBuyer,
        isContractor,
        isLandOwner,
        currentUserId,
        isSubmittingOffer,
      ];
}

class ListingDetailsFailureState extends ListingDetailsState {
  final String message;
  ListingDetailsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class ListingDetailsTransientError extends ListingDetailsState {
  final String message;
  ListingDetailsTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class ListingOfferSubmittedState extends ListingDetailsState {
  @override
  List<Object?> get props => [DateTime.now().microsecondsSinceEpoch];
}
