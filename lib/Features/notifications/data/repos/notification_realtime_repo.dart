abstract class NotificationRealtimeRepo {
  Stream<void> get onAny;
  Future<void> ensureConnected();
  Future<void> dispose();
}
