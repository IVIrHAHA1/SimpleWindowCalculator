import 'package:flutter/material.dart';
import '../objects/Window.dart';

class WindowCounter extends StatefulWidget {
  final Window window;
  final Function updater;

  WindowCounter({@required this.window, @required this.updater});

  @override
  _WindowCounterState createState() => _WindowCounterState(window);
}

class _WindowCounterState extends State<WindowCounter> {
  final Window _window;

  var _windowCount;

  _WindowCounterState(this._window) {
    _windowCount = _window.getCount();
  }

  incrementCount() {
    setState(() {
      _windowCount += 1.0;
      _window.setCount(_windowCount);
    });
  }

  decrementCount() {
    setState(() {
      _windowCount -= 1.0;
      _window.setCount(_windowCount);
    });
  }

// TODO: Move this function back into main
  void _selectNewWindow(BuildContext ctx) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                Image.asset('assets/images/standard_window.png'),
                Image.asset('assets/images/french_window.png'),
              ],
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth =  MediaQuery.of(context).size.width * .8;
    return Container(
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${_window.getCount()}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: GestureDetector(
                  onTap: decrementCount,
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
                  onPressed: () => _selectNewWindow(context),
                  icon: Image.asset(
                    'assets/images/standard_window.png',
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: incrementCount,
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
