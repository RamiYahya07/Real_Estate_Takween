import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/bid/data/repos/bid_repo.dart';
import 'package:takween/Features/bid/presentation/viewmodels/request_bid/request_bid_state.dart';
import 'package:takween/core/utils/constants.dart';

class RequestBidCubit extends Cubit<RequestBidState> {
  final BidRepo repo;

  RequestBidCubit(this.repo) : super(RequestBidInitialState());

  Future<void> requestBid({
    required InvestmentType type,
    required String landPostId,

    // shared fields
    double? offerPriceUsd,
    double? contractorSharePercent,
    double? landownerSharePercent,
    double? estimatedConstructionCostUsd,
    int? estimatedTimelineMonths,
    String? finishTier,
    int? proposedFloors,
    String? proposedApproach,
    String? notes,
  }) async {
    emit(RequestBidLoadingState());

    final result = await _callByType(
      type,
      landPostId: landPostId,
      offerPriceUsd: offerPriceUsd,
      contractorSharePercent: contractorSharePercent,
      landownerSharePercent: landownerSharePercent,
      estimatedConstructionCostUsd: estimatedConstructionCostUsd,
      estimatedTimelineMonths: estimatedTimelineMonths,
      finishTier: finishTier,
      proposedFloors: proposedFloors,
      proposedApproach: proposedApproach,
      notes: notes,
    );

    result.fold(
      (failure) => emit(RequestBidFailureState(failure.errMessage)),
      (_) => emit(RequestBidSuccessState()),
    );
}

  Future _callByType(
    InvestmentType type, {
    required String landPostId,
    double? offerPriceUsd,
    double? contractorSharePercent,
    double? landownerSharePercent,
    double? estimatedConstructionCostUsd,
    int? estimatedTimelineMonths,
    String? finishTier,
    int? proposedFloors,
    String? proposedApproach,
    String? notes,
  }) {
    switch (type) {
      case InvestmentType.muqasama:
        return repo.muqasama(
          landPostId: landPostId,
          landownerSharePercent: landownerSharePercent!,
          estimatedConstructionCostUsd: estimatedConstructionCostUsd!,
          estimatedTimelineMonths: estimatedTimelineMonths!,
          finishTier: finishTier!,
          proposedFloors: proposedFloors!,
          proposedApproach: proposedApproach!,
          notes: notes!,
        );

      case InvestmentType.directSale:
        return repo.directSale(
          landPostId: landPostId,
          offerPriceUsd: offerPriceUsd!,
          proposedApproach: proposedApproach!,
          notes: notes!,
        );

      case InvestmentType.jointInvestment:
        return repo.jointInvestment(
          landPostId: landPostId,
          contractorSharePercent: contractorSharePercent!,
          landownerSharePercent: landownerSharePercent!,
          estimatedConstructionCostUsd: estimatedConstructionCostUsd!,
          estimatedTimelineMonths: estimatedTimelineMonths!,
          finishTier: finishTier!,
          proposedFloors: proposedFloors!,
          proposedApproach: proposedApproach!,
          notes: notes!,
        );

      case InvestmentType.shareOffering:
        return repo.shareOffering(
          landPostId: landPostId,
          offerPriceUsd: offerPriceUsd!,
          notes: notes!,
        );
    }
  }
}
