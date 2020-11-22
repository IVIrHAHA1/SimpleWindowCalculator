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
      icon: Icon(
        Icons.remove_circle_outline,
        color: HexColors.fromHex('#2F3037'),
      ),
      title: 'Decrement',
      //subtitle: 'Modify quick-action',
      windowFunction: (window, factorKey, optionsController) {
        optionsController(null, FactorOptions.decrement);
      },
    ),

    // Apply Factor
    _Option(
        icon: Icon(
          Icons.check,
          color: HexColors.fromHex('#2F3037'),
        ),
        title: 'Apply Factor',
        //subtitle: 'Matches factor count to current window count',
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
        icon: Icon(
          Icons.clear,
          color: HexColors.fromHex('#2F3037'),
        ),
        title: 'Clear Factor',
        //subtitle: 'Clears factor from selected window',
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
        icon: Icon(
          Icons.edit,
          color: HexColors.fromHex('#2F3037'),
        ),
        title: 'Edit Factor',
        subtitle: '(feature coming soon)',
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
    final double horizontalPadding = MediaQuery.of(context).size.width * .05;
    final double verticalPadding = MediaQuery.of(context).size.height / 16;

    final double popUpHeight =
        (verticalPadding * 14) - MediaQuery.of(context).padding.top;

    final double popUpWidth = horizontalPadding * 6;

    // if true coin mode is currently set to decrement
    if (!incrementingMode) {
      options[0] = _Option(
        icon: Icon(
          Icons.add_circle_outline,
          color: HexColors.fromHex('#2F3037'),
        ),
        title: 'Increment',
        subtitle: 'Modify quick-action',
        windowFunction: (window, factorKey, optionsController) {
          optionsController(null, FactorOptions.decrement);
        },
      );
    }

    return Material(
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
                alignment: Alignment.center,
                height: popUpHeight * .7,
                child: Container(
                  height: popUpHeight * .6,
                  color: Colors.transparent,
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
              ),

              // Footer
              Container(
                width: double.infinity,
                height: popUpHeight * .15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HexColors.fromHex('#FBFBFB'),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(GlobalValues.cornerRadius),
                    bottomRight: Radius.circular(GlobalValues.cornerRadius),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Card(
                    elevation: 4,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: popUpHeight * .08,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text(
                        'cancel',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                ),
              )
            ],
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
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          color: HexColors.fromHex('#2F3037'),
        ),
      ),
      subtitle: option.subtitle != null
          ? Text(
              option.subtitle,
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: HexColors.fromHex('#2F3037'),
                fontSize: 12,
              ),
            )
          : Text(''),
      onTap: () => option.windowFunction(window, factorKey, optionsController),
    );
  }

  String _formatFactorKey(Factors key) {
    List<String> lines = key.toString().split('.');
    return '${lines[1][0].toUpperCase()}${lines[1].substring(1)}';
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
