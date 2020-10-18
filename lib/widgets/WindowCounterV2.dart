import 'package:flutter/material.dart';
import '../objects/Window.dart';
import '../objects/WOManager.dart';

class WindowCounter extends StatefulWidget {
  final Window window;
  final Function updater, windowAddedFunction;

  WindowCounter(
      {@required this.window,
      @required this.updater,
      @required this.windowAddedFunction});

  @override
  _WindowCounterState createState() =>
      _WindowCounterState(window, updater, windowAddedFunction);
}

class _WindowCounterState extends State<WindowCounter> {
  Window _window;
  final Function _updater, _updateWindowList;

  Image windowImage;

  _WindowCounterState(this._window, this._updater, this._updateWindowList) {
    windowImage = this._window.getPicture();
  }

  _addNewWindow(Window window) {
    // Save current window
    Window windowExisted = _updateWindowList(window, _window);

    // Update Counter to new window
    setState(() {
      this._window = windowExisted == null ? window : windowExisted;
    });

    Navigator.of(context).pop();
  }

  /*
   * Modal sheet used to select new window
   */
  void selectNewWindow(BuildContext ctx) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GridView.count(
          crossAxisCount: 3,
          children: WOManager.windows.map((element) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Card(
                child: Column(
                  children: [
                    (element.getPicture()),
                    Text(element.getName()),
                  ],
                ),
              ),
              onTap: () {
                _addNewWindow(element);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width * .8;
    return Container(
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _window.setCount(count: (_window.getCount() - 1));
                    });
                    _updater();
                  },
                  child: Image.asset(
                    'assets/images/decrement_btn.png',
                    height: screenWidth * .20,
                    width: screenWidth * .20,
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: IconButton(
                  iconSize: screenWidth * .3,
                  onPressed: () {
                    selectNewWindow(context);
                  },
                  icon: Card(
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      child: _window.getPicture(),
                      padding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _window.setCount(count: (_window.getCount() + 1));
                    });
                    _updater();
                  },
                  child: Image.asset(
                    'assets/images/increment_btn.png',
                    height: screenWidth * .20,
                    width: screenWidth * .20,
                  ),
                ),
              ),
            ],
          ),
          Text(_window.getName()),
        ],
      ),
    );
  }
}
