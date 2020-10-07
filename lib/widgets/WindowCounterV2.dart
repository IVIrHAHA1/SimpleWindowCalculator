import 'package:flutter/material.dart';
import '../objects/Window.dart';

class WindowCounter extends StatefulWidget {
  final Window window;
  final Function updater, selector;

  WindowCounter(
      {@required this.window, @required this.updater, @required this.selector});

  @override
  _WindowCounterState createState() =>
      _WindowCounterState(window, updater, selector);
}

class _WindowCounterState extends State<WindowCounter> {
  final Window _window;
  final Function _updater, _selector;

  var _windowCount;

  _WindowCounterState(this._window, this._updater, this._selector) {
    _windowCount = _window.getCount();
  }

  incrementCount() {
    setState(() {
      _windowCount += 1.0;
      _window.setCount(count: _windowCount);
    });
    _updater();
  }

  decrementCount() {
    setState(() {
      _windowCount -= 1.0;
      _window.setCount(count: _windowCount);
    });
    _updater();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width * .8;
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
                  onPressed: () => _selector(context),
                  icon: _window.getPicture(),
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
