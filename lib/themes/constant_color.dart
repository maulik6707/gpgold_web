import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConstantColor {
  static statusBar(Color color, Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: color,
      statusBarIconBrightness: brightness, // For Android (dark icons)
      statusBarBrightness: brightness, // For iOS (dark icons)
    ));
  }

  static const Color background = Color(0XFFFFFFFF);

  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff000000);

  static const Color gradientTopColor = Color(0xff000000);
  static const Color gradientCenterColor = Color(0xffED6E61);
  static const Color gradientBottomColor = Color(0xff808080);
  static Color lightPink = const Color(0xffFFDBE1);

  static Color primary = const Color(0xff000000);
  // static Color primary = const Color(0xffFE4B6B);
  static Color primarySecond = const Color(0xffFD625E);
  static Color gray = const Color(0xff858585);
  static Color gray2 = const Color(0xffC5C5C5);

  static const Color lightGrey = Color(0xffE1E2E4);
}