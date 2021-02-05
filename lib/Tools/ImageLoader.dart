import 'dart:io';
import 'package:flutter/material.dart';

class ImageLoader {
  /// Handle the unexpected nature of the image being a path or an asset
  static fromFile(File file) {
    if (file.path.contains('assets')) {
      return Image.asset(file.path);
    } else {
      return Image.file(file);
    }
  }
}
