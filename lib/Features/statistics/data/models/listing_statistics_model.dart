import 'package:json_annotation/json_annotation.dart';
part 'listing_statistics_model.g.dart';
@JsonSerializable()
class ListingStatisticsModel {
  final int totalListings;
  final int activeListings;
  final int soldListings;
  final int pendingOffers;

  ListingStatisticsModel({
    required this.totalListings,
    required this.activeListings,
    required this.soldListings,
    required this.pendingOffers,
  });

  factory ListingStatisticsModel.fromJson(Map<String, dynamic> jsonData) =>
_$ListingStatisticsModelFromJson(jsonData);
  Map<String, dynamic> toJson() => _$ListingStatisticsModelToJson(this);

}
