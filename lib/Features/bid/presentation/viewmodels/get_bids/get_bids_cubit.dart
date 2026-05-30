import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:takween/Features/bid/data/models/bid_item_model.dart';
import 'package:takween/Features/bid/data/models/bidding_events.dart';
import 'package:takween/Features/bid/data/repos/bid_repo.dart';
import 'package:takween/Features/bid/data/repos/bidding_realtime_repo.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bids/get_bids_state.dart';

class GetBidsCubit extends Cubit<GetBidsState> {
  final BidRepo repo;
  final BiddingRealtimeRepo realtime;

  GetBidsCubit(this.repo, this.realtime) : super(GetBidsInitialState());

  List<BidItemModel> bids = [];
  int page = 1;
  final int pageSize = 10;
  bool hasNext = true;
  bool isLoadingMore = false;
  bool auctionClosed = false;

  String? _joinedPostId;
  StreamSubscription<NewBidDetailsEvent>? _newBidDetailsSub;
  StreamSubscription<BiddingClosedEvent>? _biddingClosedSub;

  Future<void> getBids(String landPostId) async {
    emit(GetBidsLoadingState());

    page = 1;
    hasNext = true;
    auctionClosed = false;
    bids.clear();

    await _ensureSubscriptions(landPostId);

    final result = await repo.getBids(
      landPostId: landPostId,
      page: page,
      pageSize: pageSize,
    );

    result.fold(
      (failure) => emit(GetBidsFailureState(failure.errMessage)),
      (data) {
        bids = data;
        hasNext = data.length == pageSize;
        _emitSuccess();
      },
    );
  }

  Future<void> loadMore(String landPostId) async {
    if (isLoadingMore || !hasNext) return;
    isLoadingMore = true;
    _emitSuccess();
    page++;

    final result = await repo.getBids(
      landPostId: landPostId,
      page: page,
      pageSize: pageSize,
    );

    result.fold(
      (failure) {
        isLoadingMore = false;
        page--;
        emit(GetBidsFailureState(failure.errMessage));
      },
      (data) {
        isLoadingMore = false;
        bids.addAll(data);
        hasNext = data.length == pageSize;
        _emitSuccess();
      },
    );
  }

  Future<void> _ensureSubscriptions(String landPostId) async {
    if (_joinedPostId == landPostId) return;

    if (_joinedPostId != null) {
      await realtime.leavePost(_joinedPostId!);
    }
    await _newBidDetailsSub?.cancel();
    await _biddingClosedSub?.cancel();

    try {
      await realtime.joinPost(landPostId);
    } catch (_) {}

    _joinedPostId = landPostId;

    _newBidDetailsSub = realtime.onNewBidDetails.listen((event) {
      if (event.landPostId != landPostId) return;
      _silentRefresh(landPostId);
    });

    _biddingClosedSub = realtime.onBiddingClosed.listen((event) {
      if (event.landPostId != landPostId) return;
      auctionClosed = true;
      _emitSuccess();
    });
  }

  Future<void> _silentRefresh(String landPostId) async {
    final result = await repo.getBids(
      landPostId: landPostId,
      page: 1,
      pageSize: pageSize,
    );
    result.fold(
      (_) {},
      (data) {
        bids = data;
        page = 1;
        hasNext = data.length == pageSize;
        _emitSuccess();
      },
    );
  }

  void _emitSuccess() {
    emit(
      GetBidsSuccessState(
        bids: List.unmodifiable(bids),
        hasNext: hasNext,
        isLoadingMore: isLoadingMore,
        auctionClosed: auctionClosed,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _newBidDetailsSub?.cancel();
    await _biddingClosedSub?.cancel();
    if (_joinedPostId != null) {
      await realtime.leavePost(_joinedPostId!);
    }
    return super.close();
  }
}
