import '../Tools/Format.dart';

import '../objects/Window.dart';
import 'package:flutter/material.dart';

class WindowPallet extends StatelessWidget {
  final List<Window> windowList;

  WindowPallet(this.windowList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text('windows in use'),
          Divider(
            thickness: 2,
            height: 4,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: windowList.map((e) {
                  return e.getPicture() != null
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: e.getPicture(),
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                ),
                                Positioned(
                                  child: Text('${Format.format(e.getCount())}'),
                                  top: 10,
                                  right: 10,
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              height: 2,
                              endIndent: 8,
                              indent: 8,
                            )
                          ],
                        )
                      : Icon(Icons.explicit);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
