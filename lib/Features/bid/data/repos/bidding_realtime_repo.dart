import 'package:takween/Features/bid/data/models/bidding_events.dart';

abstract class BiddingRealtimeRepo {
  Future<void> ensureConnected();
  Future<void> joinPost(String landPostId);
  Future<void> leavePost(String landPostId);

  Stream<NewBidEvent> get onNewBid;
  Stream<NewBidDetailsEvent> get onNewBidDetails;
  Stream<BidCountEvent> get onBidCount;
  Stream<BidStatusEvent> get onBidAccepted;
  Stream<BidStatusEvent> get onBidRejected;
  Stream<BidStatusEvent> get onBidWithdrawn;
  Stream<BiddingClosedEvent> get onBiddingClosed;

  Future<void> dispose();
}
