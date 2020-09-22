import 'package:SimpleWindowCalculator/objects/CounterObsverver.dart';
import 'package:flutter/material.dart';

class WindowTile extends StatefulWidget {
  final String name;
  final double countDisplay;
  final CounterObserver observer;

  _WindowTileState _windowState;

  WindowTile({this.name, this.countDisplay, this.observer}) {
    _windowState = _WindowTileState(name, countDisplay);

    observer.subscribe(name, _windowState);
  }

  @override
  _WindowTileState createState() => _windowState;
}

class _WindowTileState extends State<WindowTile> with CountObserver {
  final String _name;
  double _countDisplay;

  _WindowTileState(this._name, this._countDisplay);

  @override
  updateCount(double count) {
    setState(() {
      _countDisplay = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Item Title
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),

        Flexible(
          fit: FlexFit.tight,
          child: Container(),
        ),

        // Item Value
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.blue,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: Text('${_countDisplay.toString()}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
