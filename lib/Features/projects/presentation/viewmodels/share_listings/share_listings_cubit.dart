import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/payment/data/repos/payment_repo.dart';
import 'package:takween/Features/projects/data/models/share_listing_model.dart';
import 'package:takween/Features/projects/data/repos/project_repo.dart';
import 'package:takween/Features/projects/presentation/viewmodels/share_listings/share_listings_state.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/utils/constants.dart';

class ShareListingsCubit extends Cubit<ShareListingsState> {
  final ProjectRepo repo;
  final PaymentRepo paymentRepo;
  final SecureStorageService storage;

  ShareListingsCubit(this.repo, this.paymentRepo, this.storage)
    : super(ShareListingsInitialState());

  String? _currentUserId;
  bool _isLandOwner = false;
  bool _isContractor = false;
  bool _isBuyer = false;
  bool _identityLoaded = false;

  List<ShareListingModel> _listings = [];
  bool _isCreating = false;
  String? _processingListingId;

  Future<void> _loadIdentity() async {
    if (_identityLoaded) return;

    _currentUserId = await storage.getUserId();
    if (isClosed) return;

    final role = roleFromString(await storage.getRole());
    if (isClosed) return;

    _isLandOwner = role == Roles.LandOwner;
    _isContractor = role == Roles.Contractor;
    _isBuyer = role == Roles.Buyer;

    _identityLoaded = true;
  }

  Future<void> load(String projectId) async {
    emit(ShareListingsLoadingState());

    await _loadIdentity();
    if (isClosed) return;

    final result = await repo.getShareListings(projectId);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(ShareListingsFailureState(failure.errMessage));
      },
      (listings) {
        if (isClosed) return;
        _listings = listings;
        _emitLoaded();
      },
    );
  }

  Future<void> refresh(String projectId) async {
    final result = await repo.getShareListings(projectId);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(ShareListingsTransientError(failure.errMessage));
      },
      (listings) {
        if (isClosed) return;
        _listings = listings;
        _emitLoaded();
      },
    );
  }

  Future<void> createListing({
    required String projectId,
    required int shareCount,
    required double pricePerShareUsd,
  }) async {
    if (shareCount <= 0) {
      emit(ShareListingsTransientError('Share count must be greater than 0'));
      _emitLoaded();
      return;
    }

    if (pricePerShareUsd <= 0) {
      emit(ShareListingsTransientError('Price must be greater than 0'));
      _emitLoaded();
      return;
    }

    _isCreating = true;
    _emitLoaded();

    final result = await repo.createShareListing(
      projectId: projectId,
      shareCount: shareCount,
      pricePerShareUsd: pricePerShareUsd,
    );

    if (isClosed) return;

    _isCreating = false;

    final failureMsg = result.fold<String?>((f) => f.errMessage, (_) => null);

    if (failureMsg != null) {
      if (isClosed) return;
      emit(ShareListingsTransientError(failureMsg));
      _emitLoaded();
      return;
    }

    emit(ShareListingsActionSuccess('Shares listed'));
    await refresh(projectId);
  }

  Future<void> purchase({
    required String projectId,
    required String listingId,
  }) async {
    _processingListingId = listingId;
    _emitLoaded();

    final result = await repo.purchaseShareListing(
      projectId: projectId,
      listingId: listingId,
    );

    if (isClosed) return;

    _processingListingId = null;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(ShareListingsTransientError(failure.errMessage));
        _emitLoaded();
      },
      (session) {
        if (isClosed) return;

        _emitLoaded();

        if (session.hasUrl) {
          emit(
            ShareListingsCheckoutReady(
              checkoutUrl: session.checkoutUrl!,
              paymentId: session.paymentId,
              projectId: projectId,
            ),
          );
        } else {
          emit(ShareListingsActionSuccess('Shares purchased'));
          refresh(projectId);
        }
      },
    );
  }

  Future<void> confirmPayment({
    required String paymentId,
    required String projectId,
  }) async {
    final result = await paymentRepo.reprocess(paymentId);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(ShareListingsTransientError(failure.errMessage));
        _emitLoaded();
      },
      (res) {
        if (isClosed) return;

        if (res.completed) {
          emit(
            ShareListingsActionSuccess(
              'Payment confirmed — shares transferred',
            ),
          );
        } else {
          emit(
            ShareListingsTransientError(
              res.message ??
                  'Payment not completed yet. Try again after paying.',
            ),
          );
        }

        refresh(projectId);
      },
    );
  }

  Future<void> cancel({
    required String projectId,
    required String listingId,
  }) async {
    _processingListingId = listingId;
    _emitLoaded();

    final result = await repo.cancelShareListing(
      projectId: projectId,
      listingId: listingId,
    );

    if (isClosed) return;

    _processingListingId = null;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(ShareListingsTransientError(failure.errMessage));
        _emitLoaded();
      },
      (_) {
        if (isClosed) return;
        emit(ShareListingsActionSuccess('Listing cancelled'));
        refresh(projectId);
      },
    );
  }

  void _emitLoaded() {
    if (isClosed) return;

    emit(
      ShareListingsLoadedState(
        listings: List.unmodifiable(_listings),
        isLandOwner: _isLandOwner,
        isContractor: _isContractor,
        isBuyer: _isBuyer,
        currentUserId: _currentUserId,
        isCreating: _isCreating,
        processingListingId: _processingListingId,
      ),
    );
  }
}
