import 'package:flutter/material.dart';

class WindowTile extends StatefulWidget {
  final String name;
  final double countDisplay;

  WindowTile({this.name, this.countDisplay});

  @override
  _WindowTileState createState() => _WindowTileState(name, countDisplay);
}

class _WindowTileState extends State<WindowTile> {
  final String _name;
  double _countDisplay;

  _WindowTileState(this._name, this._countDisplay);

  @override
  Widget build(BuildContext context) {
    print(_countDisplay);
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
