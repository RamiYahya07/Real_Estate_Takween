import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:takween/Features/posts/data/models/land_post_created_model.dart';
import 'package:takween/Features/posts/data/models/land_post_item_details_model.dart';
import 'package:takween/Features/posts/data/models/land_post_item_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class LandPostRepo {
  /// create draft post (LandOwner)
  Future<Either<Failure, LandPostCreatedModel>> createDraftLandPost({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String city,
    required String neighborhood,
    required double areaSqm,
    required double plotWidth,
    required double plotDepth,
    required int investmentType,
    required bool isSealedAuction,
    required int maxAcceptedBids,
    required double priceUsd,
    required bool acceptsAdditionalInvestors,
    required int desiredBuildingType,
    required int desiredFloors,
    required String specialRequirements,
    required int ownershipBasis,
    required bool isRepresentative,
  });

  /// upload post documnets (LandOwner)
  Future<Either<Failure, void>> uploadLandPostDocuments({
    required String postId,
    required List<File> documentFiles,
    required List<String> documentTypes,
  });

  /// submit Land Post (LandOnwer)
  Future<Either<Failure, void>> submitDraftLandPost({required String postId});

  /// get land posts (LandOwner + Contractor)
  Future<Either<Failure, List<LandPostItemModel>>> getLandPosts({
    int page,
    int pageSize,
  });

/// get open land posts (Contractor)
  Future<Either<Failure, List<LandPostItemModel>>> getOpenLandPosts({
    int page,
    int pageSize,
  });

  /// get land post details (LandOwner)
  Future<Either<Failure, LandPostItemDetailsModel>> getLandPostDetails(
    String postId,
  );

  /// delete land post (LandOwner)
  Future<Either<Failure, void>> deleteLandPost(String postId);

  /// edit land post (LandOwner)
  Future<Either<Failure, void>> editLandPost({
    required String postId,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String city,
    required String neighborhood,
    required double areaSqm,
    required double plotWidth,
    required double plotDepth,
    required String investmentType,
    required bool isSealedAuction,
    required int maxAcceptedBids,
    required double priceUsd,
    required double pricePerShareUsd,
    required bool acceptsAdditionalInvestors,
    required String desiredBuildingType,
    required int desiredFloors,
    required String specialRequirements,
    required String ownershipBasis,
    required bool isRepresentative,
  });
}
