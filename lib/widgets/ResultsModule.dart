import 'package:SimpleWindowCalculator/Tools/Format.dart';
import 'package:SimpleWindowCalculator/widgets/OverviewModule.dart';
import 'package:flutter/material.dart';

class ResultsModule extends StatefulWidget {
  // Sets container height of both Card and Total Count Tile
  static const double _widgetSizeRatio = .4;

  // Height is the available screen size (*Because of appBar access)
  final double height;

  final List<Text> children;
  final double count;
  final Function hideViews;
  final OverviewModule statModule;

  ResultsModule({
    @required this.height,
    @required this.count,
    @required this.hideViews,
    this.statModule,
    this.children,
  });

  @override
  _ResultsModuleState createState() =>
      _ResultsModuleState(height * _widgetSizeRatio);
}

class _ResultsModuleState extends State<ResultsModule> {
  static const double cardRatio = .75;

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
    //dynamicHeight = widget.height - (widgetSize - collapsedHeight) - 17;
    widget.hideViews(true);
  }

  _collapseState() {
    expanded = false;
    widget.hideViews(false);
    //dynamicHeight = collapsedHeight;
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

    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          height: dynamicHeight,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            child: GestureDetector(
              onTap: expanded ? _collapseState : _expandState,
              child: Container(
                height: collapsedHeight,
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

                    // OverviewList
                    Flexible(
                      fit: FlexFit.tight,
                      child: Visibility(
                        visible: expanded,
                        child: widget.statModule != null
                            ? widget.statModule
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Total Count Modulette
        Container(
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
