import 'dart:async';

import 'package:SimpleWindowCalculator/Tools/DatabaseProvider.dart';
import 'package:SimpleWindowCalculator/Util/ItemsManager.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';

import 'Util/HexColors.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'objects/OManager.dart';

void main() {
  runApp(MyApp());
}

/// Initializing ThemeData (Colors and Textstyles)
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
      home: MySplashScreen(),
    );
  }
}

/// Splash Screen which instantiates any AppData (Database and default values) the user may need
/// upon start up.
class MySplashScreen extends StatelessWidget {
  // Replaces the splash screen with the approriate route
  _router(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MyHomePage(),
      ),
    );
  }

  // Instantiate the data as mentioned in the class description
  Future<void> _initData() async {
    print('INITIALIZING DATA...');
    // Prepare the window list and Manager instance
    ItemsManager.init<Window>();

    // Initialize database if not created yet
    

    // Set the active window as dictated by the OManager
    Window startingWindow = await DatabaseProvider.instance.queryWindow(
      OManager.getDefaultWindow().name,
    );

    if (startingWindow != null) {
      ItemsManager.instance.activeItem = startingWindow;
      print('INITIALIZED ACTIVE WINDOW: ${ItemsManager.instance.activeItem.name}');
      return;
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    _initData().whenComplete(() {
      _router(context);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        alignment: Alignment.center,
        /// TODO: Still needs to be finished
        child: Text('Hello world!'),
      ),
    );
  }
}
