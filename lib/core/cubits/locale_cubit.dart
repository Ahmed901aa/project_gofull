import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _key = 'app_locale';
  final SharedPreferences _prefs;

  LocaleCubit(this._prefs) : super(const Locale('ar')) {
    _loadSaved();
  }

  void _loadSaved() {
    final code = _prefs.getString(_key);
    if (code != null) {
      emit(Locale(code));
    }
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
