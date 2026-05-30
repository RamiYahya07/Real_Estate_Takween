import 'dart:async';

import 'package:takween/Features/bid/data/models/bidding_events.dart';
import 'package:takween/Features/bid/data/repos/bidding_realtime_repo.dart';
import 'package:takween/core/realtime/hub_client.dart';

class BiddingRealtimeRepoImpl implements BiddingRealtimeRepo {
  final HubClient hub;

  final StreamController<NewBidEvent> _newBid =
      StreamController<NewBidEvent>.broadcast();
  final StreamController<NewBidDetailsEvent> _newBidDetails =
      StreamController<NewBidDetailsEvent>.broadcast();
  final StreamController<BidCountEvent> _bidCount =
      StreamController<BidCountEvent>.broadcast();
  final StreamController<BidStatusEvent> _bidAccepted =
      StreamController<BidStatusEvent>.broadcast();
  final StreamController<BidStatusEvent> _bidRejected =
      StreamController<BidStatusEvent>.broadcast();
  final StreamController<BidStatusEvent> _bidWithdrawn =
      StreamController<BidStatusEvent>.broadcast();
  final StreamController<BiddingClosedEvent> _biddingClosed =
      StreamController<BiddingClosedEvent>.broadcast();

  bool _bound = false;

  BiddingRealtimeRepoImpl(this.hub);

  @override
  Stream<NewBidEvent> get onNewBid => _newBid.stream;
  @override
  Stream<NewBidDetailsEvent> get onNewBidDetails => _newBidDetails.stream;
  @override
  Stream<BidCountEvent> get onBidCount => _bidCount.stream;
  @override
  Stream<BidStatusEvent> get onBidAccepted => _bidAccepted.stream;
  @override
  Stream<BidStatusEvent> get onBidRejected => _bidRejected.stream;
  @override
  Stream<BidStatusEvent> get onBidWithdrawn => _bidWithdrawn.stream;
  @override
  Stream<BiddingClosedEvent> get onBiddingClosed => _biddingClosed.stream;

  Map<String, dynamic>? _firstAsMap(List<Object?>? args) {
    if (args == null || args.isEmpty || args.first == null) return null;
    final first = args.first;
    if (first is Map<String, dynamic>) return first;
    if (first is Map) return Map<String, dynamic>.from(first);
    return null;
  }

  void _bindEvents() {
    if (_bound) return;
    hub.on('NewBid', (args) {
      final map = _firstAsMap(args);
      if (map != null) _newBid.add(NewBidEvent.fromJson(map));
    });
    hub.on('NewBidDetails', (args) {
      final map = _firstAsMap(args);
      if (map != null) _newBidDetails.add(NewBidDetailsEvent.fromJson(map));
    });
    hub.on('BidCount', (args) {
      final map = _firstAsMap(args);
      if (map != null) _bidCount.add(BidCountEvent.fromJson(map));
    });
    hub.on('BidAccepted', (args) {
      final map = _firstAsMap(args);
      if (map != null) _bidAccepted.add(BidStatusEvent.fromJson(map));
    });
    hub.on('BidRejected', (args) {
      final map = _firstAsMap(args);
      if (map != null) _bidRejected.add(BidStatusEvent.fromJson(map));
    });
    hub.on('BidWithdrawn', (args) {
      final map = _firstAsMap(args);
      if (map != null) _bidWithdrawn.add(BidStatusEvent.fromJson(map));
    });
    hub.on('BiddingClosed', (args) {
      final map = _firstAsMap(args);
      if (map != null) _biddingClosed.add(BiddingClosedEvent.fromJson(map));
    });
    _bound = true;
  }

  @override
  Future<void> ensureConnected() async {
    if (!hub.isConnected) {
      await hub.connect();
    }
    _bindEvents();
  }

  @override
  Future<void> joinPost(String landPostId) async {
    await ensureConnected();
    await hub.invoke('JoinPost', args: [landPostId]);
  }

  @override
  Future<void> leavePost(String landPostId) async {
    if (!hub.isConnected) return;
    await hub.invoke('LeavePost', args: [landPostId]);
  }

  @override
  Future<void> dispose() async {
    hub.off('NewBid');
    hub.off('NewBidDetails');
    hub.off('BidCount');
    hub.off('BidAccepted');
    hub.off('BidRejected');
    hub.off('BidWithdrawn');
    hub.off('BiddingClosed');
    _bound = false;
    await _newBid.close();
    await _newBidDetails.close();
    await _bidCount.close();
    await _bidAccepted.close();
    await _bidRejected.close();
    await _bidWithdrawn.close();
    await _biddingClosed.close();
  }
}
