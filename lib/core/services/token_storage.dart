import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and retrieves the Sanctum Bearer token + basic user info.
class TokenStorage {
  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user';

  final SharedPreferences _prefs;
  TokenStorage(this._prefs);

  // ── Token ─────────────────────────────────────────────────

  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  String? getToken() => _prefs.getString(_keyToken);

  Future<void> deleteToken() async {
    await _prefs.remove(_keyToken);
  }

  bool get isLoggedIn => getToken() != null;

  // ── User ──────────────────────────────────────────────────

  Future<void> saveUser(Map<String, dynamic> userJson) async {
    await _prefs.setString(_keyUser, jsonEncode(userJson));
  }

  Map<String, dynamic>? getUser() {
    final raw = _prefs.getString(_keyUser);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  String? get userRole => getUser()?['role'] as String?;

  Future<void> deleteUser() async {
    await _prefs.remove(_keyUser);
  }

  // ── Clear All ─────────────────────────────────────────────

  Future<void> clearAll() async {
    await deleteToken();
    await deleteUser();
  }
}
