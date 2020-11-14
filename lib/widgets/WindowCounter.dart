import 'dart:math';

import '../Tools/HexColors.dart';
import '../objects/OManager.dart';
import '../widgets/FactorCoin.dart';

import '../Tools/Format.dart';
import '../Tools/GlobalValues.dart';
import 'package:flutter/material.dart';
import '../objects/Window.dart';

class WindowCounter extends StatelessWidget {
  final Window window;
  final double height;

  // Updates ResultsModule from main
  final Function calculator;

  // Promps the bottom sheet modal allowing user to select
  // a new window. Needed for Window Preview button.
  final Function selectNewWindowFun;

  WindowCounter(
      {@required this.window,
      @required this.calculator,
      @required this.selectNewWindowFun,
      this.height});

  @override
  Widget build(BuildContext context) {
    final factorSize = height / 6;
    // Using the center of FactorCoin as the point of reference
    final double radi = height / 2 - factorSize / 2;

    return Container(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: GlobalValues.appMargin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${Format.format(window.getCount(), 1)}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                buildWindowPreview(context),
                Text(
                  '${window.getName()}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          buildController(context, factorSize),

          // Filthy Factor
          Positioned(
            bottom: radi * sin(7 * pi / 24) + radi,
            right: radi * cos(7 * pi / 24),
            child: FactorCoin(
              factorKey: Factors.filthy,
              window: window,
              size: factorSize,
              alignment: Alignment.topCenter,
              backgroundColor: HexColors.fromHex('#DCA065'),
              updateTotal: calculator,
            ),
          ),

          // Difficult Factor
          Positioned(
            bottom: radi * sin(pi / 12) + radi,
            right: radi * cos(pi / 12),
            child: FactorCoin(
              factorKey: Factors.difficult,
              window: window,
              size: factorSize,
              alignment: Alignment.topCenter,
              backgroundColor: HexColors.fromHex('#FFEDA5'),
              updateTotal: calculator,
            ),
          ),

          // Construction Factor
          Positioned(
            top: radi * sin(pi / 12) + radi,
            right: radi * cos(pi / 12),
            child: FactorCoin(
              factorKey: Factors.construction,
              window: window,
              size: factorSize,
              alignment: Alignment.topCenter,
              backgroundColor: HexColors.fromHex('#FFB9B9'),
              updateTotal: calculator,
            ),
          ),

          Positioned(
            top: radi * sin(7 * pi / 24) + radi,
            right: radi * cos(7 * pi / 24),
            child: FactorCoin(
              factorKey: Factors.sided,
              window: window,
              size: factorSize,
              alignment: Alignment.topCenter,
              updateTotal: calculator,
            ),
          ),
        ],
      ),
    );
  }

  buildWindowPreview(BuildContext context) {
    final double previewSize = height * .6;

    return Container(
      color: Colors.transparent,
      height: previewSize,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: DragTarget<Function>(
          onWillAccept: (fun) => fun != null,
          onAccept: (updateVisuals) {
            // Updates the FactorCoin visuals
            updateVisuals();
          },
          builder: (ctx, candidates, rejects) {
            return candidates.length > 0
                ? GestureDetector(
                    onTap: () {
                      selectNewWindowFun(context);
                    },
                    child: buildCard(Colors.redAccent),
                  )
                : GestureDetector(
                    onTap: () {
                      selectNewWindowFun(context);
                    },
                    child: buildCard(Colors.transparent),
                  );
          },
        ),
      ),
    );
  }

  buildController(BuildContext ctx, double factorSize) {
    final double factorPadding = factorSize * .75;
    final double _innerCircleSize = height - factorPadding * 2;
    final double buttonSize = _innerCircleSize * .25;

    // Calculate Button Positioning
    // Calculated as Positioned from right
    final double _buttonCenterPosR =
        _innerCircleSize / 2 + GlobalValues.appMargin - buttonSize / 2;
    final double _radius = _innerCircleSize / 2;
    final double _circlePoint =
        sqrt(pow(_radius, 2) - pow(_buttonCenterPosR, 2));
    // Final Result
    final double buttonWidth = _circlePoint - buttonSize / 4;

    return Stack(overflow: Overflow.clip, children: [
      Positioned(
        height: height,
        width: height,
        right: -height / 2,
        child: Container(
          padding: EdgeInsets.all(factorPadding),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: _innerCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(ctx).primaryColor,
              ),
            ),
            Positioned(
              right: _innerCircleSize / 2 + GlobalValues.appMargin,
              child: Column(
                children: [
                  // INCREMENTING BUTTON
                  GestureDetector(
                    onLongPress: () {
                      window.amendCount(.5);
                      calculator();
                    },
                    onTap: () {
                      window.amendCount(1.0);
                      calculator();
                    },
                    child: Card(
                      elevation: 5,
                      shape: CircleBorder(side: BorderSide.none),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(ctx).primaryColor,
                        size: buttonSize,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: buttonWidth,
                  ),

                  // DECREMENTING BUTTON
                  GestureDetector(
                    onLongPress: () {
                      window.amendCount(-.5);
                      calculator();
                    },
                    onTap: () {
                      window.amendCount(-1.0);
                      calculator();
                    },
                    child: Card(
                      elevation: 5,
                      shape: CircleBorder(side: BorderSide.none),
                      child: Icon(
                        Icons.remove,
                        color: Theme.of(ctx).primaryColor,
                        size: buttonSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    ]);
  }

/*
 * Builds window preview card. Needed because of dragging.
 */
  buildCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: window.getPicture(),
    );
  }
}
