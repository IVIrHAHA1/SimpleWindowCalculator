import 'dart:math';

import 'package:flutter/services.dart';

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
    final factorSize = height / 6.5;
    // ErrorMargin is used to keep the the radius circular rather than
    // an ellipse (when used in conjuction with radii)
    final double errorMargin = factorSize * .8;
    // Using the center of FactorCoin as the point of reference
    final double radii = (height / 2);

    // Inner Factor Position
    final double ifp_y = radii * sin(pi / 8) + radii - errorMargin;
    final double ifp_x = radii * cos(pi / 8) - errorMargin;

    // Outter Factor Position
    final double ofp_y = radii * sin(pi / 3) + radii - errorMargin;
    final double ofp_x = radii * cos(pi / 3) - errorMargin;

    return Container(
      height: height,
      child: Stack(
        children: [
          buildPreview(context, factorSize),
          buildController(context, factorSize),

          // Filthy Factor
          Positioned(
            bottom: ofp_y,
            right: ofp_x,
            child: FactorCoin(
              factorKey: Factors.filthy,
              window: window,
              size: factorSize,
              alignment: Alignment.center,
              backgroundColor: HexColors.fromHex('#DCA065'),
              updateResultsMod: calculator,
            ),
          ),

          // Difficult Factor
          Positioned(
            bottom: ifp_y,
            right: ifp_x,
            child: FactorCoin(
              factorKey: Factors.difficult,
              window: window,
              size: factorSize,
              alignment: Alignment.topCenter,
              backgroundColor: HexColors.fromHex('#FFEDA5'),
              updateResultsMod: calculator,
            ),
          ),

          // Construction Factor
          Positioned(
            top: ifp_y,
            right: ifp_x,
            child: FactorCoin(
              factorKey: Factors.construction,
              window: window,
              size: factorSize,
              alignment: Alignment.topCenter,
              backgroundColor: HexColors.fromHex('#FFB9B9'),
              updateResultsMod: calculator,
            ),
          ),

          // Sided Factor
          Positioned(
            top: ofp_y,
            right: ofp_x,
            child: FactorCoin(
              factorKey: Factors.sided,
              window: window,
              size: factorSize,
              alignment: Alignment.center,
              updateResultsMod: calculator,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPreview(BuildContext context, double factorSize) {
    double width = MediaQuery.of(context).size.width / 2;

    return Positioned(
      left: GlobalValues.appMargin,
      child: Column(
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

          // Factor Row
          Container(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildDummyCoin(
                  factorSize,
                  '#DCA065',
                  Alignment.center,
                  Factors.filthy,
                ),
                buildDummyCoin(
                  factorSize,
                  '#FFEDA5',
                  Alignment.topCenter,
                  Factors.difficult,
                ),
                buildDummyCoin(
                  factorSize,
                  '#FFB9B9',
                  Alignment.topCenter,
                  Factors.construction,
                ),
                buildDummyCoin(
                  factorSize,
                  null,
                  Alignment.center,
                  Factors.sided,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDummyCoin(
    double factorSize,
    String colorCode,
    Alignment alignment,
    Factors factorKey,
  ) {
    return Column(
      children: [
        Text(
          '${Format.format(window.getFactor(factorKey).getCount(), 1)}',
          style: TextStyle(color: Colors.white, fontSize: 8),
        ),
        Opacity(
          opacity: .75,
          child: FactorCoin(
            factorKey: factorKey,
            window: window,
            size: factorSize / 2,
            alignment: alignment,
            backgroundColor:
                colorCode != null ? HexColors.fromHex(colorCode) : null,
          ),
        ),
        Text(
          '\$${Format.format((window.getFactor(factorKey).calculatePrice(window.getPrice())), 0)}',
          style: TextStyle(color: Colors.white, fontSize: 8),
        ),
      ],
    );
  }

  buildController(BuildContext ctx, double factorSize) {
    final double factorPadding = factorSize * .9;
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
                      HapticFeedback.mediumImpact();
                      window.amendCount(.5);
                      calculator();
                    },
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      window.amendCount(1.0);
                      calculator();
                    },
                    child: Card(
                      elevation: 5,
                      shape: CircleBorder(side: BorderSide.none),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(ctx).primaryColor,
                        size: buttonSize * 1.2,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: buttonWidth * .5,
                  ),

                  // DECREMENTING BUTTON
                  GestureDetector(
                    onLongPress: () {
                      HapticFeedback.mediumImpact();
                      window.amendCount(-.5);
                      calculator();
                    },
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      window.amendCount(-1.0);
                      calculator();
                    },
                    child: Card(
                      elevation: 5,
                      shape: CircleBorder(side: BorderSide.none),
                      child: Icon(
                        Icons.remove,
                        color: Theme.of(ctx).primaryColor,
                        size: buttonSize * .8,
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

  buildWindowPreview(BuildContext context) {
    final double previewSize = height * .5;

    return Container(
      color: Colors.transparent,
      height: previewSize,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

/*
 * Builds window preview card. Needed because of dragging.
 */
  buildCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: window.getPicture(),
    );
  }
}
