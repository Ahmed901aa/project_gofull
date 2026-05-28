import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Supported app theme modes.
enum AppThemeMode { system, light, dark }

/// Manages the user's theme preference with persistence.
///
/// Emits [ThemeMode] so MaterialApp can consume it directly.
class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'app_theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeMode.system) {
    _loadSaved();
  }

  /// The raw preference (system / light / dark).
  AppThemeMode get appThemeMode {
    final raw = _prefs.getString(_key);
    switch (raw) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  void _loadSaved() {
    final raw = _prefs.getString(_key);
    switch (raw) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      default:
        emit(ThemeMode.system);
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    switch (mode) {
      case AppThemeMode.system:
        await _prefs.setString(_key, 'system');
        emit(ThemeMode.system);
        break;
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

  /// Whether the *resolved* brightness is currently dark.
  /// Accounts for system theme when mode == system.
  bool get isDark {
    if (state == ThemeMode.dark) {

      return true;

    }
    if (state == ThemeMode.light) {

      return false;

    }
    // System: check platform brightness
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
}
