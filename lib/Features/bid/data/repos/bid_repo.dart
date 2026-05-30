import 'package:dartz/dartz.dart';
import 'package:takween/Features/bid/data/models/bid_details_model.dart';
import 'package:takween/Features/bid/data/models/bid_item_model.dart';
import 'package:takween/Features/bid/data/models/bid_summary_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class BidRepo {
  Future<Either<Failure, void>> muqasama({
    required String landPostId,
    required double landownerSharePercent,
    required double estimatedConstructionCostUsd,
    required int estimatedTimelineMonths,
    required String finishTier,
    required int proposedFloors,
    required String proposedApproach,
    required String notes,
  });

  Future<Either<Failure, void>> jointInvestment({
    required String landPostId,
    required double contractorSharePercent,
    required double landownerSharePercent,
    required double estimatedConstructionCostUsd,
    required int estimatedTimelineMonths,
    required String finishTier,
    required int proposedFloors,
    required String proposedApproach,
    required String notes,
  });

  Future<Either<Failure, void>> directSale({
    required String landPostId,
    required double offerPriceUsd,
    required String proposedApproach,
    required String notes,
  });

  Future<Either<Failure, void>> shareOffering({
    required String landPostId,
    required double offerPriceUsd,
    required String notes,
  });

Future<Either<Failure, BidDetailsModel>> getBidDetails({
  required String bidId,
});
  Future<Either<Failure, List<BidItemModel>>> getBids({
    required String landPostId,
    int page = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, void>> acceptBid({required String bidId});

  Future<Either<Failure, void>> rejectBid({required String bidId});

  Future<Either<Failure, BidSummaryModel>> getBidSummary(String postId);
}
