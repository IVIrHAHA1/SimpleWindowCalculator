import 'dart:async';

import 'package:SimpleWindowCalculator/Tools/DatabaseProvider.dart';
import 'package:SimpleWindowCalculator/Util/ItemsManager.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';

import './Tools/HexColors.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'objects/OManager.dart';

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
      home: MySplashScreen(),
    );
  }
}

class MySplashScreen extends StatelessWidget {
  _router(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MyHomePage(),
      ),
    );
  }

  Future<void> _initData() async {
    print('INITIALIZING DATA...');
    ItemsManager.init<Window>();

    /// Set the active window
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
        child: Text('Hello world!'),
      ),
    );
  }
}
