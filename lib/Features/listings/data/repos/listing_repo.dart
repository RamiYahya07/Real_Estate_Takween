import 'package:dartz/dartz.dart';
import 'package:takween/Features/listings/data/models/listing_list_item_model.dart';
import 'package:takween/Features/listings/data/models/my_offer_model.dart';
import 'package:takween/Features/listings/data/models/property_listing_model.dart';
import 'package:takween/Features/listings/data/models/purchase_offer_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class ListingRepo {
  Future<Either<Failure, List<ListingListItemModel>>> getAll({
    int page = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, List<MyOfferModel>>> getMyOffers({
    int page = 1,
    int pageSize = 20,
    String? status,
  });

  Future<Either<Failure, PropertyListingModel>> getById(String id);

  Future<Either<Failure, String>> create({
    required String projectId,
    required String title,
    String? description,
    required String type,
    required double priceUsd,
    double? areaSqm,
    int? rooms,
    int? floor,
    List<String>? photoUrls,
  });

  Future<Either<Failure, void>> makeOffer({
    required String listingId,
    required double offerPriceUsd,
    String? message,
  });

  Future<Either<Failure, List<PurchaseOfferModel>>> getOffers(String listingId);

  Future<Either<Failure, void>> reviewOffer({
    required String listingId,
    required String offerId,
    required bool approve,
  });
}
