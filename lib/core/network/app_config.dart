/// App configuration — change [baseUrl] to your machine's IP for real-device testing.
class AppConfig {
  const AppConfig._();

  /// ─── Base URL ────────────────────────────────────────────
  /// Emulator  : http://10.0.2.2:8000/api
  /// Real device: http://<YOUR_IP>:8000/api
  static const String baseUrl = 'http://192.168.1.163:8000/api';
}
