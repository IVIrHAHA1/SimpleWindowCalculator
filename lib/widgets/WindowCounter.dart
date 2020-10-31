import 'package:SimpleWindowCalculator/widgets/FactorCoin.dart';

import '../objects/Factor.dart';
import 'package:flutter/material.dart';
import '../objects/Window.dart';
import '../objects/OManager.dart';

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
          children: OManager.windows.map((element) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Card(
                child: Column(
                  children: [
                    Container(
                      child: element.getPicture(),
                      width: MediaQuery.of(ctx).size.width / 4,
                    ),
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
              DragTarget<FactorCoin>(
                onWillAccept: (coin) => coin != null,
                onAccept: (coin) {
                  coin.disable(coin);
                },
                builder: (ctx, candidates, rejects) {
                  return candidates.length > 0
                      ? IconButton(
                          iconSize: screenWidth * .3,
                          onPressed: () {
                            selectNewWindow(context);
                          },
                          icon: buildCard(Theme.of(context).primaryColor),
                        )
                      : IconButton(
                          iconSize: screenWidth * .3,
                          onPressed: () {
                            selectNewWindow(context);
                          },
                          icon: buildCard(Colors.white),
                        );
                },
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
          Text(_window.getName(), style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }

  Card buildCard(Color color) {
    return Card(
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey,
            style: BorderStyle.solid,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Container(
        color: color,
        child: _window.getPicture(),
        padding: EdgeInsets.all(4),
      ),
    );
  }
}
