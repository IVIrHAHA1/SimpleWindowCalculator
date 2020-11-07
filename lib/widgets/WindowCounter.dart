import 'package:flutter/material.dart';
import '../objects/Window.dart';
import '../objects/OManager.dart';

class WindowCounter extends StatelessWidget {
  final Window window;
  final Function totalsUpdater, selectWindowFun;

  WindowCounter(
      {@required this.window,
      @required this.totalsUpdater,
      @required this.selectWindowFun});

// class _WindowCounterState extends State<WindowCounter> {
//   Window _window;
//   final Function _updater, _updateWindowList;

//   Image windowImage;

//   _WindowCounterState(this._window, this._updater, this._updateWindowList) {
//     windowImage = this._window.getPicture();
//   }

  @override
  Widget build(BuildContext context) {
    const double buttonSize = .3;

    var screenWidth = MediaQuery.of(context).size.width * .8;
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Window Count Decrementing Button
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

              // Window Preview
              DragTarget<Function>(
                onWillAccept: (fun) => fun != null,
                onAccept: (updateVisuals) {
                  // Updates the FactorCoin visuals
                  updateVisuals();
                },
                builder: (ctx, candidates, rejects) {
                  return candidates.length > 0
                      ? IconButton(
                          iconSize: screenWidth * .3,
                          onPressed: () {
                            selectWindowFun(context);
                          },
                          icon: buildCard(Theme.of(context).primaryColor),
                        )
                      : IconButton(
                          iconSize: screenWidth * .3,
                          onPressed: () {
                            selectWindowFun(context);
                          },
                          icon: buildCard(Colors.white),
                        );
                },
              ),

              // Window Count Incrementing Button
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

  Card buildCard(Color color) {
    return Card(
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey,
            style: BorderStyle.solid,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Container(
        color: color,
        child: window.getPicture(),
        padding: EdgeInsets.all(4),
      ),
    );
  }
}
