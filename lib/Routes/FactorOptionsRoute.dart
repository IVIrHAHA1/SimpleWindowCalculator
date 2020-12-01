import '../Tools/GlobalValues.dart';
import '../Tools/HexColors.dart';
import '../objects/OManager.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

/*
 * For use in FactorCoin.dart to control
 * different States of the app.
 */
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

  // List of options, one also in build method.
  final List<_Option> options = [
    // Decrement
    _Option(
      icon: Icon(
        Icons.remove_circle_outline,
        color: HexColors.fromHex('#2F3037'),
      ),
      title: 'Decrement',
      subtitle: 'set quick-action',
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
        subtitle: 'match window count',
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
        subtitle: 'clear from window',
        windowFunction: (window, factorKey, optionsController) {
          optionsController(
            () {
              window.getFactor(factorKey).setCount(0);
            },
            FactorOptions.clear,
          );
        }),

    _Option(
        icon: Icon(
          Icons.check_circle_outline,
          color: HexColors.fromHex('#2F3037'),
        ),
        title: 'Apply To Project',
        subtitle: '(feature coming soon)',
        windowFunction: (window, factorKey, optionsController) {
          optionsController(
            () {
              //window.getFactor(factorKey).setCount(0);
            },
            FactorOptions.edit,
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

  // Callback to FactorCoin, so setState methods can be utillized.
  final Function optionsController;
  final Window window;
  final Factors factorKey;
  bool incrementingMode; // Need to swap incrementing and decrementing options.

  static const paddingRatio = .2;

  FactorOptionRoute(
      {this.optionsController,
      @required this.window,
      @required this.factorKey,
      this.incrementingMode});

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final double horizontalPadding = MediaQuery.of(context).size.width / 16;
    final double verticalPadding = MediaQuery.of(context).size.height / 16;

    final double popUpHeight =
        (verticalPadding * 14) - MediaQuery.of(context).padding.top;

    final double popUpWidth = (horizontalPadding * 14);

    // if true coin mode is currently set to decrement
    //Incrementing option
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
              buildHeader(context, popUpHeight, popUpWidth),

              // Body
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: popUpWidth * paddingRatio),
                height: popUpHeight * .7,
                child: Container(
                  height: popUpHeight * .7,
                  width: popUpWidth * .75,
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

              buildFooter(popUpHeight, context)
            ],
          ),
        ),
      ),
    );
  }

  /*
   *  Builds the title and header bar. 
   */
  Container buildHeader(BuildContext context, double height, double width) {
    return Container(
      padding: EdgeInsets.only(left: width * paddingRatio),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(GlobalValues.cornerRadius),
          topRight: Radius.circular(GlobalValues.cornerRadius),
        ),
        color: Theme.of(context).primaryColor,
      ),
      alignment: Alignment.centerLeft,
      height: height * .15,
      width: double.infinity,
      child: Text(
        'Factor Options: ' + _formatFactorKey(factorKey),
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  /*
   *  Builds the cancel button and off white backdrop. 
   */
  Container buildFooter(double popUpHeight, BuildContext context) {
    return Container(
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
    );
  }

  /*
   *  Builds option tile 
   */
  Widget buildTile(_Option option, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 0),
      leading: option.icon,
      title: Text(
        option.title,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          color: HexColors.fromHex('#2F3037'),
        ),
      ),
      subtitle: option.subtitle != null
          ? Opacity(
              opacity: .5,
              child: Text(
                option.subtitle,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: HexColors.fromHex('#2F3037'),
                  fontSize: 12,
                ),
              ),
            )
          : Text(''),
      onTap: () => option.windowFunction(window, factorKey, optionsController),
    );
  }

  /*
   *  Derives the name of the factor coin from Factors enum.
   */
  String _formatFactorKey(Factors key) {
    List<String> lines = key.toString().split('.');
    // Capatalize the first letter of the name.
    return '${lines[1][0].toUpperCase()}${lines[1].substring(1)}';
  }
}

/*
 * Option object. This allows for various option to be quickly implemented. 
 */
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
