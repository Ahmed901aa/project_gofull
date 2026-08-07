import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/network/app_config.dart';

/// An event received on a Reverb channel.
class ReverbEvent {
  final String channel;
  final String event;
  final Map<String, dynamic> data;
  const ReverbEvent(this.channel, this.event, this.data);
}

/// Minimal Pusher-protocol client for Laravel Reverb using dart:io
/// WebSocket — no extra pub dependency needed.
///
/// Usage:
///   final reverb = ReverbService(apiClient);
///   final sub = reverb
///       .channelStream('private-driver.userId')
///       .listen((e) {
///     if (e.event == 'provider.location.updated') { ... }
///     if (e.event == 'order.status.updated') { ... }
///   });
///   ...
///   sub.cancel();
///   reverb.disconnect();
///
/// Private channels are authorized via POST /broadcasting/auth with the
/// Sanctum Bearer token (handled by [ApiClient]'s interceptor).
class ReverbService {
  final ApiClient apiClient;

  WebSocket? _socket;
  String? _socketId;
  bool _disposed = false;
  int _retrySeconds = 2;
  Timer? _reconnectTimer;

  /// Channels we want subscribed (survive reconnects).
  final Set<String> _channels = {};
  final StreamController<ReverbEvent> _events =
      StreamController<ReverbEvent>.broadcast();

  ReverbService(this.apiClient);

  String get _url {
    final scheme = AppConfig.reverbUseTls ? 'wss' : 'ws';
    return '$scheme://${AppConfig.reverbHost}:${AppConfig.reverbPort}'
        '/app/${AppConfig.reverbAppKey}?protocol=7&client=dart&version=1.0';
  }

  /// Stream of events for [channel] (e.g. 'private-driver.12').
  /// Connects and subscribes lazily.
  Stream<ReverbEvent> channelStream(String channel) {
    _channels.add(channel);
    _ensureConnected();
    return _events.stream.where((e) => e.channel == channel);
  }

  Future<void> _ensureConnected() async {
    if (_disposed || _socket != null) {
      return;
    }
    try {
      final socket = await WebSocket.connect(_url);
      _socket = socket;
      socket.listen(
        _onMessage,
        onDone: _scheduleReconnect,
        onError: (Object e) {
          debugPrint('Reverb error: $e');
          _scheduleReconnect();
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('Reverb connect failed: $e');
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    try {
      final msg = jsonDecode(raw as String) as Map<String, dynamic>;
      final event = msg['event'] as String? ?? '';

      switch (event) {
        case 'pusher:connection_established':
          final data =
              jsonDecode(msg['data'] as String) as Map<String, dynamic>;
          _socketId = data['socket_id'] as String;
          _retrySeconds = 2; // reset backoff
          for (final channel in _channels) {
            _subscribe(channel);
          }
        case 'pusher:ping':
          _send({'event': 'pusher:pong', 'data': {}});
        case 'pusher_internal:subscription_succeeded':
          debugPrint('Reverb subscribed: ${msg['channel']}');
        default:
          if (event.startsWith('pusher')) {
            return;
          }
          final channel = msg['channel'] as String? ?? '';
          final rawData = msg['data'];
          final data = rawData is String
              ? jsonDecode(rawData) as Map<String, dynamic>
              : (rawData as Map<String, dynamic>? ?? {});
          _events.add(ReverbEvent(channel, event, data));
      }
    } catch (e) {
      debugPrint('Reverb message parse error: $e');
    }
  }

  Future<void> _subscribe(String channel) async {
    final socketId = _socketId;
    if (socketId == null) {
      return;
    }

    String? auth;
    if (channel.startsWith('private-') || channel.startsWith('presence-')) {
      try {
        final response = await apiClient.dio.post(
          ApiConstants.broadcastingAuth,
          data: {'socket_id': socketId, 'channel_name': channel},
        );
        auth = (response.data as Map<String, dynamic>)['auth'] as String?;
      } catch (e) {
        debugPrint('Reverb channel auth failed for $channel: $e');
        return;
      }
    }

    _send({
      'event': 'pusher:subscribe',
      'data': {'channel': channel, if (auth != null) 'auth': auth},
    });
  }

  void _send(Map<String, dynamic> payload) {
    try {
      _socket?.add(jsonEncode(payload));
    } catch (e) {
      debugPrint('Reverb send failed: $e');
    }
  }

  void _scheduleReconnect() {
    _socket = null;
    _socketId = null;
    if (_disposed || _channels.isEmpty) {
      return;
    }
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: _retrySeconds), () {
      _retrySeconds = (_retrySeconds * 2).clamp(2, 30);
      _ensureConnected();
    });
  }

  /// Unsubscribe from a channel (stops resubscribing on reconnect).
  void leaveChannel(String channel) {
    _channels.remove(channel);
    _send({
      'event': 'pusher:unsubscribe',
      'data': {'channel': channel},
    });
    if (_channels.isEmpty) {
      disconnect();
    }
  }

  /// Close the socket. The service can reconnect later via [channelStream].
  void disconnect() {
    _reconnectTimer?.cancel();
    _socket?.close();
    _socket = null;
    _socketId = null;
  }

  /// Permanently dispose (app shutdown).
  void dispose() {
    _disposed = true;
    disconnect();
    _events.close();
  }
}
