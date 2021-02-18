import 'dart:math';

import 'package:SimpleWindowCalculator/Tools/Calculator.dart';
import 'package:SimpleWindowCalculator/Tools/ImageLoader.dart';
import 'package:SimpleWindowCalculator/objects/Factor.dart';
import 'package:flutter/services.dart';

import '../Util/HexColors.dart';
import '../objects/OManager.dart';
import '../widgets/FactorCoin.dart';

import '../Util/Format.dart';
import '../GlobalValues.dart';
import 'package:flutter/material.dart';
import '../objects/Window.dart';

class WindowCounter extends StatefulWidget {
  final Window window;
  final double height;

  // Promps the bottom sheet modal allowing user to select
  // a new window. Needed for Window Preview button.
  final Function selectNewWindowFun;

  WindowCounter({
    @required this.window,
    @required this.selectNewWindowFun,
    this.height,
  });

  @override
  _WindowCounterState createState() => _WindowCounterState();
}

class _WindowCounterState extends State<WindowCounter> {
  @override
  Widget build(BuildContext context) {
    // final box = context.findRenderObject() as RenderBox;

    // if (box != null) height = box.size.height;

    final factorSize = widget.height / 6.5;
    // ErrorMargin is used to keep the the radius circular rather than
    // an ellipse (when used in conjuction with radii)
    final double errorMargin = factorSize * .8;
    // Using the center of FactorCoin as the point of reference
    final double radii = (widget.height / 2);

    // Inner Factor Position
    final double ifp_y = radii * sin(pi / 8) + radii - errorMargin;
    final double ifp_x = radii * cos(pi / 8) - errorMargin;

    // Outter Factor Position
    final double ofp_y = radii * sin(pi / 3) + radii - errorMargin;
    final double ofp_x = radii * cos(pi / 3) - errorMargin;

    final double ifp_y_top = radii * sin(-pi / 11) + radii - errorMargin;
    final double ofp_y_top = radii * sin(-pi / 3.75) + radii - errorMargin;

    return Container(
      height: widget.height,
      child: Stack(
        children: [
          buildPreview(context, factorSize),
          buildController(context, factorSize),

          // Filthy Factor
          Positioned(
            top: ofp_y_top,
            right: ofp_x,
            child: FactorCoin(
              factorKey: Factors.filthy,
              window: widget.window,
              size: factorSize,
              alignment: Alignment.center,
              backgroundColor: HexColors.fromHex('#DCA065'),
              isDummy: false,
            ),
          ),

          // Difficult Factor
          Positioned(
            top: ifp_y_top,
            right: ifp_x,
            child: FactorCoin(
              factorKey: Factors.difficult,
              window: widget.window,
              size: factorSize,
              alignment: Alignment.topCenter,
              backgroundColor: HexColors.fromHex('#FFEDA5'),
              isDummy: false,
            ),
          ),

          // Construction Factor
          Positioned(
            top: ifp_y,
            right: ifp_x,
            child: FactorCoin(
              factorKey: Factors.construction,
              window: widget.window,
              size: factorSize,
              alignment: Alignment.topCenter,
              backgroundColor: HexColors.fromHex('#FFB9B9'),
              isDummy: false,
            ),
          ),

          // Sided Factor
          Positioned(
            top: ofp_y,
            right: ofp_x,
            child: FactorCoin(
              factorKey: Factors.sided,
              window: widget.window,
              size: factorSize,
              alignment: Alignment.center,
              isDummy: false,
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
            '${Format.format(widget.window.quantity, 1)}',
            style: Theme.of(context).textTheme.headline6,
          ),
          buildWindowPreview(context),
          Text(
            '${widget.window.getName()}',
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
    Factor factor = widget.window.getFactor(factorKey);
    return Visibility(
      visible: factor.getCount() > 0 || factor.isAffixed(),
      child: Column(
        children: [
          Text(
            '${Format.format(factor.getCount(), 1)}',
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
          Opacity(
            opacity: .75,
            child: FactorCoin(
              factorKey: factorKey,
              window: widget.window,
              size: factorSize / 2,
              alignment: alignment,
              backgroundColor:
                  colorCode != null ? HexColors.fromHex(colorCode) : null,
            ),
          ),
          Text(
            '\$${Format.format((factor.calculatePrice(widget.window.price)), 0)}',
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
        ],
      ),
    );
  }

  buildController(BuildContext ctx, double factorSize) {
    final double factorPadding = factorSize * .9;
    final double _innerCircleSize = widget.height - factorPadding * 2;
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
        height: widget.height,
        width: widget.height,
        right: -widget.height / 2,
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
                      widget.window.amendCount(.5);
                      Calculator.instance.update();
                    },
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      widget.window.amendCount(1.0);
                      Calculator.instance.update();
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
                      widget.window.amendCount(-.5);
                      Calculator.instance.update();
                    },
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      widget.window.amendCount(-1.0);
                      Calculator.instance.update();
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
    final double previewSize = widget.height * .5;

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
            setState(() {});
          },
          builder: (ctx, candidates, rejects) {
            return candidates.length > 0
                // Convey to user that FactorCoin is expected
                ? GestureDetector(
                    onTap: () {
                      widget.selectNewWindowFun(context);
                    },
                    child: buildCard(Colors.blueGrey),
                  )
                : GestureDetector(
                    onTap: () {
                      widget.selectNewWindowFun(context);
                    },
                    child: buildCard(Colors.transparent),
                  );
          },
        ),
      ),
    );
  }

  buildCard(Color color) {
    Imager imager = Imager.fromFile(widget.window.getImageFile());

    return Container(
      padding: const EdgeInsets.all(4),
      width: widget.height * .5,
      height: widget.height * .5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: imager.masterImage.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
