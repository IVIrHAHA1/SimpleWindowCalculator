import 'package:flutter/material.dart';

class HexColors {
  static Color fromHex(String colorCode) {
    String colorNew = '0xff' + colorCode;
    colorNew = colorNew.replaceAll('#', '');
    int colorInt = int.parse(colorNew);

    return Color(colorInt);
  }
}