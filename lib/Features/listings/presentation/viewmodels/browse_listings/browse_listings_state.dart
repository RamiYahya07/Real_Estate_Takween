import 'package:equatable/equatable.dart';
import 'package:takween/Features/listings/data/models/listing_list_item_model.dart';

abstract class BrowseListingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BrowseListingsInitialState extends BrowseListingsState {}

class BrowseListingsLoadingState extends BrowseListingsState {}

class BrowseListingsSuccessState extends BrowseListingsState {
  final List<ListingListItemModel> listings;
  final bool hasNext;
  final bool isLoadingMore;

  BrowseListingsSuccessState({
    required this.listings,
    required this.hasNext,
    required this.isLoadingMore,
  });

  @override
  List<Object?> get props => [listings, hasNext, isLoadingMore];
}

class BrowseListingsFailureState extends BrowseListingsState {
  final String message;
  BrowseListingsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
