import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class CustomColors{
  static Color background = Color.fromRGBO(28, 29, 50, 1);
  static Color bottomBackground = Color.fromRGBO(255, 241, 217, 1);
  static Color splashBackground = Color.fromRGBO(255, 161, 0, 1);
  static Color front = Color.fromRGBO(47, 48, 69, 1);
  static Color office = Color.fromRGBO(254, 52, 76, 1);
  static Color attendance = Color.fromRGBO(211, 5, 105, 1);
  static Color history = Color.fromRGBO(0, 155, 113, 1);
  static Color present = Color.fromRGBO(135, 203, 84, 1);
  static Color absent = Color.fromRGBO(237, 73, 78, 1);
}

class CustomRandomColor {
  Color next(index) {
    RandomColor _randomColor = RandomColor(index + 5);
    Color color =
        _randomColor.randomColor(colorBrightness: ColorBrightness.light);
    return color;
  }
}