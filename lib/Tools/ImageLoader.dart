import 'dart:io';
import 'package:flutter/material.dart';

class ImageLoader {
  /// Handle the unexpected nature of the image being a path or an asset
  static Image fromFile(File file) {
    return Image.file(
      file,
      // Builds in case image is actually an asset
      errorBuilder: (ctx, _, __) {
        return Image.asset(file.path);
      },
    );
  }
}
