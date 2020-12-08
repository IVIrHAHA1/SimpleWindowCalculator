import 'package:fluttertoast/fluttertoast.dart';

import '../objects/OManager.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

class WindowObjectScreen extends StatelessWidget {
  Window window;

  WindowObjectScreen(this.window);

  @override
  Widget build(BuildContext context) {
    window = window ?? new Window();

    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        'Create Window',
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
      resizeToAvoidBottomPadding: false,
      appBar: appBar,
      backgroundColor: Theme.of(context).primaryColor,
      body: _WindowDetails(bodyHeight, window),
    );
  }
}

class _WindowDetails extends StatelessWidget {
  final double height;

  final Window window;

  final nameController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();

  _WindowDetails(this.height, this.window);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        children: [
          buildImage(height * .5),
          buildBoxes(height * .5),
        ],
      ),
    );
  }

  Widget buildImage(double size) {
    return Container(
      height: size,
      alignment: Alignment.center,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: size * .75,
          padding: EdgeInsets.all(8),
          child: window.getImage() ?? Image.asset('assets/images/na_image.png'),
        ),
      ),
    );
  }

  _updateWindowName() {
    window.setName(
      nameController.text ?? window.getName(),
    );
  }

  _updateWindowDuration() {
    try {
      var time = double.parse(timeController.text);

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

  _updateWindowPrice() {
    try {
      var price = double.parse(priceController.text);
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
            label: 'Name',
            controller: nameController,
            updateData: _updateWindowName,
          ),
          DetailInputBox(
            label: 'Time',
            controller: timeController,
            textInputType: TextInputType.number,
            updateData: _updateWindowDuration,
          ),
          DetailInputBox(
            label: 'Price',
            controller: priceController,
            textInputType: TextInputType.number,
            updateData: _updateWindowPrice,
          ),
        ],
      ),
    );
  }
}

class DetailInputBox extends StatefulWidget {
  final String label;
  final controller;
  final Function updateData;
  final TextInputType textInputType;

  DetailInputBox({
    this.label,
    this.controller,
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
        controller: widget.controller,
        onSubmitted: (String value) async {
          setState(() {
            textLabel = value;
          });
          widget.updateData();
        },
        decoration: InputDecoration(
          labelText: textLabel,
        ),
      ),
    );
  }
}
