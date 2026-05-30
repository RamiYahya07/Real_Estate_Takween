import 'dart:io';

class CreatePostModel {
  /// STEP 1
  String? title;
  String? description;
  String? city;
  String? neighborhood;
  double? latitude;
  double? longitude;

  /// STEP 2
  double? areaSqm;
  double? plotWidth;
  double? plotDepth;

  int? ownershipBasis;        
  int? desiredBuildingType; 
  int? desiredFloors;

  /// STEP 3
  int? investmentType;       
  double? priceUsd;
  double? pricePerShareUsd;  
  int? maxAcceptedBids;

  bool isSealedAuction = false;
  bool acceptsAdditionalInvestors = false;
  bool isRepresentative = false;

  String? specialRequirements;

  /// STEP 4
  List<File> documents = [];
  List<String> documentTypes = [];

  /// AFTER CREATE DRAFT
  String? postId;
}