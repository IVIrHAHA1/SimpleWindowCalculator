import 'package:flutter/material.dart';

class WindowListItem extends StatefulWidget {
  final String name;
  double countDisplay;

  WindowListItem({this.name, this.countDisplay});

  @override
  _WindowListItemState createState() => _WindowListItemState(name, countDisplay);
}

class _WindowListItemState extends State<WindowListItem> {
  final String _name;
  double _countDisplay;

  _WindowListItemState(this._name, this._countDisplay);

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
                child: Text('$_countDisplay'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
