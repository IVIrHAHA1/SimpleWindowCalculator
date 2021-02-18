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
    this.bgColor,
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
  bool get barrierDismissible => true;

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
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildCard(context, title: 'Camera', leading: Icon(Icons.camera)),
              buildCard(
                context,
                title: 'Gallery',
                leading: Icon(Icons.image),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, {String title, Widget leading}) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          color: Theme.of(context).primaryColorLight,
        ),
        height: 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 32,
                child: Theme(
                  data:
                      ThemeData(iconTheme: IconThemeData(color: Colors.white)),
                  child: leading,
                )),
            Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ));
  }
}
