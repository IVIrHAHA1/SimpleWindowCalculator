import 'package:SimpleWindowCalculator/Tools/Format.dart';
import 'package:SimpleWindowCalculator/Tools/GlobalValues.dart';
import 'package:SimpleWindowCalculator/widgets/OverviewModule.dart';
import 'package:flutter/material.dart';

class ResultsModule extends StatefulWidget {
  // Sets container height of both Card and Total Count Tile
  // vs how much is going to the controller
  static const double _widgetSizeRatio = .4;

  // Height is the available screen size (*Because of appBar access)
  final double height;

  final List<Text> children;
  final double count;
  final Function triggerExpandAnim;
  final OverviewModule statModule;

  ResultsModule({
    @required this.height,
    @required this.count,
    @required this.triggerExpandAnim,
    this.statModule,
    this.children,
  });

  @override
  _ResultsModuleState createState() =>
      _ResultsModuleState(height * _widgetSizeRatio);
}

class _ResultsModuleState extends State<ResultsModule> {
  static const double cardRatio = .75; // Amount the card is going to occuppy
  // vs total window count module
  final double widgetSize;
  double dynamicHeight, collapsedHeight;
  IconButton expansionControlBtn;

  bool expanded;

  _ResultsModuleState(this.widgetSize) {
    this.collapsedHeight = widgetSize * cardRatio;
    this.dynamicHeight = this.collapsedHeight;
    this.expanded = false;
  }

  _expandState() {
    expanded = true;
    widget.triggerExpandAnim(true);
    dynamicHeight = widget.height - (widgetSize - collapsedHeight);
  }

  _collapseState() {
    expanded = false;
    widget.triggerExpandAnim(false);
    dynamicHeight = collapsedHeight;
  }

  @override
  Widget build(BuildContext context) {
    // Price Circle
    ResultCircle priceCircle = ResultCircle(
      height: (collapsedHeight * .8),
      textView: widget.children[0],
    );

    // Time Circle
    ResultCircle timeCircle = ResultCircle(
      height: (collapsedHeight * .6),
      textView: widget.children[1],
    );

    // Column including window count and results mod
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: GlobalValues.animDuration),
          height: dynamicHeight,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(GlobalValues.cornerRadius),
            ),
            elevation: 5,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: expanded ? _collapseState : _expandState,
                    child: Row(
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
                  ),

                  // OverviewList
                  // TODO: Revisit Overview expanding when you learn about Futures
                  AnimatedContainer(
                    height: expanded ? (dynamicHeight - collapsedHeight) : 0,
                    duration: Duration(milliseconds: GlobalValues.animDuration),
                    // child: widget.statModule ?? Container(),
                    child: AnimatedCrossFade(
                      firstChild: widget.statModule,
                      secondChild: Container(),
                      crossFadeState: expanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(
                        milliseconds: (GlobalValues.animDuration ~/ 1.25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Total Count Modulette
        _buildWindowCountDisplay(context),
      ],
    );
  }

  bool statModVis = false;

  /*
   *  Total Window Count Display  
   */
  Widget _buildWindowCountDisplay(BuildContext context) {
    return Container(
      height: widgetSize - collapsedHeight,
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
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.white,
            child: Center(
              child: widget.count != null
                  ? Text(
                      '${Format.format(widget.count, 1)}',
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
