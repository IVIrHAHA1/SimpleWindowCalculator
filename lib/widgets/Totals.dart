import 'package:SimpleWindowCalculator/widgets/ResultCircle.dart';
import 'package:flutter/material.dart';

class Totals extends StatelessWidget {
  final double height;

  Totals({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ResultCircle(height: height*.8, label: 'price'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ResultCircle(height: height*.6, label: 'approx time'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
