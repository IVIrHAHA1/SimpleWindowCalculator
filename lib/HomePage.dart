import 'package:TheWindowCalculator/Tools/DatabaseProvider.dart';
import 'package:TheWindowCalculator/Tools/Calculator.dart';
import 'package:TheWindowCalculator/GlobalValues.dart';
import 'package:TheWindowCalculator/Util/ItemsManager.dart';
import 'package:TheWindowCalculator/Pages/ModalContent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './widgets/WindowCounter.dart';

import 'widgets/ResultsModule.dart';
import './objects/Window.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State with SingleTickerProviderStateMixin {
  ItemsManager manager;

  _MyHomePage() {
    this.manager = ItemsManager.instance;
    Calculator.instance.projectItems = manager.items;
  }

  AnimationController _controller;
  Animation opacityAnim;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: GlobalValues.animDuration ~/ 1.1),
      reverseDuration: Duration(milliseconds: GlobalValues.animDuration ~/ 1.1),
    );

    opacityAnim = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    Calculator.instance.addListener(() {
      setState(() {});
    });
    manager.addListener(() {
      Calculator.instance.projectItems = ItemsManager.instance.items;

      setState(() {});
    });
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
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: mAppBar,

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Results
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: ResultsModule(
              height: availableScreen - 8.0,
              triggerExpandAnim: triggerExpandAnim,
              internalController: _controller,
              valueHolder: ResultsValueHolder(
                priceTotal: Calculator.instance.projectPrice,
                timeTotal: Calculator.instance.projectDuration,
                countTotal: Calculator.instance.projectCount,
              ),
            ),
          ),

          // Counter Module
          Flexible(
            child: FadeTransition(
              opacity: opacityAnim,
              child: WindowCounter(
                height: availableScreen * .5,
                window: manager.activeItem,
                selectNewWindowFun: selectNewWindow,
              ),
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
  _activateNewWindow(Window newWindow) {
    if ((manager.activeItem as Window).quantity <= 0) {
      manager.discardActiveItem();
    }

    // Update Counter to new window
    setState(() {
      manager.activeItem = newWindow;
    });

    Navigator.of(context).pop();
  }

  _clearProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Window newDefault = await DatabaseProvider.instance
        .queryWindow(prefs.getString(DEFAULT_WINDOW_KEY));

    manager.reset(setActiveItem: newDefault);
    Calculator.instance.update();
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
          addWindow: _activateNewWindow,
        );
      },
    );
  }
}
