import 'dart:async';

import 'package:takween/Features/notifications/data/repos/notification_realtime_repo.dart';
import 'package:takween/core/realtime/hub_client.dart';

class NotificationRealtimeRepoImpl implements NotificationRealtimeRepo {
  final HubClient hub;

  final StreamController<void> _onAny = StreamController<void>.broadcast();
  bool _bound = false;

  NotificationRealtimeRepoImpl(this.hub);

  static const List<String> _events = [
    'BidPlaced',
    'BidAccepted',
    'PostAwarded',
    'BidRejected',
    'BidWithdrawn',
    'BidEdited',
    'PostOpened',
    'PostPublished',
    'DocumentVerified',
    'DocumentRejected',
    'ContractGenerated',
    'ContractSigned',
    'ProjectStatusChanged',
    'MilestoneAdded',
    'MilestoneStatusChanged',
    'MilestoneReworkRequested',
    'UnitsCreated',
    'UnitsAllocated',
    'ShareListingCreated',
    'ShareListingFilled',
    'InvestorRequestSubmitted',
    'InvestorRequestReviewed',
    'OfferReceived',
    'OfferReviewed',
    'ListingStatusChanged',
    'OfferCountered',
    'ChatMessageSent',
    'PaymentReceived',
    'PaymentFailed',
    'PaymentRefunded',
  ];

  @override
  Stream<void> get onAny => _onAny.stream;

  void _bindEvents() {
    if (_bound) return;
    for (final event in _events) {
      hub.on(event, (_) {
        if (!_onAny.isClosed) _onAny.add(null);
      });
    }
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
  Future<void> dispose() async {
    for (final event in _events) {
      hub.off(event);
    }
    _bound = false;
    await _onAny.close();
  }
}
