import 'package:SimpleWindowCalculator/objects/CounterObsverver.dart';
import 'package:flutter/foundation.dart';

import 'widgets/CounterModule.dart';
import 'widgets/ResultsModule.dart';
import './objects/Window.dart';
import 'package:flutter/material.dart';
import 'widgets/OverviewModule.dart';

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
  final List<Window> windowList = [
    Window(
        name: '1st Story Window', duration: Duration(minutes: 10), price: 12),
    Window(duration: Duration(minutes: 12), price: 12.50),
  ];

  var priceTotal;
  var timeTotal;

  static const double mDRIVETIME = 25;
  static const double mMIN_PRICE = 150;

  format(Duration d) =>
      d.toString().split('.').first.split(':').take(2).join(":");

  update() {
    // Calculate price before adjustments
    var windowTotal = 0.0;
    for (Window window in windowList) {
      windowTotal += window.getTotal();
    }

    // Add Drive time
    priceTotal = windowTotal + mDRIVETIME;

    // Round for price simplicity
    var temp = priceTotal % 5;
    if (temp != 0) {
      priceTotal += (5 - temp);
    }

    // Ensure price is not below minimum
    if (priceTotal < mMIN_PRICE) {
      priceTotal = mMIN_PRICE;
    }

    timeTotal = format(
        windowList[0].getTotalDuration() + windowList[1].getTotalDuration());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppBar mAppBar = AppBar(
      title: Text('Simple Window Calculator'),
    );

// Get available screen space
    double screenSize = MediaQuery.of(context).size.height -
        mAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    TextStyle a_style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    return Scaffold(
      appBar: mAppBar,
      body: Column(
        children: <Widget>[
          ResultsModule(
            height: screenSize * .35,
            children: [
              priceTotal != null
                  ? Text(
                      '\$$priceTotal',
                      style: a_style,
                    )
                  : Text(
                      '\$0',
                      style: a_style,
                    ),
              timeTotal != null
                  ? Text(
                      '$timeTotal',
                      style: a_style,
                    )
                  : Text(
                      '0:00',
                      style: a_style,
                    ),
            ],
          ),
          CounterModule(
            height: screenSize * .50,
            windowList: windowList,
            function: update,
          ),
        ],
      ),
    );
  }
}
