import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_theme.dart';
import 'dart:ui' as ui;

class FontTheme {
  static const TextStyle headline1 = TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle headline2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle headline3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle subtitle1 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorTheme.white);
  static const TextStyle subtitle2 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorTheme.white);
  static const TextStyle subtitle3 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ColorTheme.white);

  static const TextStyle subtitle1GreyLightest = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorTheme.greyLightest);
  static const TextStyle subtitle1WhiteBold = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle subtitle1GreyBold = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTheme.greyPoint);
  static const TextStyle subtitle1_bold = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle subtitle1BlackBold = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTheme.blackPoint);
  static const TextStyle subtitle2Bold = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle subtitle2_greyLightest = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorTheme.greyLightest);
  static const TextStyle subtitle2Point = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ColorTheme.capybaraPoint);
  static const TextStyle subtitle2PointBold = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorTheme.capybaraPoint);

  static const TextStyle subtitle3_greyLightest = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ColorTheme.greyLightest);
  static const TextStyle subtitle3_point = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ColorTheme.capybaraPoint);

  static TextStyle gradientYellow = TextStyle(fontSize: 26, fontWeight: FontWeight.w600,
      foreground: Paint()..shader = const LinearGradient(
        colors: <Color>[Color(0xffFFC800), Color(0xffFF6400)],
      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)));

  static const TextStyle textField_title = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle textField = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorTheme.white);
}