import 'package:signalr_netcore/signalr_client.dart';

abstract class HubClient {
  Future<void> connect();
  Future<void> disconnect();
  void on(String event, void Function(List<Object?>? args) handler);
  void off(String event);
  Future<dynamic> invoke(String method, {List<Object> args = const []});
  bool get isConnected;
  Stream<HubConnectionState> get connectionStateStream;
}
