import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Finds the dev backend on the local network at RUNTIME so the app keeps
/// working when the Mac changes Wi‑Fi or the API lands on another port —
/// no rebuild, no code edit, works even when launched from the IDE without
/// `./run.sh`'s dart-defines.
///
/// Host resolution order (first reachable wins):
///   1. `SERVER_HOST` (.local mDNS name, e.g. UserMacs-MacBook-Air.local) —
///      follows the Mac across networks automatically.
///   2. Last host that worked (cached in SharedPreferences).
///   3. `SERVER_IP` baked in at build time (`--dart-define`).
///
/// For each host, ports are probed in parallel: last-good port, build-time
/// `API_PORT`, then 8000–8005 — because `php artisan serve` silently
/// auto-increments past a busy port, so the API may sit on 8001/8002/…
///
/// "Reachable" = GET /api/app/settings answers 200 within ~1.5 s, which
/// proves it's actually our Laravel API and not some other local server.
class ServerLocator {
  ServerLocator._();
  static final ServerLocator instance = ServerLocator._();

  static const _hostPrefKey = 'last_good_server_ip';
  static const _portPrefKey = 'last_good_api_port';
  static const _probeTimeout = Duration(milliseconds: 1500);

  static const String buildHost =
      String.fromEnvironment('SERVER_HOST', defaultValue: '');
  static const String buildIp =
      String.fromEnvironment('SERVER_IP', defaultValue: '127.0.0.1');
  static const int buildPort =
      int.fromEnvironment('API_PORT', defaultValue: 8000);

  static const List<int> _portSweep = [8000, 8001, 8002, 8003, 8004, 8005];

  /// The host currently in use. Starts as the build-time IP so nothing
  /// blocks; [resolve] upgrades it in the background. (Reverb listens to
  /// this — its own port is fixed, so it only cares about host changes.)
  final ValueNotifier<String> host = ValueNotifier(buildIp);

  /// The API port currently in use; [resolve] may move it within [_portSweep].
  int apiPort = buildPort;

  String get baseUrl => 'http://${host.value}:$apiPort/api';

  bool _resolving = false;

  /// Probe candidates and switch [host]/[apiPort] to the first API that
  /// answers. Safe to call repeatedly (startup, app-resume, network error).
  Future<void> resolve() async {
    if (_resolving) return;
    _resolving = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final hosts = {
        if (buildHost.isNotEmpty) buildHost,
        ?prefs.getString(_hostPrefKey),
        buildIp,
      }.toList(); // set literal de-dupes, preserves insertion order
      final ports = {
        ?prefs.getInt(_portPrefKey),
        buildPort,
        ..._portSweep,
      }.toList();

      for (final h in hosts) {
        final p = await _findApiPort(h, ports);
        if (p != null) {
          if (host.value != h || apiPort != p) {
            debugPrint('ServerLocator → using $h:$p');
          }
          apiPort = p;
          host.value = h;
          await prefs.setString(_hostPrefKey, h);
          await prefs.setInt(_portPrefKey, p);
          return;
        }
      }
      debugPrint(
          'ServerLocator → no candidate reachable; keeping ${host.value}:$apiPort');
    } finally {
      _resolving = false;
    }
  }

  /// Probe all [ports] on [h] concurrently; return the first (in list order)
  /// where our API answers, so one sweep costs ~1.5 s, not ports × 1.5 s.
  Future<int?> _findApiPort(String h, List<int> ports) async {
    final alive = await Future.wait([for (final p in ports) _apiAlive(h, p)]);
    for (var i = 0; i < ports.length; i++) {
      if (alive[i]) return ports[i];
    }
    return null;
  }

  Future<bool> _apiAlive(String h, int p) async {
    final client = HttpClient()..connectionTimeout = _probeTimeout;
    try {
      final request = await client
          .getUrl(Uri.parse('http://$h:$p/api/app/settings'))
          .timeout(_probeTimeout);
      final response = await request.close().timeout(_probeTimeout);
      await response.drain<void>();
      return response.statusCode == 200;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }
}
