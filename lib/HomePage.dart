import 'package:SimpleWindowCalculator/Animations/SizingTween.dart';
import 'package:SimpleWindowCalculator/Tools/DatabaseProvider.dart';
import 'package:SimpleWindowCalculator/Tools/Calculator.dart';
import 'package:SimpleWindowCalculator/GlobalValues.dart';
import 'package:SimpleWindowCalculator/Util/ItemsManager.dart';
import 'package:SimpleWindowCalculator/widgets/ModalContent.dart';

import './objects/OManager.dart';
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
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: GlobalValues.animDuration ~/ 1.1),
      reverseDuration: Duration(milliseconds: GlobalValues.animDuration ~/ 1.1),
    );
    Calculator.instance.addListener(() {
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
      // block begin:
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: mAppBar,
        // block end:

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
        children: <Widget>[
          // Results
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ResultsModule(
              height: availableScreen,
              triggerExpandAnim: triggerExpandAnim,
              valueHolder: ResultsValueHolder(
                priceTotal: Calculator.instance.projectPrice,
                timeTotal: Calculator.instance.projectDuration,
                countTotal: Calculator.instance.projectCount,
              ),
            ),
          ),

          // Empty space seperator
          Flexible(
            fit: FlexFit.tight,
            child: Container(),
          ),

          // Counter Module
          SizingTween(
            controller: _controller,
            size: availableScreen * .5,
            child: WindowCounter(
              height: availableScreen * .5,
              window: manager.activeItem,
              selectNewWindowFun: selectNewWindow,
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
  _addNewWindow(Window newWindow) {
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
    Window newDefault = await DatabaseProvider.instance.queryWindow(
      OManager.getDefaultWindow().name,
    );

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
          addWindow: _addNewWindow,
        );
      },
    );
  }
}
