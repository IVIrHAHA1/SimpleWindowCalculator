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
            ),

            // Total Window Count -----------
            ListTile(
              leading: Text(
                'Total Window Count',
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Container(
                width: 75,
                height: 50,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blue,
                  child: Center(
                    child: Text('0'),
                  ),
                ),
              ),
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
                width: MediaQuery.of(context).size.width * .75,
                child: Column(
                  children: [
                    Text('count'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: null,
                            child: Image.asset(
                              'assets/images/decrement_btn.png',
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Image.asset(
                            'assets/images/standard_window.png',
                            height: 90,
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: null,
                            child: Image.asset(
                              'assets/images/increment_btn.png',
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('Label')
                  ],
                ),
              ),
            ),

            // Tags Module  -----------------
            Container(
              height: screenSize * .10,
              child: Card(
                color: Colors.blue,
                child: Row(
                  children: [
                    Card(
                      color: Colors.deepOrangeAccent,
                      child: Text('1'),
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
