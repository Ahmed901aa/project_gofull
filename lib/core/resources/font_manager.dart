import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontConstants {
  const FontConstants._();

  /// Cairo for Arabic – designed for Arabic script with good vertical metrics.
  static const String arabicFontFamily = 'Cairo';

  /// Platform default for English (SF Pro on iOS, Roboto on Android).
  /// Gives English UI crisp letter-spacing and natural sizing.
  /// We omit the fontFamily so Flutter falls back to the platform font.
  static const String? englishFontFamily = null;

  /// Legacy accessor – defaults to Cairo for backward compat.
  static String fontFamily = 'Cairo';

  /// Returns the appropriate font family based on locale.
  /// Returns null for English so that Flutter uses the platform default.
  static String? forLocale(Locale locale) =>
      locale.languageCode == 'ar' ? arabicFontFamily : englishFontFamily;
}

class FontWeightManager {
  const FontWeightManager._();
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

/// Locale-aware font sizes.
///
/// Arabic glyphs are taller and wider than Latin, so the same sp value
/// can look too large in Arabic or too small in English.
/// We apply a subtle scale factor per locale to keep text visually balanced.
class FontSize {
  const FontSize._();

  /// Call once from main after ScreenUtilInit so .sp values resolve.
  /// Default is Arabic sizing. English gets a small bump for readability.
  static double _scale = 1.0;

  static void setLocaleScale(Locale locale) {
    // Arabic glyphs in Cairo are already generous; English platform fonts
    // have tighter metrics and benefit from a ~4% bump to feel equal.
    _scale = locale.languageCode == 'ar' ? 1.0 : 1.04;
  }

  static double get s10 => 10.0.sp * _scale;
  static double get s11 => 11.0.sp * _scale;
  static double get s12 => 12.0.sp * _scale;
  static double get s13 => 13.0.sp * _scale;
  static double get s14 => 14.0.sp * _scale;
  static double get s15 => 15.0.sp * _scale;
  static double get s16 => 16.0.sp * _scale;
  static double get s18 => 18.0.sp * _scale;
  static double get s20 => 20.0.sp * _scale;
  static double get s22 => 22.0.sp * _scale;
  static double get s24 => 24.0.sp * _scale;
  static double get s28 => 28.0.sp * _scale;
}
