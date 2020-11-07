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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  Window activeWindow;

  var priceTotal;
  var timeTotal;
  var countTotal;

  bool viewMods;

  static const double mDRIVETIME = 25;
  static const double mMIN_PRICE = 150;

  _MyHomePage() {
    viewMods = true;
    activeWindow = OManager.getDefaultWindow();
    windowList.add(activeWindow);
  }

/*
 *  This method updates the master list appropriately and assigns 
 *  activeWindow if needed.
 */
  _updateWindowList(Window newWindow, Window oldWindow) {
    setState(() {
      // STEP 1: Remove window with a zero count value
      if (oldWindow.getCount() == 0) {
        windowList.remove(oldWindow);
      }

      // STEP 2: Get window if it already exists in the master list
      for (int i = 0; i < windowList.length; i++) {
        // Found window already in list
        if (windowList[i].getName() == newWindow.getName()) {
          activeWindow = windowList[i];
          return windowList[i];
        }
      }

      // STEP 3: If the window is in fact "new" then add it to the master list
      activeWindow = newWindow;
      windowList.add(activeWindow);
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

  calculateResults() {
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
      actions: [
        IconButton(
          onPressed: _clearProject,
          icon: Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        )
      ],
      textTheme: Theme.of(context).textTheme,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'The Window Calculator',
      ),
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
                child: FactorModule(activeWindow, calculateResults),
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    width: double.infinity,
                    child: Container(
                      child: WindowCounter(
                        window: activeWindow,
                        totalsUpdater: calculateResults,
                        selectNewWindowFun: selectNewWindow,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
   * Modal sheet used to select new window
   */
  void selectNewWindow(BuildContext ctx) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GridView.count(
          crossAxisCount: 3,
          children: OManager.windows.map((element) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Card(
                child: Column(
                  children: [
                    Container(
                      child: element.getPicture(),
                      width: MediaQuery.of(ctx).size.width / 4,
                    ),
                    Text(element.getName()),
                  ],
                ),
              ),
              onTap: () {
                _addNewWindow(element);
              },
            );
          }).toList(),
        );
      },
    );
  }

  _addNewWindow(Window newWindow) {
    // Save current window
    Window existingWindow = _updateWindowList(newWindow, activeWindow);

    // Update Counter to new window
    setState(() {
     activeWindow = existingWindow == null ? newWindow : existingWindow;
    });

    Navigator.of(context).pop();
  }

  _clearProject() {
    setState(() {
      windowList.forEach((window) {
        window.setCount(count: 0);
        window = null;
      });
      windowList.clear();
      activeWindow = OManager.getDefaultWindow();
      windowList.add(activeWindow);
      calculateResults();
    });
  }
}
