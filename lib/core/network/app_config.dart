/// App configuration — change [baseUrl] to your machine's IP for real-device testing.
class AppConfig {
  const AppConfig._();

  /// ─── Base URL ────────────────────────────────────────────
  /// Emulator  : http://10.0.2.2:8000/api
  /// Real device: http://YOUR_IP:8000/api
  static const String baseUrl = 'http://192.168.1.144:8000/api';

  /// ─── Reverb (WebSocket) ──────────────────────────────────
  /// Must match REVERB_* in the Laravel .env
  static const String reverbHost = '192.168.1.144';
  static const int reverbPort = 8080;
  static const String reverbAppKey = 'go-full-key';
  static const bool reverbUseTls = false;
}
