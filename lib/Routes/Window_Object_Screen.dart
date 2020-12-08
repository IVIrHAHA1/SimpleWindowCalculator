import '../objects/OManager.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

class WindowObjectScreen extends StatelessWidget {
  final Window window;

  WindowObjectScreen(this.window);

  @override
  Widget build(BuildContext context) {
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
      actions: [
        IconButton(
            icon: Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop())
      ],
    );

    double bodyHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).primaryColor,
      body: _WindowDetails(bodyHeight),
    );
  }
}

class _WindowDetails extends StatelessWidget {
  final double height;

  final nameController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();

  _WindowDetails(this.height);

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
          child: OManager.getDefaultWindow().getPicture(),
        ),
      ),
    );
    ;
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
          ),
          DetailInputBox(
            label: 'Time',
            controller: timeController,
          ),
          DetailInputBox(
            label: 'Price',
            controller: priceController,
          ),
        ],
      ),
    );
  }
}

class DetailInputBox extends StatefulWidget {
  final String label;
  final controller;

  DetailInputBox({this.label, this.controller});

  @override
  _DetailInputBoxState createState() => _DetailInputBoxState(label);
}

class _DetailInputBoxState extends State<DetailInputBox> {
  String textLabel;

  _DetailInputBoxState(this.textLabel);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height/16),
      width: MediaQuery.of(context).size.width * .5,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        onSubmitted: (String value) async {
          setState(() {
            textLabel = value;
          });
        },
        decoration: InputDecoration(
          labelText: textLabel,
        ),
      ),
    );
  }
}
