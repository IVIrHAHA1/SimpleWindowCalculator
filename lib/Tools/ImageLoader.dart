import 'dart:io';
import 'package:SimpleWindowCalculator/Tools/Calculator.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as paths;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:image_picker/image_picker.dart';

/// Creates a file using the systems's camera or pulls a file using the gallery.
/// In other words, produces a file either with a camera or with the gallery.
mixin ImageFileProducer {
  /// Allows for the utilization of the system camera, this saves the image
  /// in temporary storage
  Future<File> useCamera(
      {double maxHeight = 600, double maxWidth = 600}) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      preferredCameraDevice: CameraDevice.rear,
    );

    // Make sure an image was taken
    if (pickedFile != null) {
      /// This gives a directory to save the image
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = paths.basename(pickedFile.path);

      /// Now save the image into directory [appDir] with the file name [fileName]
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      /// Assign File
      if (savedImage != null) {
        return savedImage;
      }
    }
    return null;
  }

  /// TODO: create a [useGallery]
}

/// Creates an Image widget from a camera, this can be further expanded upon by
/// implementing a system which adheres to ios file managing conventions.
mixin ImageConverter {
  File _file;
  Image _image;

  /// When [file] is set, this image is produced automatically.
  get image => _image;

  /// The [file] from which an image is produced.
  get file => _file;

  /// When file is set, an [image] widget can now be obtained
  set file(File imageFile) {
    _file = imageFile;
    _image = _convertToImage(_file);
  }

  /// Handle the unexpected nature of the image being a path or an asset.
  _convertToImage(File file) {
    Image image;
    if (file.path.contains('assets')) {
      image = Image.asset(file.path);
    } else {
      image = Image.file(file);
    }
    return image;
  }
}

class Imager with ImageFileProducer, ImageConverter {

  Imager.fromFile(File imageFile) {
    this.file = imageFile;
  }

  Future<Image> takePicture(
      {double maxHeight = 600, double maxWidth = 600}) async {
    File imageFile = await useCamera(maxHeight: maxHeight, maxWidth: maxWidth);

    if (imageFile != null) {
      this.file = imageFile;
      return this.image;
    } else
      return null;
  }
}
