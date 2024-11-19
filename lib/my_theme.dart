// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';

class MyTheme {
  static const Color app_accent_color = Color(0xFF3A84BB);
  static Color app_accent_color_extra_light =
      const Color.fromRGBO(233, 233, 240, 1.0);

  static Color splash_screen_color = const Color(
      0xFF3A84BB); // if not sure , use the same color as accent color
  static Color login_reg_screen_color = const Color(
      0xFF3A84BB); // if not sure , use the same color as accent color

  /*configurable colors ends*/

  /*If you are not a developer, do not change the bottom colors*/
  static const Color app_accent_border = Color.fromRGBO(224, 224, 224, 1);
  static const Color app_accent_shado = Color.fromRGBO(0, 0, 0, 0.16);
  static const Color app_accent_tranparent = Color.fromRGBO(0, 0, 0, 0.5);
  static Color white = const Color.fromRGBO(255, 255, 255, 1);
  static const Color noColor = Color.fromRGBO(255, 255, 255, 0);
  static Color light_grey = const Color.fromRGBO(239, 239, 239, 1);
  static Color dark_grey = const Color.fromRGBO(112, 112, 112, 1);
  static Color medium_grey = const Color.fromRGBO(132, 132, 132, 1);
  static Color medium_grey_50 = const Color.fromRGBO(132, 132, 132, .5);
  static const Color grey_153 = Color.fromRGBO(153, 153, 153, 1);
  static const Color font_grey = Color.fromRGBO(73, 73, 73, 1);
  static Color textfield_grey = const Color.fromRGBO(209, 209, 209, 1);
  static Color golden = const Color.fromRGBO(248, 181, 91, 1);
  static Color red = const Color.fromRGBO(255, 0, 0, 1.0);
  static Color green = const Color.fromRGBO(52, 168, 83, 1.0);
  static Color shimmer_base = Colors.grey.shade50;
  static Color shimmer_highlighted = Colors.grey.shade200;
  static const black = Color.fromRGBO(0, 0, 0, 1);

//testing shimmer
/*static Color shimmer_base = Colors.redAccent;
  static Color shimmer_highlighted = Colors.yellow;*/
}
