import 'package:equatable/equatable.dart';
import 'package:takween/Features/projects/data/models/share_listing_model.dart';

abstract class ShareListingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShareListingsInitialState extends ShareListingsState {}

class ShareListingsLoadingState extends ShareListingsState {}

class ShareListingsLoadedState extends ShareListingsState {
  final List<ShareListingModel> listings;
  final bool isLandOwner;
  final bool isContractor;
  final bool isBuyer;
  final String? currentUserId;
  final bool isCreating;
  final String? processingListingId;

  ShareListingsLoadedState({
    required this.listings,
    required this.isLandOwner,
    required this.isContractor,
    required this.isBuyer,
    required this.currentUserId,
    this.isCreating = false,
    this.processingListingId,
  });

  ShareListingsLoadedState copyWith({
    List<ShareListingModel>? listings,
    bool? isLandOwner,
    bool? isContractor,
    bool? isBuyer,
    String? currentUserId,
    bool? isCreating,
    Object? processingListingId = _sentinel,
  }) {
    return ShareListingsLoadedState(
      listings: listings ?? this.listings,
      isLandOwner: isLandOwner ?? this.isLandOwner,
      isContractor: isContractor ?? this.isContractor,
      isBuyer: isBuyer ?? this.isBuyer,
      currentUserId: currentUserId ?? this.currentUserId,
      isCreating: isCreating ?? this.isCreating,
      processingListingId: identical(processingListingId, _sentinel)
          ? this.processingListingId
          : processingListingId as String?,
    );
  }

  @override
  List<Object?> get props => [
        listings,
        isLandOwner,
        isContractor,
        isBuyer,
        currentUserId,
        isCreating,
        processingListingId,
      ];
}

class ShareListingsFailureState extends ShareListingsState {
  final String message;
  ShareListingsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class ShareListingsTransientError extends ShareListingsState {
  final String message;
  ShareListingsTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class ShareListingsActionSuccess extends ShareListingsState {
  final String message;
  ShareListingsActionSuccess(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class ShareListingsCheckoutReady extends ShareListingsState {
  final String checkoutUrl;
  final String paymentId;
  final String projectId;

  ShareListingsCheckoutReady({
    required this.checkoutUrl,
    required this.paymentId,
    required this.projectId,
  });

  @override
  List<Object?> get props =>
      [checkoutUrl, paymentId, projectId, DateTime.now().microsecondsSinceEpoch];
}

const _sentinel = Object();
