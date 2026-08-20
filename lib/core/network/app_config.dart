/// App network configuration.
///
/// The server IP is NOT hardcoded. It's injected at build/run time via
/// `--dart-define=SERVER_IP=…`, so switching Wi‑Fi never requires a code
/// edit. Use the helper script:
///
///     ./run.sh                    # auto-detects your Mac's LAN IP
///     ./run.sh -d <deviceId>      # any extra flutter args pass through
///
/// Or manually:
///     flutter run --dart-define=SERVER_IP=192.168.1.50
///
/// With no define, falls back to localhost-style defaults that work on the
/// iOS simulator (which shares the Mac's network stack).
class AppConfig {
  const AppConfig._();

  /// Server IP / host injected at build time. Falls back to the iOS-simulator
  /// default. Android emulator needs 10.0.2.2 — pass it via --dart-define.
  static const String serverIp =
      String.fromEnvironment('SERVER_IP', defaultValue: '127.0.0.1');

  static const int apiPort =
      int.fromEnvironment('API_PORT', defaultValue: 8000);

  /// ─── Base URL ────────────────────────────────────────────
  static const String baseUrl = 'http://$serverIp:$apiPort/api';

  /// ─── Reverb (WebSocket) ──────────────────────────────────
  /// Must match REVERB_* in the Laravel .env
  static const String reverbHost = serverIp;
  static const int reverbPort =
      int.fromEnvironment('REVERB_PORT', defaultValue: 8080);
  static const String reverbAppKey =
      String.fromEnvironment('REVERB_KEY', defaultValue: 'go-full-key');
  static const bool reverbUseTls =
      bool.fromEnvironment('REVERB_TLS', defaultValue: false);
}
