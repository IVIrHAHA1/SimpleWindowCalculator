import 'package:flutter/material.dart';

class PopUpTextField extends StatefulWidget {
  final String hint;
  final TextStyle hintStyle;
  final bool Function(String) validator;
  final TextInputType textInputType;
  final Widget icon;
  final Color fillColor;
  final Duration duration;
  final AnimationController controller;

  PopUpTextField({
    this.hint,
    this.hintStyle,
    this.validator,
    this.textInputType,
    this.fillColor = Colors.white,
    this.icon,
    this.controller,
    this.duration,
  });

  @override
  _PopUpTextFieldState createState() => _PopUpTextFieldState();
}

class _PopUpTextFieldState extends State<PopUpTextField>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Tween<double> shadowTween;

  bool expanded;

  Animation rise;
  Animation iconOpacity;
  Animation textOpacity;
  Animation expand;

  _PopUpTextFieldState() {
    this.expanded = false;
  }

  @override
  void initState() {
    controller = widget.controller ??
        AnimationController(
          vsync: this,
          duration: widget.duration,
          reverseDuration: widget.duration,
        );

    // Rising Animation
    rise = Tween<double>(begin: 0, end: riseHeightpx).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(raiseInt_s, raiseInt_e, curve: Curves.decelerate),
      ),
    );

    iconOpacity = Tween<double>(begin: .25, end: .75).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(raiseInt_s, raiseInt_e),
      ),
    );

    // Expansion Animation
    textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(expInt_s, expInt_e),
      ),
    );

    expand = Tween<double>(begin: 50, end: 300).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          expInt_s,
          expInt_e,
          curve: Curves.decelerate,
        ),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  static const double expInt_s = .5, expInt_e = 1;
  static const double raiseInt_s = 0, raiseInt_e = .25;
  static const double riseHeightpx = 5.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (ctx, child) {
        return _firstChild();
      },
    );
  }

  Widget _firstChild() {
    return GestureDetector(
      onTap: () {
        expanded ? controller.forward() : controller.reverse();
        setState(() {
          expanded = !expanded;
        });
      },
      child: Card(
        elevation: rise.value,
        color: widget.fillColor,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(width: 2, color: Colors.black12),
        ),
        child: Container(
          width: expand.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutBuilder(builder: (ctx, contraints) {
                num size = contraints.maxHeight - 10;
                return SizedBox(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: widget.icon,
                  ),
                  height: size - riseHeightpx,
                  width: size - riseHeightpx,
                );
              }),
              Visibility(
                visible: textOpacity.value > 0,
                child: Flexible(
                  child: Opacity(
                    opacity: textOpacity.value,
                    child: TextField(
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                        hintText: widget.hint,
                        hintStyle: widget.hintStyle,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
