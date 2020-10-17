import 'package:SimpleWindowCalculator/objects/WOManager.dart';
import 'package:SimpleWindowCalculator/widgets/WindowCounterV2.dart';

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

  _MyHomePage() {
    viewMods = true;
    Window defaultWindow = WOManager.getDefaultWindow();
    windowList.add(defaultWindow);

    windowCounter = WindowCounter(
      window: defaultWindow,
      updater: update,
      windowAdded: updateWindowList,
    );
  }

  format(Duration d) =>
      d.toString().split('.').first.split(':').take(2).join(":");

  updateWindowList(Window newWindow, Window oldWindow) {
    // Removing window with now count
    if (oldWindow.getCount() == 0) {
      setState(() {
        windowList.remove(oldWindow);
      });
    }

    // Check if window is already in the list
    for (int i = 0; i < windowList.length; i++) {
      // Found window already in list
      if (windowList[i].getName() == newWindow.getName()) {
        return windowList[i];
      }
    }

    windowList.add(newWindow);
    return null;
  }

  hideWidgets(bool hide) {
    setState(() {
      viewMods = !hide;
    });
  }

  update() {
    // Calculate price before adjustments
    var windowPriceTotal = 0.0;
    countTotal = 0.0;
    Duration time = Duration();

    setState(() {
      for (Window window in windowList) {
        windowPriceTotal += window.getTotal();
        countTotal += window.getCount();
        time += window.getTotalDuration();
      }

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

      timeTotal = format(time);
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

    TextStyle aStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.white],
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
                            '\$$priceTotal',
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
              // Counter Module ---------------
              Visibility(
                visible: viewMods,
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
            ],
          ),
        ),
      ),
    );
  }
}
