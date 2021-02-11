import 'dart:io';

import 'package:SimpleWindowCalculator/Tools/DatabaseProvider.dart';
import 'package:SimpleWindowCalculator/Tools/ImageLoader.dart';
import 'package:SimpleWindowCalculator/Util/HexColors.dart';
import 'package:path/path.dart' as paths;

import '../objects/Window.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_picker/Picker.dart';

/// Window screen which allows user to create or edit window objects
class WindowObjectScreen extends StatefulWidget {
  /// NON-NULL if nothing to input, input a blank window object
  /// ```dart
  /// new WindowObjectScreen(Window());
  /// ```
  ///
  final Window window;

  WindowObjectScreen({this.window});

  @override
  _WindowObjectScreenState createState() => _WindowObjectScreenState();
}

class _WindowObjectScreenState extends State<WindowObjectScreen> {
  String name;
  Duration duration;
  double price;

  @override
  void initState() {
    if (widget.window != null) {
      this.name = widget.window.name;
      this.duration = widget.window.duration;
      this.price = widget.window.price;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        widget.window == null ? 'Create Window' : widget.window.getName(),
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
            DatabaseProvider.instance.insert(widget.window);
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
            buildBoxes(bodyHeight * .5, context),
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
      child: _WindowImageInput(
        widget.window != null ? widget.window.getImage() : null,
        _updateImage,
      ),
    );
  }

  _updateImage(File windowImage) {
    widget.window.setImage(windowImage);
  }

  _updateName(String name) {
    widget.window.setName(
      name ?? widget.window.getName(),
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

      widget.window.duration = duration;
    } catch (Exception) {
      // TODO: Implement user error msg
    }
  }

  _updatePrice(String priceText) {
    try {
      var price = double.parse(priceText);
      widget.window.price = price;
    } catch (Exception) {
      // TODO: Implement user error msg
    }
  }

  Widget buildBoxes(double size, BuildContext ctx) {
    return Container(
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DetailInputBox(
            label: widget.window != null ? widget.window.getName() : 'Name',
            updateData: _updateName,
          ),
          MaterialButton(
            child: Container(
              height: (MediaQuery.of(ctx).size.height / 16),
              width: MediaQuery.of(ctx).size.width * .5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(ctx).primaryColorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                duration != null
                    ? '${_printDuration(duration)}'
                    : 'choose time',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            onPressed: () {
              _timePicker(ctx);
            },
          ),
          DetailInputBox(
            label: widget.window != null ? widget.window.price.toString() : 'Price',
            textInputType: TextInputType.number,
            updateData: _updatePrice,
          ),
        ],
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  _timePicker(BuildContext ctx) {
    Picker(
      builderHeader: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('minutes'),
              Text('seconds'),
            ],
          ),
        );
      },
      adapter: NumberPickerAdapter(
        data: [
          NumberPickerColumn(begin: 0, end: 100),
          NumberPickerColumn(begin: 0, end: 59),
        ],
      ),
      delimiter: [
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Text(
              ':',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
      hideHeader: false,
      selectedTextStyle: TextStyle(
        color: Colors.blue,
      ),
      textStyle: TextStyle(
        color: Colors.black,
      ),
      title: Text(
        "How long does it take to clean?",
        style: TextStyle(color: Colors.black),
      ),
      onConfirm: (Picker picker, List value) {
        int min = value[0];
        int sec = value[1];

        if (min == 0 && sec == 0) {
          setState(() {
            duration = null;
          });
        } else {
          setState(() {
            duration = Duration(
              minutes: min,
              seconds: sec,
            );
          });
        }
      },
    ).showDialog(ctx);
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
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      ),
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
      maxHeight: 600,
      preferredCameraDevice: CameraDevice.rear,
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        keyboardType: widget.textInputType ?? TextInputType.text,
        textAlign: TextAlign.center,
        onSubmitted: (String value) async {
          setState(() {
            textLabel = value;
          });
          widget.updateData(value);
        },
        decoration: InputDecoration(
          hintText: textLabel,
          border: InputBorder.none,
          hintStyle: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
