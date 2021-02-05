import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImageLoader {
  /// Handle the unexpected nature of the image being a path or an asset.
  /// In addition, formats the image to display uniformly.
  static fromFile(File file, {double borderRadius = 8}) {
    Image image;
    if (file.path.contains('assets')) {
      image = Image.asset(file.path);
    } else {
      image = Image.file(file);
    }

    // Format the image to display uniformly
    return Container(
      constraints: BoxConstraints(minHeight: 100, minWidth: 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image: DecorationImage(
            image: image.image,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center),
      ),
    );
  }
}
