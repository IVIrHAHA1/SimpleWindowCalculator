import 'package:flutter/material.dart';

class SizingTween extends StatefulWidget {
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
  Animation _animation;

  @override
  void initState() {
    _animation =
        Tween<double>(begin: widget.size, end: 0).animate(widget.controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      child: widget.child,
      builder: (_, Widget child) {
        return Container(
          height: _animation.value,
          child: child,
        );
      },
    );
  }
}
