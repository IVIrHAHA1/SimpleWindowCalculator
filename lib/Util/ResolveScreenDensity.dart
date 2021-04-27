import 'package:flutter/material.dart';

enum ScreenDensities { idpi, mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi }

class ResolveScreenDensity {
  static ScreenDensities of(BuildContext context) {
    var deviceRatio = MediaQuery.of(context).devicePixelRatio;

    // Idpi
    if(deviceRatio <= 1) {
      return ScreenDensities.idpi;
    }

    // Mdpi
    else if(deviceRatio > 1 && deviceRatio <= 1.5) {
      return ScreenDensities.mdpi;
    }

    // Hdpi
    else if(deviceRatio > 1.5 && deviceRatio <= 2) {
      return ScreenDensities.hdpi;
    }

    // xhdpi
    else if(deviceRatio > 2 && deviceRatio <= 3) {
      return ScreenDensities.xhdpi;
    }

    // xxhdpi
    else if(deviceRatio > 3 && deviceRatio <= 4) {
      return ScreenDensities.xxhdpi;
    }

    // xxxhdpi
    else if(deviceRatio > 4) {
      return ScreenDensities.xxxhdpi;
    }
    else {
      throw Exception("Failed to resolve screen density");
    }
  }
}
