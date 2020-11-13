import 'package:SimpleWindowCalculator/Tools/HexColors.dart';
import 'package:flutter/material.dart';
import '../objects/Window.dart';

class WindowCounter extends StatelessWidget {
  final Window window;

  // Updates ResultsModule from main
  final Function totalsUpdater;

  // Promps the bottom sheet modal allowing user to select
  // a new window. Needed for Window Preview button.
  final Function selectNewWindowFun;

  WindowCounter(
      {@required this.window,
      @required this.totalsUpdater,
      @required this.selectNewWindowFun});

  @override
  Widget build(BuildContext context) {
    return buildInnerController(context);
  }

  Container buildInnerController(BuildContext ctx) {
    const double buttonSize = .2;
    var screenWidth = MediaQuery.of(ctx).size.width * .8;

    return Container(
      padding: EdgeInsets.all(32),  // TODO: Make dependent on Factor Coin size
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(ctx).primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // DECREMENTING BUTTON
            Container(
              child: GestureDetector(
                onTap: () {
                  window.amendCount(-1.0);
                  totalsUpdater();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(ctx).primaryColor,
                    size: screenWidth * buttonSize,
                  ),
                ),
              ),
            ),

            // INCREMENTING BUTTON
            Container(
              child: GestureDetector(
                onTap: () {
                  window.amendCount(1.0);
                  totalsUpdater();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Theme.of(ctx).primaryColor,
                    size: screenWidth * buttonSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
