import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

const String _wsBaseUrl = 'ws://195.201.17.91/ws-native';

class WebSocketService {
  StompClient? _client;
  final ValueNotifier<bool> connectionStatus = ValueNotifier(false);

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
          connectionStatus.value = true;
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
        onStompError: (frame) {
          debugPrint('[WS] STOMP error: ${frame.body}');
          connectionStatus.value = false;
        },
        onWebSocketError: (error) {
          debugPrint('[WS] WebSocket error: $error');
          connectionStatus.value = false;
        },
        onDisconnect: (_) {
          debugPrint('[WS] Disconnected');
          connectionStatus.value = false;
        },
        reconnectDelay: const Duration(seconds: 5),
      ),
    );
    _client!.activate();
  }

  void disconnect() {
    _client?.deactivate();
    _client = null;
    connectionStatus.value = false;
  }
}
