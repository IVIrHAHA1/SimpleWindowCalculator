import './widgets/Counter.dart';
import './widgets/TechDetails.dart';
import './widgets/Totals.dart';
import './widgets/WindowListItem.dart';
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

    double screenSize = MediaQuery.of(context).size.height -
        mAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: mAppBar,
      body: Column(
        children: <Widget>[
          Totals(
            height: screenSize * .30,
          ),
          Counter(
            height: screenSize * .30,
            windowList: windowList,
          ),
          _BodyWidget(
            height: (screenSize * .40),
            windowList: windowList,
          ),
        ],
      ),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  final double height;
  final List<Window> windowList;

  _BodyWidget({this.height, this.windowList});

  @override
  _BodyWidgetState createState() => _BodyWidgetState(height, windowList);
}

class _BodyWidgetState extends State<_BodyWidget>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  final double mHeight;
  final List<Window> _list;

  _BodyWidgetState(this.mHeight, this._list);

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mHeight,
      child: Column(
        children: [
          // Tabs
          Material(
            color: Colors.blue,
            child: TabBar(
              controller: _controller,
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  child: Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Body
          Flexible(
            fit: FlexFit.tight,
            child: TabBarView(
              controller: _controller,
              children: [
                ResultList(_list),
                TechDetails(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultList extends StatelessWidget {
  final List<Window> items;

  ResultList(this.items);

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? Text('List is empty')
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return WindowListItem(
                name: '${items[index].getName()}',
                countDisplay: items[index].getCount(),
              );
            },
          );
  }
}
