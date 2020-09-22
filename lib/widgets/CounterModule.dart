import 'package:SimpleWindowCalculator/objects/CounterObsverver.dart';
import 'package:flutter/material.dart';
import '../objects/Window.dart';

class CounterModule extends StatefulWidget {
  final double height;
  final List<Window> windowList;
  final CounterObserver observer;

  CounterModule({this.height, this.windowList, @required this.observer});

  @override
  _CounterModuleState createState() =>
      _CounterModuleState(height, windowList, observer);
}

class _CounterModuleState extends State<CounterModule> {
  double _buttonSize;
  final double _widgetHeight;
  final CounterObserver _observer;

  final List<Window> _list;

  _CounterModuleState(this._widgetHeight, this._list, this._observer) {
    _buttonSize = _widgetHeight * .25;
  }

  double _counter2 = 0, _counter1 = 0;
  double _totalCounter = 0;

  void _dec_2ndStory() {
    setState(() {
      _counter2 += -1;
      _totalCounter += -1;

      _list[1].setCount(_counter2);

      _observer.notify('2nd Story Window', _counter2);
      _observer.notify('price', _counter2 + _counter1);
    });
  }

  void _inc_2ndStory() {
    setState(() {
      _counter2 += 1;
      _totalCounter += 1;

      _list[1].setCount(_counter2);

      _observer.notify('2nd Story Window', _counter2);
      _observer.notify('price', _counter2 + _counter1);
    });
  }

  void _dec_1stStory() {
    setState(() {
      _counter1 += -1;
      _totalCounter += -1;

      _list[0].setCount(_counter1);

      _observer.notify('1st Story Window', _counter1);
      _observer.notify('price', _counter2 + _counter1);
    });
  }

  void _inc_1stStory() {
    setState(() {
      _counter1 += 1;
      _totalCounter += 1;

      _list[0].setCount(_counter1);

      _observer.notify('1st Story Window', _counter1);
      _observer.notify('price', _counter2 + _counter1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text('$_counter2'),
          height: _widgetHeight * .1,
        ),
        Container(
          height: _widgetHeight * .7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minus Signs
                Column(
                  children: [
                    // 2nd story
                    Container(
                      child: GestureDetector(
                        onTap: _dec_2ndStory,
                        child: Image.asset(
                          'assets/images/minus_sign.png',
                          height: _buttonSize,
                          width: _buttonSize,
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(),
                    ),

                    // 1st story
                    Container(
                      child: GestureDetector(
                        onTap: _dec_1stStory,
                        child: Image.asset(
                          'assets/images/minus_sign.png',
                          height: _buttonSize,
                          width: _buttonSize,
                        ),
                      ),
                    ),
                  ],
                ),

                // House Image
                Flexible(
                  fit: FlexFit.tight,
                  child: Image.asset(
                    'assets/images/house.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),

                // Plus Signs
                Column(
                  children: [
                    // 2nd story button
                    Container(
                      child: GestureDetector(
                        onTap: _inc_2ndStory,
                        child: Image.asset(
                          'assets/images/plus_sign.png',
                          height: _buttonSize,
                          width: _buttonSize,
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(),
                    ),

                    // 1st story button
                    Container(
                      child: GestureDetector(
                        onTap: _inc_1stStory,
                        child: Image.asset(
                          'assets/images/plus_sign.png',
                        ),
                      ),
                      height: _buttonSize,
                      width: _buttonSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Text('$_counter1'),
          height: _widgetHeight * .1,
        ),
        Container(
          height: _widgetHeight * .1,
          child: Row(
            children: [
              Text('$_totalCounter total windows'),
            ],
          ),
        ),
      ],
    );
  }
}
