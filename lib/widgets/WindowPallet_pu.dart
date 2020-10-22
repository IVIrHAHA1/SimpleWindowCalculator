import 'package:flutter/material.dart';

class WindowPalletPU extends ModalRoute {
  final Color bgColor;
  double top;
  double bottom;
  double left;
  double right;
  final Widget child;
  WindowPalletPU({
    Key key,
    this.bgColor,
    this.child,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Color get barrierColor => bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

    @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
        if (top == null) this.top = 100;
    if (bottom == null) this.bottom = 20;
    if (left == null) this.left = 20;
    if (right == null) this.right = 20;
    
    return GestureDetector(
      onTap: () {
        // call this method here to hide soft keyboard
        Navigator.of(context).pop();
      },
      child: Material( // This makes sure that text and other content follows the material style
        type: MaterialType.transparency,
        //type: MaterialType.canvas,
        // make sure that the overlay content is not cut off
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: this.bottom,
          left: this.left,
          right: this.right,
          top: this.top),
      child: child,
    );
  }
}
