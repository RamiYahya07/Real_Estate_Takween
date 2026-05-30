import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/bid/data/repos/bid_repo.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_summary/get_bid_summary_state.dart';

class GetBidSummaryCubit extends Cubit<GetBidSummaryState> {
  final BidRepo bidRepo;

  GetBidSummaryCubit(this.bidRepo)
      : super(GetBidSummaryInitialState());

  Future<void> getBidSummary(String postId) async {
    emit(GetBidSummaryLoadingState());

    final result = await bidRepo.getBidSummary(postId);

    result.fold(
      (failure) {
        emit(GetBidSummaryFailureState(failure.errMessage));
      },
      (data) {
        emit(GetBidSummarySuccessState(data));
      },
    );
  }
}