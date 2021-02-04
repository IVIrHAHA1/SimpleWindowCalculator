import 'dart:io';

import 'package:SimpleWindowCalculator/Tools/DatabaseProvider.dart';
import 'package:SimpleWindowCalculator/Tools/ImageLoader.dart';
import 'package:path/path.dart' as paths;

import '../objects/Window.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

/// Window screen which allows user to create or edit window objects
class WindowObjectScreen extends StatelessWidget {
  /// NON-NULL if nothing to input, input a blank window object
  /// ```dart
  /// new WindowObjectScreen(Window());
  /// ```
  ///
  final Window window;

  WindowObjectScreen(this.window);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        window == null ? 'Create Window' : window.getName(),
        style: TextStyle(
          color: Colors.white,
        ),
      ),

      // Cancel Creation/Deletion
      leading: IconButton(
        icon: Icon(
          Icons.highlight_off,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),

      // Finished Creating/Editing
      actions: [
        IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          ),
          onPressed: () async {
            /// If window object is acceptible, then add to database
            // TODO: VERIFY WINDOW OBJECT

            /// Otherwise, reopen screen and ask user to fix any mistakes
            DatabaseProvider.instance.insert(window);
            Navigator.of(context).pop();
          },
        )
      ],
    );

    /// Size screen for keyboard-trigger animation
    double bodyHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        alignment: Alignment.center,
        height: bodyHeight,
        child: Column(
          children: [
            buildImage(keyBoardHeight > 0 ? 0 : (bodyHeight * .5)),
            buildBoxes(bodyHeight * .5),
          ],
        ),
      ),
    );
  }

  Widget buildImage(double size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: size,
      alignment: Alignment.center,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: _WindowImageInput(window.getImage(), _updateImage),
      ),
    );
  }

  _updateImage(File windowImage) {
    window.setImage(windowImage);
  }

  _updateName(String name) {
    window.setName(
      name ?? window.getName(),
    );
  }

  _updateDuration(String timeText) {
    try {
      var time = double.parse(timeText);

      var sec = ((time % 1) * 60).toString().split('.').first;
      var minutes = (time - (time % 1)).toString().split('.').first;

      Duration duration = Duration(
        minutes: int.parse(minutes),
        seconds: int.parse(sec),
      );

      window.setDuration(duration);
    } catch (Exception) {
      // TODO: Implement user error msg
    }
  }

  _updatePrice(String priceText) {
    try {
      var price = double.parse(priceText);
      window.setPrice(price);
    } catch (Exception) {
      // TODO: Implement user error msg
    }
  }

  Widget buildBoxes(double size) {
    return Container(
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DetailInputBox(
            label: window.getName() ?? 'Name',
            updateData: _updateName,
          ),
          DetailInputBox(
            label: window.getDuration().inSeconds.toString() ?? 'Time',
            textInputType: TextInputType.number,
            updateData: _updateDuration,
          ),
          DetailInputBox(
            label: window.getPrice().toString() ?? 'Price',
            textInputType: TextInputType.number,
            updateData: _updatePrice,
          ),
        ],
      ),
    );
  }
}

class _WindowImageInput extends StatefulWidget {
  final File previewImage;
  final Function onNewImage;

  _WindowImageInput(this.previewImage, this.onNewImage);

  @override
  _WindowImageInputState createState() =>
      _WindowImageInputState(this.previewImage);
}

class _WindowImageInputState extends State<_WindowImageInput> {
  File windowImage;

  _WindowImageInputState(this.windowImage);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _obtainImage,
      child: windowImage == null
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('No Image Available'),
                  ),
                  Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          : Center(child: ImageLoader.fromFile(windowImage)),
    );
  }

  /// Open camera or (TODO:gallery) to get an image to preview window object
  void _obtainImage() async {
    /// Allows for the utilization of the system camera, this saves the image
    /// in temporary storage
    ImagePicker imagePicker = ImagePicker();
    PickedFile imageFile = await imagePicker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    // Make sure an image was taken
    if (imageFile != null) {
      /// This gives a directory to save the image
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = paths.basename(imageFile.path);

      /// Now save the image into directory [appDir] with the file name [fileName]
      final savedImage =
          await File(imageFile.path).copy('${appDir.path}/$fileName');

      if (savedImage != null) {
        setState(() {
          windowImage = savedImage;
        });
        widget.onNewImage(savedImage);
      }
    }
  }
}

/*  DETAIL INPUT BOX WIDGET                                                    *
 * --------------------------------------------------------------------------- */
/// Text input boxes where necessary Window details will be gathered from user
class DetailInputBox extends StatefulWidget {
  final String label;
  final Function updateData;
  final TextInputType textInputType;

  DetailInputBox({
    this.label,
    this.updateData,
    this.textInputType,
  });

  @override
  _DetailInputBoxState createState() => _DetailInputBoxState(label);
}

class _DetailInputBoxState extends State<DetailInputBox> {
  String textLabel;

  _DetailInputBoxState(this.textLabel);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height / 16),
      width: MediaQuery.of(context).size.width * .5,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: TextField(
        keyboardType: widget.textInputType ?? TextInputType.text,
        onSubmitted: (String value) async {
          setState(() {
            textLabel = value;
          });
          widget.updateData(value);
        },
        decoration: InputDecoration(hintText: textLabel),
      ),
    );
  }
}
