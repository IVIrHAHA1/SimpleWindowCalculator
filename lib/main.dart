import 'package:SimpleWindowCalculator/Tools/HexColors.dart';
import 'package:SimpleWindowCalculator/objects/OManager.dart';
import 'package:SimpleWindowCalculator/widgets/FactorModule.dart';
import 'package:SimpleWindowCalculator/widgets/WindowCounter.dart';
import 'package:SimpleWindowCalculator/widgets/WindowPallet.dart';
import 'package:SimpleWindowCalculator/widgets/WindowPallet_pu.dart';

import 'Tools/Format.dart';
import 'widgets/ResultsModule.dart';
import './objects/Window.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              headline5: TextStyle(
                fontFamily: 'Lato',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              bodyText1: TextStyle(
                  fontFamily: 'OpenSans', fontWeight: FontWeight.normal),
            ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State {
  final List<Window> windowList = List();

  var priceTotal;
  var timeTotal;
  var countTotal;

  WindowCounter windowCounter;
  bool viewMods;

  static const double mDRIVETIME = 25;
  static const double mMIN_PRICE = 150;

  Window activeWindow;

  _MyHomePage() {
    viewMods = true;
    Window defaultWindow = OManager.getDefaultWindow();
    windowList.add(defaultWindow);

    activeWindow = defaultWindow;
    windowCounter = WindowCounter(
      window: defaultWindow,
      updater: update,
      windowAddedFunction: updateWindowList,
    );
  }

  updateWindowList(Window newWindow, Window oldWindow) {
    setState(() {
      // Removing window with now count
      if (oldWindow.getCount() == 0) {
        windowList.remove(oldWindow);
      }

      // Check if window is already in the list
      for (int i = 0; i < windowList.length; i++) {
        // Found window already in list
        if (windowList[i].getName() == newWindow.getName()) {
          activeWindow = windowList[i];
          return windowList[i];
        }
      }

      activeWindow = newWindow;
      windowList.add(newWindow);
      return null;
    });
  }

  hideWidgets(bool hide) {
    setState(() {
      viewMods = !hide;
    });
  }

  showPallet() {
    Navigator.push(
      context,
      WindowPalletPU(
        top: 0,
        bottom: 0,
        left: 0,
        right: MediaQuery.of(context).size.width / 2,
        child: WindowPallet(windowList),
      ),
    );
  }

  update() {
    // Calculate price before adjustments
    var windowPriceTotal = 0.0;
    countTotal = 0.0;
    Duration time = Duration();

    setState(() {
      for (Window window in windowList) {
        window.update();
        windowPriceTotal += window.grandTotal();
        countTotal += window.getCount();
        time += window.getTotalDuration();
      }

      if (windowPriceTotal == 0.0) {
        priceTotal = 0.0;
        timeTotal = Format.formatTime(Duration());
      } else {
        // Add Drive time
        priceTotal = windowPriceTotal + mDRIVETIME;

        // Round up to increment of 5, for pricing simplicity
        var temp = priceTotal % 5;
        if (temp != 0) {
          priceTotal += (5 - temp);
        }

        // Ensure price is not below minimum
        if (priceTotal < mMIN_PRICE) {
          priceTotal = mMIN_PRICE;
        }

        timeTotal = Format.formatTime(time);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar mAppBar = AppBar(
      leading: Icon(Icons.menu),
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text('The Window Calculator'),
    );

// Get available screen space
    double availableScreen = MediaQuery.of(context).size.height -
        mAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    TextStyle aStyle = Theme.of(context).textTheme.headline5;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [HexColors.fromHex('#1C85DF'), Colors.white],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: mAppBar,
        body: Container(
          height: availableScreen,
          child: Column(
            children: <Widget>[
              // Results ---------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ResultsModule(
                  height: availableScreen,
                  hideViews: hideWidgets,
                  windows: windowList,
                  children: [
                    priceTotal != null
                        ? Text(
                            '\$${Format.format(priceTotal)}',
                            style: aStyle,
                          )
                        : Text(
                            '\$0',
                            style: aStyle,
                          ),
                    timeTotal != null
                        ? Text(
                            '$timeTotal',
                            style: aStyle,
                          )
                        : Text(
                            '0:00',
                            style: aStyle,
                          ),
                  ],
                  count: countTotal,
                ),
              ),

              Flexible(
                fit: FlexFit.tight,
                child: Container(),
              ),

              Visibility(
                visible: viewMods,
                child: FactorModule(activeWindow, update),
              ),

              // Counter Module ---------------
              Visibility(
                visible: viewMods,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dx > 0) {
                      showPallet();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          style: BorderStyle.solid,
                          width: 2,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                    width: double.infinity,
                    child: windowCounter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
