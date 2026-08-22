import 'package:flutter/material.dart';
import 'font_manager.dart';

/// Base text style builder.
/// When [locale] is provided, picks the correct font family automatically.
/// For English, fontFamily is null so Flutter uses the platform default
/// (SF Pro on iOS, Roboto on Android).
TextStyle _baseStyle(
  double fontSize,
  FontWeight weight,
  Color color, {
  Locale? locale,
  double? height,
}) {
  final family = locale != null
      ? FontConstants.forLocale(locale)
      : FontConstants.fontFamily;
  return TextStyle(
    fontSize: fontSize,
    fontFamily: family,
    fontWeight: weight,
    color: color,
    height: height,
  );
}

TextStyle getRegularStyle({
  double? fontSize,
  required Color color,
  Locale? locale,
  double? height,
}) =>
    _baseStyle(
      fontSize ?? FontSize.s14,
      FontWeightManager.regular,
      color,
      locale: locale,
      height: height,
    );

TextStyle getMediumStyle({
  double? fontSize,
  required Color color,
  Locale? locale,
  double? height,
}) =>
    _baseStyle(
      fontSize ?? FontSize.s14,
      FontWeightManager.medium,
      color,
      locale: locale,
      height: height,
    );

TextStyle getSemiBoldStyle({
  double? fontSize,
  required Color color,
  Locale? locale,
  double? height,
}) =>
    _baseStyle(
      fontSize ?? FontSize.s14,
      FontWeightManager.semiBold,
      color,
      locale: locale,
      height: height,
    );

TextStyle getBoldStyle({
  double? fontSize,
  required Color color,
  Locale? locale,
  double? height,
}) =>
    _baseStyle(
      fontSize ?? FontSize.s14,
      FontWeightManager.bold,
      color,
      locale: locale,
      height: height,
    );
