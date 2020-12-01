import 'package:SimpleWindowCalculator/objects/OManager.dart';
import 'package:flutter/material.dart';

class WindowObjectScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();

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

class DetailInputBox extends StatelessWidget {
  final String label;
  final controller;

  DetailInputBox({this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
