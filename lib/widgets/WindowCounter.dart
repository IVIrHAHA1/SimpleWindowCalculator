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
    const double buttonSize = .3;

    var screenWidth = MediaQuery.of(context).size.width * .8;
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // DECREMENTING BUTTON
              Container(
                child: GestureDetector(
                  onTap: () {
                    window.amendCount(-1.0);
                    totalsUpdater();
                  },
                  child: Image.asset(
                    'assets/images/decrement_btn.png',
                    height: screenWidth * buttonSize,
                    width: screenWidth * buttonSize,
                  ),
                ),
              ),

              // WINDOW PREVIEW
              DragTarget<Function>(
                onWillAccept: (fun) => fun != null,
                onAccept: (updateVisuals) {
                  // Updates the FactorCoin visuals
                  updateVisuals();
                },
                builder: (ctx, candidates, rejects) {
                  return candidates.length > 0
                      ? IconButton(
                          iconSize:
                              screenWidth * .3, // TODO: Make this more dynamic
                          onPressed: () {
                            selectNewWindowFun(context);
                          },
                          icon: buildCard(Theme.of(context).primaryColor),
                        )
                      : IconButton(
                          iconSize:
                              screenWidth * .3, // TODO: Make this more dynamic
                          onPressed: () {
                            selectNewWindowFun(context);
                          },
                          icon: buildCard(Colors.white),
                        );
                },
              ),

              // INCREMENTING BUTTON
              Container(
                child: GestureDetector(
                  onTap: () {
                    window.amendCount(1.0);
                    totalsUpdater();
                  },
                  child: Image.asset(
                    'assets/images/increment_btn.png',
                    height: screenWidth * buttonSize,
                    width: screenWidth * buttonSize,
                  ),
                ),
              ),
            ],
          ),
          Text(window.getName(), style: Theme.of(context).textTheme.bodyText1),
        ],
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
