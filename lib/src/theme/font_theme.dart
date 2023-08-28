import 'package:flutter/cupertino.dart';

import 'color_theme.dart';

class FontTheme {
  static const TextStyle headline1 = TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle headline2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle headline3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle subtitle1 = TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: ColorTheme.white);
  static const TextStyle subtitle2 = TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ColorTheme.white);

  static const TextStyle subtitle1WhiteBold = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTheme.white);
  static const TextStyle subtitle1GreyBold = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTheme.greyPoint);
  static const TextStyle subtitle2Point = TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ColorTheme.capybaraPoint);
  static const TextStyle subtitle2PointBold = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorTheme.capybaraPoint);
}