import '../Tools/Format.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

class OverviewModule extends StatelessWidget {
  final List<Window> windowList;

  OverviewModule({this.windowList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return WindowCard(windowList.elementAt(index));
        },
        itemCount: windowList.length,
      ),
    );
  }
}

class WindowCard extends StatelessWidget {
  final Window window;

  WindowCard(this.window);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Tile Header
              Row(
                children: [
                  Text(
                    '${window.getName()}',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(fit: FlexFit.tight, child: Container()),
                  Container(
                    width: 75,
                    height: 40,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blue,
                      child: Center(child: Text('${Format.format(window.getCount())}')),
                    ),
                  ),
                ],
              ),

              // Tile Body
              // TODO: implement body when factors is implemented
            ],
          ),
        ),
      ),
    );
  }
}
