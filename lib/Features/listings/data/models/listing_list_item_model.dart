import 'package:json_annotation/json_annotation.dart';

part 'listing_list_item_model.g.dart';

@JsonSerializable()
class ListingListItemModel {
  final String id;
  final String title;
  final String type;
  final String status;
  final double priceUsd;
  final double? areaSqm;
  final int? rooms;
  final String? city;
  final int offerCount;
  final DateTime createdAt;

  ListingListItemModel({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.priceUsd,
    this.areaSqm,
    this.rooms,
    this.city,
    required this.offerCount,
    required this.createdAt,
  });

  factory ListingListItemModel.fromJson(Map<String, dynamic> json) =>
      _$ListingListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListingListItemModelToJson(this);
}
