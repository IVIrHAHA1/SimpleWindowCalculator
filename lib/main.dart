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
  final List<Window> windowList = [
    Window(),
  ];

  var priceTotal;
  var timeTotal;
  var countTotal;

  static const double mDRIVETIME = 25;
  static const double mMIN_PRICE = 150;

  format(Duration d) =>
      d.toString().split('.').first.split(':').take(2).join(":");

    void selectNewWindow(BuildContext ctx) {
      print('trying to grab new window');
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                Image.asset('assets/images/standard_window.png'),
                Image.asset('assets/images/french_window.png'),
              ],
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  update() {
    // Calculate price before adjustments
    var windowPriceTotal = 0.0;
    countTotal = 0.0;
    for (Window window in windowList) {
      windowPriceTotal += window.getTotal();
      countTotal += window.getCount();
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

    TextStyle aStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    return Scaffold(
      appBar: mAppBar,
      body: Container(
        height: screenSize,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: <Widget>[
            // Results ---------------------
            ResultsModule(
              height: screenSize * .3,
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

            // Recently Used Module ---------
            Container(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text('Recently Used'),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Icon(Icons.explicit),
                        Icon(Icons.explicit),
                        Icon(Icons.explicit)
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Divider  ---------------------
            Divider(
              height: 30,
              thickness: 3,
              color: Colors.black54,
            ),

            // Counter Module ---------------
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                child: WindowCounter(
                  window: windowList[0],
                  updater: update,
                  selector: selectNewWindow,
                ),
              ),
            ),

            // Tags Module  -----------------
            Container(
              height: screenSize * .10,
              child: Card(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      child: IconButton(
                        icon: Icon(Icons.flag),
                      ),
                    ),
                    Card(
                      child: IconButton(
                        icon: Icon(Icons.flag),
                      ),
                    ),
                    Card(
                      child: IconButton(
                        icon: Icon(Icons.flag),
                      ),
                    ),
                    Card(
                      child: IconButton(
                        icon: Icon(Icons.flag),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
