
class AppConfig {
  const AppConfig._();


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
