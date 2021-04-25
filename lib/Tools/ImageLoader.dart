import 'dart:io';
import '../Tools/Calculator.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as paths;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:image_picker/image_picker.dart';

/// Creates a file using the systems's camera or pulls a file using the gallery.
/// In other words, produces a file either with a camera or with the gallery.
mixin ImageFileProducer {
  /// Allows for the utilization of the system camera, this saves the image
  /// in temporary storage
  static Future<File> useCamera(
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

  static Future<File> useGallery(
      {double maxHeight = 600, double maxWidth = 600}) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
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
}

/// Creates an Image widget from a camera, this can be further expanded upon by
/// implementing a system which adheres to ios file managing conventions.
mixin ImageConverter {
  File _file;
  Image _image;

  /// When [masterFile] is set, this image is produced automatically.
  get masterImage => _image;

  /// The [masterFile] from which an image is produced.
  get masterFile => _file;

  /// When file is set, an [masterImage] widget can now be obtained
  set masterFile(File imageFile) {
    _file = imageFile;

    if (_file != null)
      _image = _convertToImage(_file);
    else
      _image = null;
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

enum ImagerMechanism {
  camera,
  gallery,
}

class Imager with ImageConverter, Notifier {
  /// Called when [masterFile] is assigned a value
  Function(Image image, File file) onImageReceived;

  /// imageFile can be null. This will only cause both masterFile and
  /// masterImage to be null.
  Imager.fromFile(File imageFile, {this.onImageReceived}) {
    this.masterFile = imageFile;
  }

  Imager({this.onImageReceived});

  Future<Image> getPicture(ImagerMechanism method,
      {double maxHeight = 600, double maxWidth = 600}) async {
    File imageFile;

    switch (method) {
      case ImagerMechanism.camera:
        imageFile = await ImageFileProducer.useCamera(
            maxHeight: maxHeight, maxWidth: maxWidth);
        break;

      case ImagerMechanism.gallery:
        imageFile = await ImageFileProducer.useGallery(
            maxHeight: maxHeight, maxWidth: maxWidth);
        break;
    }

    if (imageFile != null) {
      this.masterFile = imageFile;

      // Notify listeners
      if (onImageReceived != null)
        this.onImageReceived(this.masterImage, this.masterFile);
      if (this.isListening) notifyListeners();

      return this.masterImage;
    } else
      return null;
  }

  /// Called when a new file image is obtained. See [onImageReceived] for a
  /// more comprehensive interface.
  @override
  addListener(Function listener) {
    return super.addListener(listener);
  }
}
