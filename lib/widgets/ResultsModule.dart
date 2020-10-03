/*
 * Module displays overall results of vital information
 */

import 'package:flutter/material.dart';

class ResultsModule extends StatelessWidget {
  final double height;
  final List<Text> children;

  ResultsModule({this.height, this.children});

  @override
  Widget build(BuildContext context) {
    // Price Circle
    ResultCircle priceCircle = ResultCircle(
      height: height * .75,
      textView: children[0],
      label: 'price',
    );

    // Time Circle
    ResultCircle timeCircle = ResultCircle(
      height: height * .65,
      textView: children[1],
      label: 'time',
    );

    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Column(
            children: [
              Row(
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
                    child: timeCircle,
                  ),
                ],
              ),
              Icon(Icons.expand_more)
            ],
          ),
        ),

        // Total Count Modulette
        ListTile(
              leading: Text(
                'Total Window Count',
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Container(
                width: 75,
                height: 50,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blue,
                  child: Center(
                    child: Text('0'),
                  ),
                ),
              ),
            ),
      ],
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
                width: 3,
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
