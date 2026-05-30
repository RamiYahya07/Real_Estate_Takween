import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/listings/data/models/purchase_offer_model.dart';
import 'package:takween/Features/listings/data/repos/listing_repo.dart';
import 'package:takween/Features/listings/presentation/viewmodels/listing_offers/listing_offers_state.dart';

class ListingOffersCubit extends Cubit<ListingOffersState> {
  final ListingRepo repo;

  ListingOffersCubit(this.repo) : super(ListingOffersInitialState());

  List<PurchaseOfferModel> _offers = [];
  String? _processingOfferId;

  Future<void> load(String listingId) async {
    emit(ListingOffersLoadingState());
    final result = await repo.getOffers(listingId);
    result.fold(
      (failure) => emit(ListingOffersFailureState(failure.errMessage)),
      (data) {
        _offers = data;
        _emitLoaded();
      },
    );
  }

  Future<void> refresh(String listingId) async {
    final result = await repo.getOffers(listingId);
    result.fold(
      (failure) => emit(ListingOffersTransientError(failure.errMessage)),
      (data) {
        _offers = data;
        _emitLoaded();
      },
    );
  }

  Future<void> review({
    required String listingId,
    required String offerId,
    required bool approve,
  }) async {
    _processingOfferId = offerId;
    _emitLoaded();

    final result = await repo.reviewOffer(
      listingId: listingId,
      offerId: offerId,
      approve: approve,
    );

    _processingOfferId = null;
    result.fold(
      (failure) {
        emit(ListingOffersTransientError(failure.errMessage));
        _emitLoaded();
      },
      (_) {
        emit(
          ListingOffersActionSuccess(approve ? 'Offer accepted' : 'Offer rejected'),
        );
        refresh(listingId);
      },
    );
  }

  void _emitLoaded() {
    emit(
      ListingOffersLoadedState(
        offers: List.unmodifiable(_offers),
        processingOfferId: _processingOfferId,
      ),
    );
  }
}
