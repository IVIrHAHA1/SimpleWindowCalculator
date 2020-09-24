import 'package:SimpleWindowCalculator/objects/CounterObsverver.dart';

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Window> windowList = [
    Window(name: '1st Story Window', time: 10, price: 12),
    Window(name: '2nd Story Window', time: 12, price: 12),
  ];

  @override
  Widget build(BuildContext context) {
    AppBar mAppBar = AppBar(
      title: Text('Simple Window Calculator'),
    );

// Get available screen space
    double screenSize = MediaQuery.of(context).size.height -
        mAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;


// Observer notifies windgets dependent on Counter values
// TODO: Reorganize code to make this process simpler
    CounterObserver countObserver = CounterObserver();

    return Scaffold(
      appBar: mAppBar,
      body: Column(
        children: <Widget>[
          
          ResultsModule(
            height: screenSize * .30,
            observer: countObserver,
          ),

          CounterModule(
            height: screenSize * .50,
            windowList: windowList,
            observer: countObserver,
          ),
        ],
      ),
    );
  }
}