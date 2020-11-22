import 'package:SimpleWindowCalculator/Tools/GlobalValues.dart';
import 'package:SimpleWindowCalculator/Tools/HexColors.dart';
import 'package:SimpleWindowCalculator/objects/OManager.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';
import 'package:flutter/material.dart';

enum FactorOptions {
  decrement,
  apply,
  clear,
  edit,
}

class FactorOptionRoute extends ModalRoute {
  @override
  Color get barrierColor => Colors.black.withOpacity(.5);

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  final List<_Option> options = [
    // Decrement
    _Option(
      icon: Icon(Icons.arrow_drop_down_circle),
      title: 'Decrement',
      subtitle: 'Modify quick-action',
      windowFunction: (window, factorKey, optionsController) {
        optionsController(null, FactorOptions.decrement);
      },
    ),

    // Apply Factor
    _Option(
        icon: Icon(Icons.arrow_upward),
        title: 'Apply Factor',
        subtitle: 'Matches factor count to current window count',
        windowFunction: (window, factorKey, optionsController) {
          optionsController(
            () {
              window.getFactor(factorKey).setCount(window.getCount());
            },
            FactorOptions.apply,
          );
        }),

    // Clear Factor
    _Option(
        icon: Icon(Icons.clear),
        title: 'Clear Factor',
        subtitle: 'Clears factor from selected window',
        windowFunction: (window, factorKey, optionsController) {
          optionsController(
            () {
              window.getFactor(factorKey).setCount(0);
            },
            FactorOptions.clear,
          );
        }),

    // Edit Factor
    _Option(
        icon: Icon(Icons.edit),
        title: 'Edit Factor',
        subtitle: 'Edit factor details',
        windowFunction: (window, factorKey, optionsController) {
          optionsController(null, FactorOptions.edit);
        }),
  ];

  final Function optionsController;
  final Window window;
  final Factors factorKey;
  bool incrementingMode;

  FactorOptionRoute(
      {this.optionsController,
      @required this.window,
      @required this.factorKey,
      this.incrementingMode});

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final double horizontalPadding = MediaQuery.of(context).size.width / 8;
    final double verticalPadding = MediaQuery.of(context).size.height / 10;

    final double popUpHeight =
        (verticalPadding * 8) - MediaQuery.of(context).padding.top;

    // if true coin mode is currently set to decrement
    if (!incrementingMode) {
      options[0] = _Option(
        icon: Icon(Icons.arrow_drop_up),
        title: 'Increment',
        subtitle: 'Modify quick-action',
        windowFunction: (window, factorKey, optionsController) {
          optionsController(null, FactorOptions.decrement);
        },
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: true,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(GlobalValues.cornerRadius),
            ),
            margin: EdgeInsets.only(
              bottom: verticalPadding,
              left: horizontalPadding,
              right: horizontalPadding,
              top: verticalPadding,
            ),
            child: Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(GlobalValues.cornerRadius),
                      topRight: Radius.circular(GlobalValues.cornerRadius),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  alignment: Alignment.center,
                  height: popUpHeight * .15,
                  width: double.infinity,
                  child: Text(
                    'Factor Options: ' + _formatFactorKey(factorKey),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),

                // Body
                Container(
                  padding: EdgeInsets.all(GlobalValues.appMargin),
                  height: popUpHeight * .7,
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (ctx, index) {
                      return buildTile(
                        options[index],
                        context,
                      );
                    },
                  ),
                ),

                // Footer
                Container(
                  width: double.infinity,
                  height: popUpHeight * .15,
                  decoration: BoxDecoration(
                    color: HexColors.fromHex('#FBFBFB'),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(GlobalValues.cornerRadius),
                      bottomRight: Radius.circular(GlobalValues.cornerRadius),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildTile(_Option option, BuildContext context) {
    return ListTile(
      leading: option.icon,
      title: Text(
        option.title,
        style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        option.subtitle,
        style: TextStyle(fontSize: 10, fontFamily: 'OpenSans'),
      ),
      onTap: () => option.windowFunction(window, factorKey, optionsController),
    );
  }

  String _formatFactorKey(Factors key) {
    List<String> lines = key.toString().split('.');
    return lines[1];
  }
}

class _Option {
  String title;
  String subtitle;
  Icon icon;
  final Function(Window, Factors, Function) windowFunction;

  _Option({
    this.icon,
    this.title,
    this.subtitle,
    this.windowFunction,
  });
}
