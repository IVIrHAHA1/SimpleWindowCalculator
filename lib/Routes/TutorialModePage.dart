import 'package:flutter/material.dart';
import 'package:the_window_calculator/HomePage.dart';
import 'package:the_window_calculator/Pages/ModalContent.dart';

class TutorialOverlay extends StatefulWidget {
  @override
  _TutorialOverlayState createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  @override
  Widget build(BuildContext context) {
    print('TUTORIAL MODE STARTED');
    return Scaffold(
      body: Stack(
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.amber.withOpacity(.5),
            ),
            child: MyHomePage(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height / 2,
            child: Container(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Results Module',
                      style: Theme.of(context).textTheme.headline3.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    Text(
                      'This is where your expected price and time will display',
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                    Card(
                      elevation: 4,
                      color: true != null
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {},
                        splashColor: Theme.of(context).primaryColorLight,
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text(
                            'Ok',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 2),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
