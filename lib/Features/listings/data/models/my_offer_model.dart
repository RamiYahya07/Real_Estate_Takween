class MyOfferModel {
  final String id;
  final String listingId;
  final String listingTitle;
  final String? listingImageUrl;
  final String? listingCity;
  final double offerPriceUsd;
  final double listingAskingPriceUsd;
  final String status;
  final String? message;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  MyOfferModel({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    this.listingImageUrl,
    this.listingCity,
    required this.offerPriceUsd,
    required this.listingAskingPriceUsd,
    required this.status,
    this.message,
    required this.createdAt,
    this.reviewedAt,
  });

  factory MyOfferModel.fromJson(Map<String, dynamic> json) {
    return MyOfferModel(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      listingTitle: json['listingTitle'] as String? ?? '',
      listingImageUrl: json['listingImageUrl'] as String?,
      listingCity: json['listingCity'] as String?,
      offerPriceUsd: (json['offerPriceUsd'] as num?)?.toDouble() ?? 0,
      listingAskingPriceUsd:
          (json['listingAskingPriceUsd'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'PENDING',
      message: json['message'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
    );
  }
}
