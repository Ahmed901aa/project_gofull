import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _key = 'app_locale';
  static const _supported = ['ar', 'en'];
  final SharedPreferences _prefs;

  LocaleCubit(this._prefs) : super(_initialLocale(_prefs));

  /// Explicit user choice wins; otherwise follow the device language
  /// (constrained to supported locales, Arabic as final fallback).
  static Locale _initialLocale(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    if (saved != null && _supported.contains(saved)) {
      return Locale(saved);
    }
    final device = PlatformDispatcher.instance.locale.languageCode;
    return Locale(_supported.contains(device) ? device : 'ar');
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_key, locale.languageCode);
    emit(locale);
  }

  Future<void> toggleLocale() async {
    final next = state.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    await setLocale(next);
  }

  bool get isArabic => state.languageCode == 'ar';
}
