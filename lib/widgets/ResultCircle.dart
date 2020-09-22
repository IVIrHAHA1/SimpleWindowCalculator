import 'package:flutter/material.dart';

class ResultCircle extends StatefulWidget {
  final double height;
  final String label;

  ResultCircle({this.height, this.label});

  @override
  _ResultCircleState createState() => _ResultCircleState(height, label);
}

class _ResultCircleState extends State<ResultCircle> {
  double _height;
  String _label;

  _ResultCircleState(this._height, this._label);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      child: Column(
        children: [
          // Circle
          Card(
            borderOnForeground: true,
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.blue,
                style: BorderStyle.solid,
                width: 4,
              ),
            ),
            child: Container(
              height: (_height * .8) - 8,
              width: (_height * .8) - 8,
              child: Center(
                  child: Text(
                '\$200',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
            ),
          ),

          // Label
          (_label != null)
              ? Container(
                  height: _height * .2,
                  child: Text(
                    _label,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
