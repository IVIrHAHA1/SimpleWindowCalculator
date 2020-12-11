import 'package:SimpleWindowCalculator/Tools/GlobalValues.dart';

import '../Tools/Format.dart';

import '../objects/Window.dart';
import 'package:flutter/material.dart';

class WindowPallet extends StatelessWidget {
  final List<Window> windowList;

  WindowPallet(this.windowList);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Text('windows in use'),
          Divider(
            thickness: 2,
            height: 4,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: windowList.map((window) {
                    return _WindowPreview(window: window);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      );
  }
}

class _WindowPreview extends StatelessWidget {
  final Window window;
  const _WindowPreview({
    Key key,
    @required this.window,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getHeight = () {
      return MediaQuery.of(context).size.height / 6;
    };

    var width = MediaQuery.of(context).size.width - (GlobalValues.appMargin * 2);

    return Column(
      children: [
        ListTile(
          leading: Text(
            '${Format.format(window.getCount(),1)}',
            style: Theme.of(context).textTheme.headline5,
          ),
          trailing: Text('\$${Format.format(window.grandTotal(),2)}'),
        ),
        Container(
          width: double.infinity, // Sets the width of the Column
          child: Row(
            children: [
              // Get Image
              Container(
                child: window.getPicture(),
                height: getHeight(),
              ),


              // Place icons and labels to the right
              Container(
                height: getHeight(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: window.factorList.entries.map((entry) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${Format.format(entry.value.getCount(),1)}',
                          ),
                          entry.value.getImage(),
                        ],
                      ),
                      height: 20,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 2,
          height: 5,
          endIndent: 8,
          indent: 8,
        ),
      ],
    );
  }
}
