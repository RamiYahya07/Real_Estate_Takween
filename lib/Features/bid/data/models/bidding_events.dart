class NewBidEvent {
  final String bidId;
  final String landPostId;

  NewBidEvent({required this.bidId, required this.landPostId});

  factory NewBidEvent.fromJson(Map<String, dynamic> json) => NewBidEvent(
        bidId: json['bidId']?.toString() ?? '',
        landPostId: json['landPostId']?.toString() ?? '',
      );
}

class NewBidDetailsEvent {
  final String bidId;
  final String landPostId;
  final double? offerPriceUsd;
  final DateTime? createdAt;

  NewBidDetailsEvent({
    required this.bidId,
    required this.landPostId,
    this.offerPriceUsd,
    this.createdAt,
  });

  factory NewBidDetailsEvent.fromJson(Map<String, dynamic> json) {
    DateTime? parsed;
    final raw = json['createdAt'];
    if (raw is String) parsed = DateTime.tryParse(raw);
    if (raw is DateTime) parsed = raw;
    return NewBidDetailsEvent(
      bidId: json['bidId']?.toString() ?? '',
      landPostId: json['landPostId']?.toString() ?? '',
      offerPriceUsd: (json['offerPriceUsd'] as num?)?.toDouble(),
      createdAt: parsed,
    );
  }
}

class BidCountEvent {
  final String landPostId;
  final int count;

  BidCountEvent({required this.landPostId, required this.count});

  factory BidCountEvent.fromJson(Map<String, dynamic> json) => BidCountEvent(
        landPostId: json['landPostId']?.toString() ?? '',
        count: (json['count'] as num?)?.toInt() ?? 0,
      );
}

class BidStatusEvent {
  final String bidId;

  BidStatusEvent({required this.bidId});

  factory BidStatusEvent.fromJson(Map<String, dynamic> json) =>
      BidStatusEvent(bidId: json['bidId']?.toString() ?? '');
}

class BiddingClosedEvent {
  final String landPostId;
  final int acceptedCount;

  BiddingClosedEvent({required this.landPostId, required this.acceptedCount});

  factory BiddingClosedEvent.fromJson(Map<String, dynamic> json) =>
      BiddingClosedEvent(
        landPostId: json['landPostId']?.toString() ?? '',
        acceptedCount: (json['acceptedCount'] as num?)?.toInt() ?? 0,
      );
}
