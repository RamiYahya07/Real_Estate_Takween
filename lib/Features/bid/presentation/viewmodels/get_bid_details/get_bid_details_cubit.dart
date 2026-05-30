import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/bid/data/repos/bid_repo.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_details/get_bid_details_state.dart';

class GetBidDetailsCubit extends Cubit<GetBidDetailsState> {
  final BidRepo repo;

  GetBidDetailsCubit(this.repo) : super(GetBidDetailsInitialState());

  Future<void> getBidDetails(String bidId) async {
    emit(GetBidDetailsLoadingState());

    final result = await repo.getBidDetails(bidId: bidId);

    result.fold(
      (failure) => emit(GetBidDetailsFailureState(failure.errMessage)),
      (data) => emit(GetBidDetailsSuccessState(data)),
    );
  }
}