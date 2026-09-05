import 'package:flutter/material.dart';

/// The single accent used across the Provider's Order Tracking surface:
/// the navigate screen (route polyline, side buttons, distance chip,
/// location row) and the active-order tracking card on driver home.
///
/// Soft sage green — same hue family as the brand primary (#004B3B) but
/// lighter and desaturated, so it reads as calm progress rather than a
/// second brand colour. One solid colour, no gradients: the order's
/// status is conveyed by icon and label, never by hue.
///
/// Hardcoded (not a ThemeExtension) because the Provider app is locked to
/// light mode — see `themeMode` in main.dart.
///
/// Contrast (WCAG 2.1):
///   accent on white ............ 5.70:1  (AA normal text, AAA large)
///   accent on accentSurface .... 4.91:1  (AA normal text)
///   white text on accent ....... 5.70:1  (AA normal text)
/// The previous value (#4E9C7A) failed AA at 3.30:1 / 2.84:1.
class TrackingColors {
  TrackingColors._();

  /// Foreground: icons, labels, route stroke, and solid button fills
  /// (which carry white text).
  static const Color accent = Color(0xFF2A7355);

  /// Light mint tint for accent surfaces (chips, icon circles).
  static const Color accentSurface = Color(0xFFE4F1EA);
}
