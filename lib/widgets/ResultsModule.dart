import 'package:the_window_calculator/Animations/SpinnerTransition.dart';

import '../Util/Format.dart';
import '../GlobalValues.dart';
import '../widgets/OverviewModule.dart';
import 'package:flutter/material.dart';

class ResultsModule extends StatefulWidget {
  // Sets container height of both Card and Total Count Tile
  // vs how much is going to the controller
  static const double _widgetSizeRatio = .4;

  // Height is the available screen size (*Because of appBar access)
  final double height;

  final ResultsValueHolder valueHolder;

  final Function triggerExpandAnim;
  final AnimationController internalController;

  ResultsModule({
    @required this.height,
    @required this.triggerExpandAnim,
    this.valueHolder,
    this.internalController,
  });

  @override
  _ResultsModuleState createState() =>
      _ResultsModuleState(height * _widgetSizeRatio);
}

class _ResultsModuleState extends State<ResultsModule> {
  // Amount the ResultsMod is going to occupy vs the "total-window-count" module
  static const double cardRatio = .8;

  /// The total height of both "total-window-count" and ResultsMod
  final double widgetSize;

  /// The height of only the ResultsMod
  double dynamicHeight, collapsedHeight;

  /// State of an expaned ResultsMod or a collapsed ResultsMod
  bool expanded;

  Animation opacityAnim;
  Animation<double> rotationAnim;

  @override
  void initState() {
    opacityAnim =
        Tween<double>(begin: 0.0, end: 1.0).animate(widget.internalController);

    rotationAnim = CurvedAnimation(
      parent: widget.internalController,
      curve: Curves.easeInOut,
    );
    super.initState();
  }

  _ResultsModuleState(this.widgetSize) {
    this.collapsedHeight = widgetSize * cardRatio;
    this.dynamicHeight = this.collapsedHeight;
    this.expanded = false;
  }

  _expandState() {
    expanded = true;
    widget.triggerExpandAnim(true);
    // widget.height = screen height - appBar
    // widgetSize = total count mod + results mod
    // at the end dynamicHeight equals widget.height minus total count mod
    dynamicHeight = widget.height - (widgetSize - collapsedHeight);
  }

  _collapseState() {
    expanded = false;
    widget.triggerExpandAnim(false);
    dynamicHeight = collapsedHeight;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle numberStyle = Theme.of(context).textTheme.headline5;
    // Price Circle
    ResultCircle priceCircle = ResultCircle(
      height: (collapsedHeight * .7),
      textView: widget.valueHolder.priceTotal != null
          ? Text(
              '\$${Format.format(widget.valueHolder.priceTotal, 2)}',
              style: numberStyle,
            )
          : Text(
              '\$0',
              style: numberStyle,
            ),
    );

    // Time Circle
    ResultCircle timeCircle = ResultCircle(
      height: (collapsedHeight * .5),
      textView: widget.valueHolder.timeTotal != null
          ? Text(
              '${Format.formatTime(widget.valueHolder.timeTotal)}',
              style: numberStyle,
            )
          : Text(
              '0:00',
              style: numberStyle,
            ),
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
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 0,
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
                  Flexible(
                    flex: 1,
                    child: FadeTransition(
                      opacity: opacityAnim,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight:
                              widget.height - (widgetSize - collapsedHeight),
                        ),
                        child: OverviewModule(
                          widget.valueHolder.priceTotal,
                          widget.valueHolder.timeTotal,
                          _collapseState,
                        ),
                      ),
                    ),
                  ),

                  Flexible(
                    flex: 0,
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: SpinnerTransition(
                        onPressed: expanded ? _collapseState : _expandState,
                        direction: Direction.clockwise,
                        duration: Duration(milliseconds: 200),
                        reverseDuration: Duration(milliseconds: 200),
                        child1: Icon(
                          Icons.arrow_drop_down,
                          size: collapsedHeight * .15,
                          color: Colors.blue,
                        ),
                        child2: Icon(
                          Icons.arrow_drop_up,
                          size: collapsedHeight * .15,
                          color: Colors.blue,
                        ),
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
              child: widget.valueHolder.countTotal != null
                  ? Text(
                      '${Format.format(widget.valueHolder.countTotal, 1)}',
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

/// Since the Results module only need the output of data, we can collect
/// necessary data with the ResultsValueHolder
class ResultsValueHolder {
  final double countTotal;
  final double priceTotal;
  final Duration timeTotal;

  /// Since the Results module only needs the output of data, we can collect
  /// necessary data with the [ResultsValueHolder]
  ///
  /// NOTE: For simplicity sake, we use a Class rather than passing the data
  /// directly into the [ResultsModule] Widget
  ResultsValueHolder({
    this.countTotal,
    this.priceTotal,
    this.timeTotal,
  });
}
