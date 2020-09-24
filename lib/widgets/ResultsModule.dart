import 'package:SimpleWindowCalculator/objects/CounterObsverver.dart';
/**
 * Module displays overall results of vital information
 */

import 'package:flutter/material.dart';

class ResultsModule extends StatelessWidget {
  final double height;
  final List<Text> children;

  ResultsModule({this.height, this.children});

  @override
  Widget build(BuildContext context) {
    ResultCircle priceCircle = ResultCircle(
      height: height * .8,
      textView: children[0],
      label: 'price',
    );

    ResultCircle approxCircle = ResultCircle(
      height: height * .6,
      textView: children[1],
      label: 'approx time',
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

class ResultCircle extends StatelessWidget {
  final double height;
  final String label;
  final Text textView;

  ResultCircle({this.height, this.label, this.textView});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
              height: (height * .8) - 8,
              width: (height * .8) - 8,
              child: Center(
                child: textView,
              ),
            ),
          ),

          // Label
          (label != null)
              ? Container(
                  height: height * .2,
                  child: Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
