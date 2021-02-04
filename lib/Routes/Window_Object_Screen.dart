import 'dart:io';

import 'package:path/path.dart' as paths;

import '../objects/Window.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

class WindowObjectScreen extends StatelessWidget {
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
      leading: IconButton(
        icon: Icon(
          Icons.highlight_off,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),

      // OnSubmit data
      actions: [
        IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          ),
          onPressed: () {
            // TODO: Add a way to save object and add it to list.
            // TODO: Also need to dispose of TextInputControllers.
            print(window.getName() ?? 'still not named');
            print(window.getPrice().toString() + ' priced');
            print(window.getDuration().toString() + ' Timed');
          },
        )
      ],
    );

    double bodyHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      backgroundColor: Theme.of(context).primaryColor,
      body: _WindowDetails(bodyHeight, window ?? Window()),
    );
  }
}

class _WindowDetails extends StatefulWidget {
  final double height;

  final Window window;

  _WindowDetails(this.height, this.window);

  @override
  __WindowDetailsState createState() => __WindowDetailsState();
}

class __WindowDetailsState extends State<_WindowDetails> {
  @override
  Widget build(BuildContext context) {
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      alignment: Alignment.center,
      height: widget.height,
      child: Column(
        children: [
          buildImage(keyBoardHeight > 0 ? 0 : (widget.height * .5)),
          buildBoxes(widget.height * .5),
        ],
      ),
    );
  }

  void _obtainImage() async {
    /// Allows for the utilization of the system camera, this saves the image
    /// in temporary storage
    ImagePicker imagePicker = ImagePicker();
    PickedFile imageFile = await imagePicker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    /// This gives a directory to save the image
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = paths.basename(imageFile.path);

    /// Now save the image into directory [appDir] with the file name [fileName]
    final saveImage = await File(imageFile.path).copy('${appDir.path}/$fileName');

    setState(() {
      widget.window.setImage(saveImage);
    });
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
        child: GestureDetector(
          onTap: _obtainImage,
          child: widget.window.getImage() == null
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
              : Center(child: Image.asset(widget.window.getImage().path)),
        ),
      ),
    );
  }

  _updateWindowName(String name) {
    widget.window.setName(
      name ?? widget.window.getName(),
    );
  }

  _updateWindowDuration(String timeText) {
    try {
      var time = double.parse(timeText);

      var sec = ((time % 1) * 60).toString().split('.').first;
      var minutes = (time - (time % 1)).toString().split('.').first;

      Duration duration = Duration(
        minutes: int.parse(minutes),
        seconds: int.parse(sec),
      );

      widget.window.setDuration(duration);
    } catch (Exception) {
      // TODO: Implement user error msg
    }
  }

  _updateWindowPrice(String priceText) {
    try {
      var price = double.parse(priceText);
      widget.window.setPrice(price);
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
            label: widget.window.getName() ?? 'Name',
            updateData: _updateWindowName,
          ),
          DetailInputBox(
            label: widget.window.getDuration().inSeconds.toString() ?? 'Time',
            textInputType: TextInputType.number,
            updateData: _updateWindowDuration,
          ),
          DetailInputBox(
            label: widget.window.getPrice().toString() ?? 'Price',
            textInputType: TextInputType.number,
            updateData: _updateWindowPrice,
          ),
        ],
      ),
    );
  }
}

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
