import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

const String _wsBaseUrl = 'ws://192.168.100.46:8080/ws-native';

class WebSocketService {
  StompClient? _client;

  void connect({
    required String token,
    required String familyId,
    required void Function(Map<String, dynamic> event) onItemEvent,
    required void Function(Map<String, dynamic> event) onPresenceEvent,
  }) {
    _client = StompClient(
      config: StompConfig(
        url: '$_wsBaseUrl?token=$token',
        onConnect: (frame) {
          debugPrint('[WS] Connected');
          _client!.subscribe(
            destination: '/topic/family.$familyId/items',
            callback: (frame) {
              if (frame.body != null) {
                onItemEvent(jsonDecode(frame.body!) as Map<String, dynamic>);
              }
            },
          );
          _client!.subscribe(
            destination: '/topic/family.$familyId/presence',
            callback: (frame) {
              if (frame.body != null) {
                onPresenceEvent(jsonDecode(frame.body!) as Map<String, dynamic>);
              }
            },
          );
        },
        onStompError: (frame) => debugPrint('[WS] STOMP error: ${frame.body}'),
        onWebSocketError: (error) => debugPrint('[WS] WebSocket error: $error'),
        onDisconnect: (_) => debugPrint('[WS] Disconnected'),
        reconnectDelay: Duration.zero, // no auto-reconnect during testing
      ),
    );
    _client!.activate();
  }

  void disconnect() {
    _client?.deactivate();
    _client = null;
  }
}
