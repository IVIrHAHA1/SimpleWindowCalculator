import 'package:SimpleWindowCalculator/objects/CounterObsverver.dart';
/**
 * Module displays overall results of vital information
 */

import 'package:flutter/material.dart';

class ResultsModule extends StatelessWidget {
  final double height;
  final CounterObserver observer;

  ResultsModule({this.height, @required this.observer});

  @override
  Widget build(BuildContext context) {
    ResultCircle priceCircle = ResultCircle(
      height: height * .8,
      label: 'price',
      observer: observer,
    );

    ResultCircle approxCircle = ResultCircle(
      height: height * .6,
      label: 'approx time',
      observer: observer,
    );

    return Container(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Price Result Circle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: priceCircle,
              ),

              // Approx Time Result Circle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: approxCircle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ResultCircle extends StatefulWidget {
  final double height;
  final String label;
  final CounterObserver observer;

  _ResultCircleState _circleState;

  ResultCircle({this.height, this.label, @required this.observer}) {
    this._circleState = _ResultCircleState(height, label);

    observer.subscribe(label, _circleState);
  }

  @override
  _ResultCircleState createState() => _circleState;
}

class _ResultCircleState extends State<ResultCircle> with CountObserver {
  double _height;
  String _label;
  var value;

  _ResultCircleState(this._height, this._label) {
    value = 0;
  }

  @override
  void updateValue(var value) {
    setState(() {
      this.value = value;
    });
  }

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
                '${value.toString()}',
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
