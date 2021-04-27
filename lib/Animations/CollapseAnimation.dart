import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class CollapsingAnimation extends StatefulWidget {
  final CollapsingController controller;
  final Widget child;

  CollapsingAnimation({
    this.controller,
    this.child,
  });

  @override
  _CollapsingAnimationState createState() => _CollapsingAnimationState();
}

class _CollapsingAnimationState extends State<CollapsingAnimation> {
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.controller,
      axis: Axis.vertical,
      child: Center(child: widget.child),
    );
  }
}

class CollapsingController extends AnimationController {
  final TickerProvider vsync;
  final Duration duration;
  final Duration reverseDuration;

  CollapsingController({
    this.vsync,
    this.duration,
    this.reverseDuration,
  }) : super(
            vsync: vsync, duration: duration, reverseDuration: reverseDuration);
}
