import 'package:flutter/material.dart';
import 'font_manager.dart';

TextStyle _baseStyle(double fontSize, FontWeight weight, Color color) =>
    TextStyle(
      fontSize: fontSize,
      fontFamily: FontConstants.fontFamily,
      fontWeight: weight,
      color: color,
    );

TextStyle getRegularStyle({double? fontSize, required Color color}) =>
    _baseStyle(fontSize ?? FontSize.s14, FontWeightManager.regular, color);

TextStyle getMediumStyle({double? fontSize, required Color color}) =>
    _baseStyle(fontSize ?? FontSize.s14, FontWeightManager.medium, color);

TextStyle getSemiBoldStyle({double? fontSize, required Color color}) =>
    _baseStyle(fontSize ?? FontSize.s14, FontWeightManager.semiBold, color);

TextStyle getBoldStyle({double? fontSize, required Color color}) =>
    _baseStyle(fontSize ?? FontSize.s14, FontWeightManager.bold, color);
