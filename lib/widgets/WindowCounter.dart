import 'package:SimpleWindowCalculator/Tools/HexColors.dart';
import 'package:flutter/material.dart';
import '../objects/Window.dart';

class WindowCounter extends StatelessWidget {
  final Window window;
  final double height;

  // Updates ResultsModule from main
  final Function totalsUpdater;

  // Promps the bottom sheet modal allowing user to select
  // a new window. Needed for Window Preview button.
  final Function selectNewWindowFun;

  WindowCounter(
      {@required this.window,
      @required this.totalsUpdater,
      @required this.selectNewWindowFun,
      this.height});

  @override
  Widget build(BuildContext context) {
    return buildInnerController(context);
  }

  buildInnerController(BuildContext ctx) {
    const double factorPadding = 32; // TODO: Make dependent on Factor Coin size
    final double innerCircleSize = height - factorPadding * 2;
    final double buttonSize = innerCircleSize * .25;

    return Container(
      height: height,
      child: Stack(
        overflow: Overflow.clip,
        children: [
        Positioned(
          height: height,
          width: height,
          right: -height/2,
          child: Container(
            padding: EdgeInsets.all(factorPadding),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Stack(alignment: Alignment.center, children: [
              Container(
                height: innerCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(ctx).primaryColor,
                ),
              ),
              Positioned(
                right: innerCircleSize / 2 + 8,     // TODO: MAKE MARGIN GLOBAL
                child: Column(
                  children: [
                    // DECREMENTING BUTTON
                    GestureDetector(
                      onTap: () {
                        window.amendCount(-1.0);
                        totalsUpdater();
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
                      height: innerCircleSize - (buttonSize * 2),
                    ),

                    // INCREMENTING BUTTON
                    GestureDetector(
                      onTap: () {
                        window.amendCount(1.0);
                        totalsUpdater();
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
      ]),
    );
  }

/*
 * Builds window preview card. Needed because of dragging.
 */
  Card buildCard(Color color) {
    return Card(
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        color: color,
        child: window.getPicture(),
        padding: const EdgeInsets.all(4),
      ),
    );
  }
}

// // WINDOW PREVIEW
// DragTarget<Function>(
//   onWillAccept: (fun) => fun != null,
//   onAccept: (updateVisuals) {
//     // Updates the FactorCoin visuals
//     updateVisuals();
//   },
//   builder: (ctx, candidates, rejects) {
//     return candidates.length > 0
//         ? IconButton(
//             iconSize:
//                 screenWidth * .3, // TODO: Make this more dynamic
//             onPressed: () {
//               selectNewWindowFun(context);
//             },
//             icon: buildCard(Theme.of(context).primaryColor),
//           )
//         : IconButton(
//             iconSize:
//                 screenWidth * .3, // TODO: Make this more dynamic
//             onPressed: () {
//               selectNewWindowFun(context);
//             },
//             icon: buildCard(Colors.white),
//           );
//   },
// ),
