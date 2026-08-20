import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/network/app_config.dart';
import 'package:project_gofull/core/network/server_locator.dart';

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
  bool _connecting = false;
  int _retrySeconds = 2;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  /// Fail fast instead of hanging ~60s on a dead network path
  /// (the classic "Operation timed out, errno = 60").
  static const _connectTimeout = Duration(seconds: 8);

  /// Reverb pings every ~30s (activity_timeout). If we hear nothing for this
  /// long the pipe is dead (IP change, sleep, server restart) — force a
  /// reconnect instead of waiting for the OS to notice.
  static const _heartbeatTimeout = Duration(seconds: 90);

  /// Channels we want subscribed (survive reconnects).
  final Set<String> _channels = {};
  final StreamController<ReverbEvent> _events =
      StreamController<ReverbEvent>.broadcast();

  ReverbService(this.apiClient) {
    // Server moved (Wi‑Fi change) → reconnect the socket to the new host.
    ServerLocator.instance.host.addListener(_onHostChanged);
  }

  void _onHostChanged() {
    if (_disposed || _channels.isEmpty) return;
    debugPrint('Reverb: server host changed → reconnecting');
    _socket?.close();
    _socket = null;
    _socketId = null;
    reconnectNow();
  }

  String get _url {
    final scheme = AppConfig.reverbUseTls ? 'wss' : 'ws';
    // Reverb runs on the same machine as the API — follow the live host.
    final host = ServerLocator.instance.host.value;
    return '$scheme://$host:${AppConfig.reverbPort}'
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
    if (_disposed || _socket != null || _connecting) {
      return;
    }
    _connecting = true;
    try {
      final pending = WebSocket.connect(_url);
      WebSocket socket;
      try {
        socket = await pending.timeout(_connectTimeout);
      } on TimeoutException {
        // `pending` is abandoned but still running; without a handler its
        // eventual completion becomes an unhandled async exception or a
        // leaked socket. Close on late success, swallow late errors.
        pending.then((s) => s.close(), onError: (_) {});
        rethrow;
      }
      if (_disposed) {
        socket.close();
        return;
      }
      _socket = socket;
      _armHeartbeat();
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
    } finally {
      _connecting = false;
    }
  }

  /// (Re)start the dead-connection watchdog. Called on connect and on
  /// every inbound frame.
  void _armHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer(_heartbeatTimeout, () {
      debugPrint('Reverb heartbeat timeout — forcing reconnect');
      _socket?.close();
      _scheduleReconnect();
    });
  }

  void _onMessage(dynamic raw) {
    _armHeartbeat();
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
    _heartbeatTimer?.cancel();
    _socket = null;
    _socketId = null;
    if (_disposed || _channels.isEmpty) {
      return;
    }
    // Already scheduled — don't reset the backoff timer.
    if (_reconnectTimer?.isActive ?? false) {
      return;
    }
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
    _heartbeatTimer?.cancel();
    _socket?.close();
    _socket = null;
    _socketId = null;
  }

  /// Call when the app returns to the foreground so a socket that died while
  /// backgrounded is replaced immediately instead of after the next backoff.
  void reconnectNow() {
    if (_disposed || _channels.isEmpty) {
      return;
    }
    _reconnectTimer?.cancel();
    _retrySeconds = 2;
    if (_socket == null && !_connecting) {
      _ensureConnected();
    }
  }

  /// Permanently dispose (app shutdown).
  void dispose() {
    _disposed = true;
    ServerLocator.instance.host.removeListener(_onHostChanged);
    disconnect();
    _events.close();
  }
}
