import 'package:SimpleWindowCalculator/Animations/SizingTween.dart';
import 'package:SimpleWindowCalculator/Tools/GlobalValues.dart';
import 'package:SimpleWindowCalculator/widgets/ModalContent.dart';

import './Tools/HexColors.dart';
import './objects/OManager.dart';
import './widgets/OverviewModule.dart';
import './widgets/WindowCounter.dart';

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
        primarySwatch: HexColors.createMaterialColor(
          '#51AFFF',
        ),
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

class _MyHomePage extends State with SingleTickerProviderStateMixin {
  final List<Window> windowList = List();
  Window activeWindow;

  var priceTotal;
  var timeTotal;
  var countTotal;

  _MyHomePage() {
    activeWindow = OManager.getDefaultWindow();
    windowList.add(activeWindow);
  }

  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: GlobalValues.animDuration ~/ 1.1),
      reverseDuration: Duration(milliseconds: GlobalValues.animDuration ~/ 1.1),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Needs to be here because of clear onPressed
    AppBar mAppBar = AppBar(
      // leading: Icon(
      //   Icons.menu,
      //   color: Colors.white,
      // ),
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
    availableScreen = MediaQuery.of(context).size.height -
        mAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Container(
      // This is to allow linear gradient behind the appBar
      // block begin:
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: mAppBar,
        // block end:

        body: buildModules(availableScreen),
      ),
    );
  }

  /*  -----------------------------------------------------------------------
   *                        BUILD CONTENT/MODULES
   *  -------------------------------------------------------------------- */
  Container buildModules(double availableScreen) {
    return Container(
      height: availableScreen,
      child: Column(
        children: <Widget>[
          // Results
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ResultsModule(
              height: availableScreen,
              triggerExpandAnim: triggerExpandAnim,
              valueHolder: ResultsValueHolder(
                priceTotal: priceTotal,
                timeTotal: timeTotal,
                countTotal: countTotal,
                windowList: windowList,
              ),
            ),
          ),

          // Empty space seperator
          Flexible(
            fit: FlexFit.tight,
            child: Container(),
          ),

          // Counter Module
          SizingTween(
            controller: _controller,
            size: availableScreen * .5,
            child: WindowCounter(
              height: availableScreen * .5,
              window: activeWindow,
              calculator: calculateResults,
              selectNewWindowFun: selectNewWindow,
            ),
          ),
        ],
      ),
    );
  }

  double availableScreen;

  triggerExpandAnim(bool hide) {
    if (hide)
      _controller.forward();
    else
      _controller.reverse();

    setState(() {
      // viewMods = !hide;
    });
  }

  /*  -----------------------------------------------------------------------
   *                            DATA MUNIPS
   *  -------------------------------------------------------------------- */
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

  /*
   *  Calculates and updates results 
   */
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

      /// If all window have no price or time totals then
      /// set values to zero
      if (windowPriceTotal == 0.0) {
        priceTotal = 0.0;
        timeTotal = Duration();
      } else {
        // Add Drive time
        priceTotal = windowPriceTotal + DRIVETIME;

        // Round up to an increment of 5, for pricing simplicity
        var temp = priceTotal % 5;
        if (temp != 0) {
          priceTotal += (5 - temp);
        }

        // Ensure price is not below minimum
        if (priceTotal < PRICE_MIN) {
          priceTotal = PRICE_MIN;
        }

        timeTotal = time;
      }
    });
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
      // Reset Individual Window
      windowList.forEach((window) {
        window.setCount(count: 0);
        window.resetFactors();
        window = null;
      });
      // Reset Window List
      windowList.clear();
      activeWindow = OManager.getDefaultWindow();
      windowList.add(activeWindow);
      calculateResults();
    });
  }

  /*  -----------------------------------------------------------------------
   *                        GUI POP UPS/MUNIPS
   *  -------------------------------------------------------------------- */
  void selectNewWindow(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return ModalContent(
          addWindow: _addNewWindow,
        );
      },
    );
  }
}
