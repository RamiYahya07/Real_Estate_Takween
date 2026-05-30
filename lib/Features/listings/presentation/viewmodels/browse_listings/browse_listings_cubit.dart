import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/listings/data/models/listing_list_item_model.dart';
import 'package:takween/Features/listings/data/repos/listing_repo.dart';
import 'package:takween/Features/listings/presentation/viewmodels/browse_listings/browse_listings_state.dart';

class BrowseListingsCubit extends Cubit<BrowseListingsState> {
  final ListingRepo repo;

  BrowseListingsCubit(this.repo) : super(BrowseListingsInitialState());

  List<ListingListItemModel> _listings = [];
  int _page = 1;
  final int _pageSize = 10;
  bool _hasNext = true;
  bool _isLoadingMore = false;

  Future<void> load() async {
    emit(BrowseListingsLoadingState());
    _page = 1;
    _hasNext = true;
    _listings = [];

    final result = await repo.getAll(page: _page, pageSize: _pageSize);
    result.fold(
      (failure) => emit(BrowseListingsFailureState(failure.errMessage)),
      (data) {
        _listings = data;
        _hasNext = data.length == _pageSize;
        _emitSuccess();
      },
    );
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasNext) return;
    _isLoadingMore = true;
    _emitSuccess();
    _page++;

    final result = await repo.getAll(page: _page, pageSize: _pageSize);
    result.fold(
      (failure) {
        _isLoadingMore = false;
        _page--;
        emit(BrowseListingsFailureState(failure.errMessage));
      },
      (data) {
        _isLoadingMore = false;
        _listings = [..._listings, ...data];
        _hasNext = data.length == _pageSize;
        _emitSuccess();
      },
    );
  }

  void _emitSuccess() {
    emit(
      BrowseListingsSuccessState(
        listings: List.unmodifiable(_listings),
        hasNext: _hasNext,
        isLoadingMore: _isLoadingMore,
      ),
    );
  }
}
