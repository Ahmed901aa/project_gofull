import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────
// Semantic color tokens — the ONLY source of truth for UI colors.
// Every widget uses `context.colors.xxx` instead of hardcoded values.
// ─────────────────────────────────────────────────────────────

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  // ── Text ───────────────────────────────────────────────────
  final Color textPrimary;        // Main body / heading text
  final Color textSecondary;      // Subtitles, captions
  final Color textDisabled;       // Disabled / placeholder
  final Color textOnPrimary;      // Text on primary-colored surfaces
  final Color textOnDark;         // Text on dark overlays (always white)

  // ── Surfaces ───────────────────────────────────────────────
  final Color background;         // Scaffold / page background
  final Color surface;            // Cards, dialogs, sheets
  final Color surfaceVariant;     // Slightly tinted surface (input fills, chips)
  final Color surfaceElevated;    // Elevated cards (second-level)
  final Color surfaceOverlay;     // Modal overlays, scrims

  // ── Brand / accent ─────────────────────────────────────────
  final Color primary;            // Main brand color
  final Color primaryLight;       // Lighter primary (hover/focus)
  final Color primarySurface;     // Primary-tinted surface (badges, tags)
  final Color onPrimary;          // Content on primary surfaces

  // ── Borders & dividers ─────────────────────────────────────
  final Color border;             // Default borders
  final Color borderSubtle;       // Very subtle dividers
  final Color divider;            // Divider lines

  // ── Input ──────────────────────────────────────────────────
  final Color inputFill;          // TextField background
  final Color inputBorder;        // TextField border
  final Color inputFocusBorder;   // TextField focus ring

  // ── Status ─────────────────────────────────────────────────
  final Color success;
  final Color error;
  final Color warning;
  final Color info;
  final Color successSurface;     // Light tint behind success
  final Color errorSurface;       // Light tint behind error
  final Color warningSurface;     // Light tint behind warning

  // ── Misc ───────────────────────────────────────────────────
  final Color shadow;             // Box shadow color
  final Color shimmerBase;        // Shimmer / skeleton base
  final Color shimmerHighlight;   // Shimmer highlight
  final Color icon;               // Default icon color
  final Color iconSecondary;      // Secondary icons
  final Color gold;               // Accent gold
  final Color goldLight;          // Gold surface

  const AppThemeColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.textOnPrimary,
    required this.textOnDark,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceElevated,
    required this.surfaceOverlay,
    required this.primary,
    required this.primaryLight,
    required this.primarySurface,
    required this.onPrimary,
    required this.border,
    required this.borderSubtle,
    required this.divider,
    required this.inputFill,
    required this.inputBorder,
    required this.inputFocusBorder,
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.successSurface,
    required this.errorSurface,
    required this.warningSurface,
    required this.shadow,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.icon,
    required this.iconSecondary,
    required this.gold,
    required this.goldLight,
  });

  @override
  ThemeExtension<AppThemeColors> copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? textOnPrimary,
    Color? textOnDark,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceElevated,
    Color? surfaceOverlay,
    Color? primary,
    Color? primaryLight,
    Color? primarySurface,
    Color? onPrimary,
    Color? border,
    Color? borderSubtle,
    Color? divider,
    Color? inputFill,
    Color? inputBorder,
    Color? inputFocusBorder,
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Color? successSurface,
    Color? errorSurface,
    Color? warningSurface,
    Color? shadow,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? icon,
    Color? iconSecondary,
    Color? gold,
    Color? goldLight,
  }) {
    return AppThemeColors(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textOnDark: textOnDark ?? this.textOnDark,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceOverlay: surfaceOverlay ?? this.surfaceOverlay,
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primarySurface: primarySurface ?? this.primarySurface,
      onPrimary: onPrimary ?? this.onPrimary,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      divider: divider ?? this.divider,
      inputFill: inputFill ?? this.inputFill,
      inputBorder: inputBorder ?? this.inputBorder,
      inputFocusBorder: inputFocusBorder ?? this.inputFocusBorder,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      successSurface: successSurface ?? this.successSurface,
      errorSurface: errorSurface ?? this.errorSurface,
      warningSurface: warningSurface ?? this.warningSurface,
      shadow: shadow ?? this.shadow,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      icon: icon ?? this.icon,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      gold: gold ?? this.gold,
      goldLight: goldLight ?? this.goldLight,
    );
  }

  @override
  ThemeExtension<AppThemeColors> lerp(
      covariant ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {

      return this;

    }
    return AppThemeColors(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      textOnDark: Color.lerp(textOnDark, other.textOnDark, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceOverlay: Color.lerp(surfaceOverlay, other.surfaceOverlay, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primarySurface: Color.lerp(primarySurface, other.primarySurface, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputFocusBorder: Color.lerp(inputFocusBorder, other.inputFocusBorder, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      successSurface: Color.lerp(successSurface, other.successSurface, t)!,
      errorSurface: Color.lerp(errorSurface, other.errorSurface, t)!,
      warningSurface: Color.lerp(warningSurface, other.warningSurface, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldLight: Color.lerp(goldLight, other.goldLight, t)!,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Convenience extension — `context.colors.textPrimary`
// ─────────────────────────────────────────────────────────────

extension AppThemeX on BuildContext {
  AppThemeColors get colors =>
      Theme.of(this).extension<AppThemeColors>()!;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

// ─────────────────────────────────────────────────────────────
//  LIGHT palette
// ─────────────────────────────────────────────────────────────

const _lightColors = AppThemeColors(
  // Text
  textPrimary: Color(0xFF0E0E0E),
  textSecondary: Color(0xFF838485),     // neutral800
  textDisabled: Color(0xFFAAAAAB),
  textOnPrimary: Color(0xFFFFFFFF),
  textOnDark: Color(0xFFFFFFFF),

  // Surfaces
  background: Color(0xFFF8F9FA),        // scaffoldBg
  surface: Color(0xFFFFFFFF),
  surfaceVariant: Color(0xFFF4F5F6),    // neutral300
  surfaceElevated: Color(0xFFF2F3F4),   // neutral400
  surfaceOverlay: Color(0x52000000),    // ~32% black

  // Brand
  primary: Color(0xFF004B3B),
  primaryLight: Color(0xFF1A6B54),
  primarySurface: Color(0xFFE6EDEB),    // primary50
  onPrimary: Color(0xFFFFFFFF),

  // Borders
  border: Color(0xFFEFF0F1),            // neutral500
  borderSubtle: Color(0xFFF5F5F5),
  divider: Color(0xFFEEEEEE),

  // Inputs
  inputFill: Color(0xFFF8F8F9),         // neutral200
  inputBorder: Color(0xFFEFF0F1),
  inputFocusBorder: Color(0xFF004B3B),  // primary

  // Status
  success: Color(0xFF4CAF50),
  error: Color(0xFFE53935),
  warning: Color(0xFFFFA726),
  info: Color(0xFF2196F3),
  successSurface: Color(0xFFE8F5E9),
  errorSurface: Color(0xFFFFEBEE),
  warningSurface: Color(0xFFFFF3E0),

  // Misc
  shadow: Color(0x1A000000),            // 10% black
  shimmerBase: Color(0xFFE0E0E0),
  shimmerHighlight: Color(0xFFF5F5F5),
  icon: Color(0xFF0E0E0E),
  iconSecondary: Color(0xFF838485),
  gold: Color(0xFFD4A843),
  goldLight: Color(0xFFF5E6C5),
);

// ─────────────────────────────────────────────────────────────
//  DARK palette
// ─────────────────────────────────────────────────────────────

const _darkColors = AppThemeColors(
  // Text — high contrast whites (WCAG AA 4.5:1 min)
  textPrimary: Color(0xFFECECEC),       // ~93% white — 14.7:1 on #121212
  textSecondary: Color(0xFFA0A0A0),     // ~63% — 6.3:1 on #121212
  textDisabled: Color(0xFF6B6B6B),      // muted
  textOnPrimary: Color(0xFFFFFFFF),
  textOnDark: Color(0xFFFFFFFF),

  // Surfaces — Material dark elevation system
  background: Color(0xFF121212),        // base dark
  surface: Color(0xFF1E1E1E),           // cards / dialogs
  surfaceVariant: Color(0xFF2A2A2A),    // chips / input fills
  surfaceElevated: Color(0xFF333333),   // elevated cards
  surfaceOverlay: Color(0x99000000),    // ~60% black

  // Brand — slightly lighter/brighter for dark backgrounds
  primary: Color(0xFF2E9B7F),           // boosted green for visibility
  primaryLight: Color(0xFF4DB89A),
  primarySurface: Color(0xFF1A3A30),    // dark tinted surface
  onPrimary: Color(0xFFFFFFFF),

  // Borders — subtle light on dark
  border: Color(0xFF3A3A3A),
  borderSubtle: Color(0xFF2C2C2C),
  divider: Color(0xFF2E2E2E),

  // Inputs
  inputFill: Color(0xFF252525),
  inputBorder: Color(0xFF3A3A3A),
  inputFocusBorder: Color(0xFF2E9B7F),  // dark primary

  // Status — desaturated slightly for dark mode harmony
  success: Color(0xFF66BB6A),
  error: Color(0xFFEF5350),
  warning: Color(0xFFFFB74D),
  info: Color(0xFF42A5F5),
  successSurface: Color(0xFF1B3A1E),
  errorSurface: Color(0xFF3A1A1A),
  warningSurface: Color(0xFF3A2E1A),

  // Misc
  shadow: Color(0x00000000),            // no shadow in dark mode
  shimmerBase: Color(0xFF2A2A2A),
  shimmerHighlight: Color(0xFF3D3D3D),
  icon: Color(0xFFD0D0D0),
  iconSecondary: Color(0xFF8A8A8A),
  gold: Color(0xFFE0B85C),
  goldLight: Color(0xFF3A3020),
);

// ─────────────────────────────────────────────────────────────
//  ThemeData builders
// ─────────────────────────────────────────────────────────────

ThemeData buildLightTheme({String? fontFamily}) {
  return _buildTheme(
    brightness: Brightness.light,
    colors: _lightColors,
    fontFamily: fontFamily,
  );
}

ThemeData buildDarkTheme({String? fontFamily}) {
  return _buildTheme(
    brightness: Brightness.dark,
    colors: _darkColors,
    fontFamily: fontFamily,
  );
}

ThemeData _buildTheme({
  required Brightness brightness,
  required AppThemeColors colors,
  String? fontFamily,
}) {
  final isDark = brightness == Brightness.dark;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: colors.primary,
    onPrimary: colors.onPrimary,
    primaryContainer: colors.primarySurface,
    onPrimaryContainer: colors.primary,
    secondary: colors.primary,
    onSecondary: colors.onPrimary,
    surface: colors.surface,
    onSurface: colors.textPrimary,
    error: colors.error,
    onError: Colors.white,
    outline: colors.border,
    outlineVariant: colors.borderSubtle,
    shadow: colors.shadow,
    surfaceContainerHighest: colors.surfaceVariant,
  );

  return ThemeData(
    brightness: brightness,
    fontFamily: fontFamily,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.background,
    canvasColor: colors.surface,
    cardColor: colors.surface,
    dividerColor: colors.divider,
    shadowColor: colors.shadow,
    splashColor: colors.primary.withValues(alpha: 0.08),
    highlightColor: colors.primary.withValues(alpha: 0.04),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      iconTheme: IconThemeData(color: colors.icon),
    ),

    // Bottom Nav
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.iconSecondary,
    ),

    // Text
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: fontFamily, color: colors.textPrimary),
      bodyMedium: TextStyle(fontFamily: fontFamily, color: colors.textPrimary),
      bodySmall: TextStyle(fontFamily: fontFamily, color: colors.textSecondary),
      titleLarge: TextStyle(fontFamily: fontFamily, color: colors.textPrimary),
      titleMedium: TextStyle(fontFamily: fontFamily, color: colors.textPrimary),
      titleSmall: TextStyle(fontFamily: fontFamily, color: colors.textPrimary),
      labelLarge: TextStyle(fontFamily: fontFamily, color: colors.textPrimary),
      labelMedium: TextStyle(fontFamily: fontFamily, color: colors.textSecondary),
      labelSmall: TextStyle(fontFamily: fontFamily, color: colors.textSecondary),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.inputFill,
      hintStyle: TextStyle(color: colors.textDisabled),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.inputFocusBorder, width: 1.5),
      ),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // BottomSheet
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark ? colors.surfaceElevated : const Color(0xFF323232),
      contentTextStyle: TextStyle(color: Colors.white, fontFamily: fontFamily),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: colors.divider,
      thickness: 1,
    ),

    // Icon
    iconTheme: IconThemeData(color: colors.icon),

    // Extensions
    extensions: [colors],
  );
}
