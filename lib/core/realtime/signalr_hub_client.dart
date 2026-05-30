import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:takween/core/realtime/hub_client.dart';

class SignalRHubClient implements HubClient {
  final String url;
  final Future<String?> Function() getToken;

  HubConnection? _connection;
  final StreamController<HubConnectionState> _stateController =
      StreamController<HubConnectionState>.broadcast();

  SignalRHubClient({required this.url, required this.getToken});

  @override
  bool get isConnected =>
      _connection?.state == HubConnectionState.Connected;

  @override
  Stream<HubConnectionState> get connectionStateStream =>
      _stateController.stream;

  @override
  Future<void> connect() async {
    if (_connection?.state == HubConnectionState.Connected ||
        _connection?.state == HubConnectionState.Connecting) {
      return;
    }

    final connection = HubConnectionBuilder()
        .withUrl(
          url,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => (await getToken()) ?? '',
            transport: HttpTransportType.WebSockets,
            skipNegotiation: true,
            logMessageContent: kDebugMode,
          ),
        )
        .withAutomaticReconnect()
        .build();

    connection.onclose(({Exception? error}) {
      _stateController.add(HubConnectionState.Disconnected);
    });
    connection.onreconnecting(({Exception? error}) {
      _stateController.add(HubConnectionState.Reconnecting);
    });
    connection.onreconnected(({String? connectionId}) {
      _stateController.add(HubConnectionState.Connected);
    });

    try {
      await connection.start();
      _connection = connection;
      _stateController.add(HubConnectionState.Connected);
    } catch (e) {
      _stateController.add(HubConnectionState.Disconnected);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    final c = _connection;
    if (c == null) return;
    try {
      await c.stop();
    } finally {
      _connection = null;
      _stateController.add(HubConnectionState.Disconnected);
    }
  }

  @override
  void on(String event, void Function(List<Object?>? args) handler) {
    _connection?.on(event, handler);
  }

  @override
  void off(String event) {
    _connection?.off(event);
  }

  @override
  Future<dynamic> invoke(String method, {List<Object> args = const []}) async {
    if (_connection == null ||
        _connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    return _connection!.invoke(method, args: args);
  }
}
