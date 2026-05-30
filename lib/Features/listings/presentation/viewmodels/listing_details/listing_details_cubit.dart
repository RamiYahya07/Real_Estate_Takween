import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/listings/data/models/property_listing_model.dart';
import 'package:takween/Features/listings/data/repos/listing_repo.dart';
import 'package:takween/Features/listings/presentation/viewmodels/listing_details/listing_details_state.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/utils/constants.dart';

class ListingDetailsCubit extends Cubit<ListingDetailsState> {
  final ListingRepo repo;
  final SecureStorageService storage;

  ListingDetailsCubit(this.repo, this.storage)
      : super(ListingDetailsInitialState());

  String? _currentUserId;
  bool _isLandOwner = false;
  bool _isContractor = false;
  bool _isBuyer = false;
  bool _identityLoaded = false;
  PropertyListingModel? _listing;
  bool _isSubmittingOffer = false;

  Future<void> _loadIdentity() async {
    if (_identityLoaded) return;
    _currentUserId = await storage.getUserId();
    final role = roleFromString(await storage.getRole());
    _isLandOwner = role == Roles.LandOwner;
    _isContractor = role == Roles.Contractor;
    _isBuyer = role == Roles.Buyer;
    _identityLoaded = true;
  }

  Future<void> load(String listingId) async {
    emit(ListingDetailsLoadingState());
    await _loadIdentity();

    final result = await repo.getById(listingId);
    result.fold(
      (failure) => emit(ListingDetailsFailureState(failure.errMessage)),
      (data) {
        _listing = data;
        _emitLoaded();
      },
    );
  }

  Future<void> refresh(String listingId) async {
    final result = await repo.getById(listingId);
    result.fold(
      (failure) => emit(ListingDetailsTransientError(failure.errMessage)),
      (data) {
        _listing = data;
        _emitLoaded();
      },
    );
  }

  Future<void> makeOffer({
    required String listingId,
    required double offerPriceUsd,
    String? message,
  }) async {
    if (offerPriceUsd <= 0) {
      emit(ListingDetailsTransientError('Offer price must be greater than 0'));
      _emitLoaded();
      return;
    }

    _isSubmittingOffer = true;
    _emitLoaded();

    final result = await repo.makeOffer(
      listingId: listingId,
      offerPriceUsd: offerPriceUsd,
      message: message,
    );

    _isSubmittingOffer = false;
    result.fold(
      (failure) {
        emit(ListingDetailsTransientError(failure.errMessage));
        _emitLoaded();
      },
      (_) {
        emit(ListingOfferSubmittedState());
        refresh(listingId);
      },
    );
  }

  void _emitLoaded() {
    if (_listing == null) return;
    emit(
      ListingDetailsLoadedState(
        listing: _listing!,
        isBuyer: _isBuyer,
        isContractor: _isContractor,
        isLandOwner: _isLandOwner,
        currentUserId: _currentUserId,
        isSubmittingOffer: _isSubmittingOffer,
      ),
    );
  }
}
