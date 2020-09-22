import 'package:flutter/material.dart';
import '../objects/Window.dart';

class Counter extends StatefulWidget {
  final double height;
  final List<Window> windowList;

  Counter({this.height, this.windowList});

  @override
  _CounterState createState() => _CounterState(height, windowList);
}

class _CounterState extends State<Counter> {
  final double _buttonSize = 48.0;
  final double _widgetHeight;

  final List<Window> _list;

  _CounterState(this._widgetHeight, this._list);

  double _counter2 = 0, _counter1 = 0;
  double _totalCounter = 0;

  void _dec_2ndStory() {
    setState(() {
      _counter2 += -1;
      _totalCounter += -1;

      _list[1].setCount(_counter2);
    });
  }

  void _inc_2ndStory() {
    setState(() {
      _counter2 += 1;
      _totalCounter += 1;

      _list[1].setCount(_counter2);
    });
  }

  void _dec_1stStory() {
    setState(() {
      _counter1 += -1;
      _totalCounter += -1;

      _list[0].setCount(_counter1);
    });
  }

  void _inc_1stStory() {
    setState(() {
      _counter1 += 1;
      _totalCounter += 1;

      _list[0].setCount(_counter1);
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
