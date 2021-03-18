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
  final BorderSide borderSide;
  final double iconHeightFactor, iconWidthFactor;

  static const double iconSizeFactor = .75;

  PopUpTextField({
    this.hint,
    this.hintStyle,
    this.validator,
    this.textInputType,
    this.fillColor = Colors.white,
    this.icon,
    this.controller,
    this.duration,
    this.iconHeightFactor = iconSizeFactor,
    this.iconWidthFactor = iconSizeFactor,
    this.borderSide = BorderSide.none,
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

  double _maxHeight;
  double _maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      this._maxHeight = constraints.maxHeight ?? 50;
      this._maxWidth = constraints.maxWidth ?? 200;

      return AnimatedBuilder(
        animation: controller,
        builder: (ctx, child) {
          expand = Tween<double>(begin: _maxHeight, end: _maxWidth).animate(
            CurvedAnimation(
              parent: controller,
              curve: Interval(
                expInt_s,
                expInt_e,
                curve: Curves.decelerate,
              ),
            ),
          );

          return _buildChild();
        },
      );
    });
  }

  Widget _buildChild() {
    return GestureDetector(
      onTap: () {
        expanded ? controller.forward() : controller.reverse();
        expanded = !expanded;
      },
      child: Card(
        elevation: rise.value,
        color: widget.fillColor,
        shadowColor: Colors.black,
        shape: expand.value == _maxHeight
            ? CircleBorder(
                side: widget.borderSide,
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: widget.borderSide,
              ),
        child: Container(
          height: _maxHeight,
          width: expand.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Image
              SizedBox(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: widget.icon,
                ),
                height: (_maxHeight * widget.iconHeightFactor) - riseHeightpx + rise.value,
                width: (_maxHeight * widget.iconWidthFactor) - riseHeightpx + rise.value,
              ),
              // TextField
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
