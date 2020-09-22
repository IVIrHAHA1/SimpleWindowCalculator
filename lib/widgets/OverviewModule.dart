import 'package:SimpleWindowCalculator/widgets/TechDetails.dart';
import 'package:flutter/material.dart';
import 'WindowTile.dart';
import '../objects/Window.dart';

class OverviewModule extends StatefulWidget {
  final double height;
  final List<Window> windowList;

  OverviewModule({this.height, this.windowList});

  @override
  _OverviewModuleState createState() => _OverviewModuleState(height, windowList);
}

class _OverviewModuleState extends State<OverviewModule>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  final double mHeight;
  final List<Window> _list;

  _OverviewModuleState(this.mHeight, this._list);

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
              return WindowTile(
                name: '${items[index].getName()}',
                countDisplay: items[index].getCount(),
              );
            },
          );
  }
}
