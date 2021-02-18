import 'package:flutter/material.dart';

class SizingTween extends StatefulWidget {
  // beginning size
  final double size;
  final Widget child;
  final AnimationController controller;

  SizingTween({
    this.size,
    this.child,
    this.controller,
  });

  @override
  _SizingTweenState createState() => _SizingTweenState();
}

class _SizingTweenState extends State<SizingTween> {
  Animation _animation, _animation2;

  @override
  void initState() {
    _animation =
        Tween<double>(begin: 1, end: 0).animate(widget.controller);

    _animation2 = Tween<double>(begin: 1, end: 0).animate(widget.controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      child: widget.child,
      builder: (_, Widget child) {
        return Container(
          height: _animation.value * widget.size,
          child: Opacity(
            opacity: _animation2.value,
            child: child,
          ),
        );
      },
    );
  }
}
