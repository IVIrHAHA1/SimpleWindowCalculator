/*
 * Module displays overall results of vital information
 */

import 'package:SimpleWindowCalculator/Tools/Format.dart';
import 'package:SimpleWindowCalculator/Tools/HexColors.dart';
import 'package:SimpleWindowCalculator/widgets/OverviewModule.dart';
import 'package:flutter/material.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';

class ResultsModule extends StatefulWidget {
  // Sets container height of both Card and Total Count Tile
  static const double _widgetSizeRatio = .4;

  // Height is the available screen size (*Because of appBar access)
  final double height;

  final List<Text> children;
  final List<Window> windows;
  final double count;
  final Function hideViews;

  ResultsModule(
      {this.height, this.children, this.count, this.hideViews, this.windows});

  @override
  _ResultsModuleState createState() =>
      _ResultsModuleState(height * _widgetSizeRatio);
}

class _ResultsModuleState extends State<ResultsModule> {
  static const double cardRatio = .75;

  final double widgetSize;
  double dynamicHeight, collapasedHeight;
  IconButton expansionControlBtn;

  bool showItemList;

  _ResultsModuleState(this.widgetSize) {
    this.collapasedHeight = widgetSize * cardRatio;
    this.dynamicHeight = this.collapasedHeight;
    this.showItemList = false;

    this.expansionControlBtn = IconButton(
      icon: Icon(
        Icons.expand_more
      ),
      onPressed: () => _expandState(),
    );
  }

  _expandState() {
    setState(() {
      expansionControlBtn = IconButton(
        icon: Icon(Icons.expand_less),
        onPressed: () => _collapseState(),
      );
      showItemList = true;
      dynamicHeight = widget.height - (widgetSize - collapasedHeight) - 17;
      widget.hideViews(true);
    });
  }

  _collapseState() {
    setState(() {
      expansionControlBtn = IconButton(
        icon: Icon(Icons.expand_more),
        onPressed: () => _expandState(),
      );
      showItemList = false;
      widget.hideViews(false);
      dynamicHeight = collapasedHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Price Circle
    ResultCircle priceCircle = ResultCircle(
      height: (collapasedHeight * .8),
      textView: widget.children[0],
    );

    // Time Circle
    ResultCircle timeCircle = ResultCircle(
      height: (collapasedHeight * .6),
      textView: widget.children[1],
    );

    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          height: dynamicHeight,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Container(
              height: collapasedHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
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

                  // // OverviewList
                  // Flexible(
                  //   fit: FlexFit.tight,
                  //   child: Visibility(
                  //     visible: showItemList,
                  //     child: OverviewModule(
                  //       windowList: widget.windows,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),

        // Total Count Modulette
        Container(
          height: widgetSize - collapasedHeight,
          child: ListTile(
            leading: Text(
              'Total Window Count',
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Container(
              width: 75,
              height: 50,
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Center(
                  child: widget.count != null
                      ? Text(
                          '${Format.format(widget.count)}',
                          style: Theme.of(context).textTheme.headline5,
                        )
                      : Text(
                          '0',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                ),
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
  final Text textView;

  ResultCircle({this.height, this.textView});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      child: Card(
        elevation: 2,
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.blue,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Center(
          child: textView,
        ),
      ),
    );
  }
}
