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
      body: _WindowDetails(bodyHeight, window),
    );
  }
}

class _WindowDetails extends StatelessWidget {
  final double height;

  final Window window;

  _WindowDetails(this.height, this.window);

  @override
  Widget build(BuildContext context) {
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      alignment: Alignment.center,
      height: height,
      child: Column(
        children: [
          buildImage(keyBoardHeight > 0 ? 0 : (height * .5)),
          buildBoxes(height * .5),
        ],
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
        child: window == null || window.getImage() == null
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
            : Center(child: Image.asset(window.getImage().path)),
      ),
    );
  }

  /*
   *  These details or going to be changed, so that when user hits create/enter
   *  the details will change in the Database; Either replace or insert.
   */
  _updateWindowName(String name) {
    window.setName(
      name ?? window.getName(),
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

      window.setDuration(duration);
    } catch (Exception) {
      // TODO: Implement user error msg
    }
  }

  _updateWindowPrice(String priceText) {
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
            label: 'Name',
            updateData: _updateWindowName,
          ),
          DetailInputBox(
            label: 'Time',
            textInputType: TextInputType.number,
            updateData: _updateWindowDuration,
          ),
          DetailInputBox(
            label: 'Price',
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
