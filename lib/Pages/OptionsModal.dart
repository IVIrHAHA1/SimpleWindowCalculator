import 'package:flutter/material.dart';

class OptionsModal extends ModalRoute {
  final Color bgColor;
  double top;
  double bottom;
  double left;
  double right;
  final Widget child;
  OptionsModal({
    Key key,
    this.bgColor = Colors.white,
    this.child,
    this.top = 100,
    this.bottom = 20,
    this.left = 20,
    this.right = 20,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Color get barrierColor =>
      bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: true,
        child: Container(
          child: Column(
            children: [
              Text('Choose Camera'),
              Text('Choose Gallery'),
            ],
          ),
        ),
      ),
    );
  }
}
