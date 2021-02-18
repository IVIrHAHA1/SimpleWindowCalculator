import 'package:flutter/material.dart';

import 'Animations/CollapseAnimation.dart';

class Tester extends StatefulWidget {
  @override
  _TesterState createState() => _TesterState();
}

class _TesterState extends State<Tester> with TickerProviderStateMixin {
  CollapsingController controller;
  Animation<double> animation;

  bool pressed = false;

  @override
  void initState() {
    controller = CollapsingController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );

    animation = Tween(begin: 1.0, end: 0.0).animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello There'),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 0,
              child: CollapsingAnimation(
                controller: controller,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    border: Border.all(
                      width: 2,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Icon(
                          Icons.imagesearch_roller,
                        ),
                      ),
                      Icon(
                        Icons.image_outlined,
                        size: MediaQuery.of(context).size.width / 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MaterialButton(
              color: Colors.amber,
              child: Text('Better'),
              onPressed: () {
                if (!pressed) {
                  controller.forward();
                } else {
                  controller.reverse();
                }
                pressed = !pressed;
              },
            ),
          ],
        ),
      ),
    );
  }
}
