import 'package:bloc/bloc.dart';
import 'package:takween/Features/bid/data/repos/bid_repo.dart';
import 'bid_action_state.dart';

class BidActionCubit extends Cubit<BidActionState> {
  final BidRepo repo;

  BidActionCubit(this.repo) : super(BidActionInitialState());

  /// ✅ ACCEPT
  Future<void> acceptBid(String bidId) async {
    emit(BidActionLoadingState(bidId));

    final result = await repo.acceptBid(bidId: bidId);

    result.fold(
      (failure) {
        emit(BidActionFailureState(failure.errMessage));
      },
      (_) {
        emit(BidActionSuccessState(bidId));
      },
    );
  }

  /// ❌ REJECT
  Future<void> rejectBid(String bidId) async {
    emit(BidActionLoadingState(bidId));

    final result = await repo.rejectBid(bidId: bidId);

    result.fold(
      (failure) => emit(BidActionFailureState(failure.errMessage)),
      (_) => emit(BidActionSuccessState(bidId)),
    );
  }
}
