import 'package:SimpleWindowCalculator/Tools/GlobalValues.dart';
import 'package:SimpleWindowCalculator/objects/OManager.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';
import 'package:flutter/material.dart';

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
      function: (window, factorKey) {
        print(window.getName());
      },
    ),

    // Apply Factor
    _Option(
      icon: Icon(Icons.arrow_upward),
      title: 'Apply Factor',
      subtitle: 'Matches factor count to current window count',
    ),
  ];

  double top, bottom, left, right;
  final Window window;
  final Factors factorKey;

  FactorOptionRoute({
    @required this.window,
    @required this.factorKey,
    this.top = 50,
    this.bottom = 50,
    this.right = 50,
    this.left = 50,
  });

  void _changeMode() {
    print('changing mode');
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final double horizontalPadding = MediaQuery.of(context).size.width / 8;
    final double verticalPadding = MediaQuery.of(context).size.height / 10;

    final double popUpHeight =
        (verticalPadding * 8) - MediaQuery.of(context).padding.top;

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
                  height: popUpHeight * .75,
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (ctx, index) {
                      return buildTile(
                        options[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildTile(_Option option) {
    return ListTile(
      leading: option.icon,
      title: Text(option.title),
      subtitle: Text(option.subtitle),
      onTap: () => option.function(window, factorKey),
    );
  }

  String _formatFactorKey(Factors key) {
    List<String> lines = key.toString().split('.');
    return lines[1];
  }
}

class _Option {
  final String title;
  final String subtitle;
  final Icon icon;
  final Function(Window, Factors) function;

  _Option({
    this.icon,
    this.title,
    this.subtitle,
    this.function,
  });
}
