import 'package:TheWindowCalculator/Tools/ImageLoader.dart';
import 'package:flutter/material.dart';

class OptionsModal extends ModalRoute {
  final Function(ImagerMechanism) optionListener;
  OptionsModal({
    Key key,
    @required this.optionListener,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

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
              buildCard(
                context,
                title: 'Camera',
                leading: Icon(Icons.camera),
                method: ImagerMechanism.camera,
              ),
              buildCard(
                context,
                title: 'Gallery',
                leading: Icon(Icons.image),
                method: ImagerMechanism.gallery,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(
    BuildContext context, {
    String title,
    Widget leading,
    ImagerMechanism method,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        optionListener(method);
      },
      child: Container(
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
                    data: ThemeData(
                        iconTheme: IconThemeData(color: Colors.white)),
                    child: leading,
                  )),
              Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          )),
    );
  }
}
