import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Supported app theme modes. System theme is intentionally NOT supported —
/// the app always uses the user's explicit choice (Light or Dark) and ignores
/// the OS theme.
enum AppThemeMode { light, dark }

/// Manages the user's theme preference with persistence.
///
/// Emits [ThemeMode] (only `light` or `dark`) so MaterialApp can consume it
/// directly. Defaults to [ThemeMode.light] when no value has been persisted.
class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'app_theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeMode.light) {
    _loadSaved();
  }

  /// The raw preference (light / dark). Defaults to light.
  AppThemeMode get appThemeMode {
    final raw = _prefs.getString(_key);
    if (raw == 'dark') return AppThemeMode.dark;
    return AppThemeMode.light;
  }

  void _loadSaved() {
    final raw = _prefs.getString(_key);
    emit(raw == 'dark' ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    switch (mode) {
      case AppThemeMode.light:
        await _prefs.setString(_key, 'light');
        emit(ThemeMode.light);
        break;
      case AppThemeMode.dark:
        await _prefs.setString(_key, 'dark');
        emit(ThemeMode.dark);
        break;
    }
  }

  /// Whether the resolved brightness is currently dark.
  bool get isDark => state == ThemeMode.dark;
}
