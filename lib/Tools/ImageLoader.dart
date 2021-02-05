import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImageLoader {
  /// Handle the unexpected nature of the image being a path or an asset
  static fromFile(File file) {
    Image image;
    if (file.path.contains('assets')) {
      image = Image.asset(file.path);
    } else {
      image = Image.file(file);
    }

    return Container(
      constraints: BoxConstraints(minHeight: 100, minWidth: 100),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: image.image,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center),
      ),
    );
  }
}
