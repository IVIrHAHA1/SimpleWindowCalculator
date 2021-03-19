import 'package:flutter/material.dart';
import 'dart:math' as math;

enum Direction {
  clockwise,
  counterClockwise,
}

class SpinnerTransition extends StatefulWidget {
  final Widget child1;

  /// When the controller reaches its half way point, the second child becomes "visible".
  final Widget child2;

  /// The direction the transition will spin
  final Direction direction;
  final Duration duration;
  final Duration reverseDuration;

  final Function onPressed;
  final AnimationController controller;

  /// When spinner is done animating, will return true if [child2] is currently in view.
  // final Function(bool spun) onFinished; // TODO: Revisit and see if this is needed

  SpinnerTransition({
    this.child1,
    this.child2,
    this.controller,
    this.onPressed,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
    this.direction = Direction.clockwise,
  });

  @override
  _SpinnerTransitionState createState() => _SpinnerTransitionState();
}

class _SpinnerTransitionState extends State<SpinnerTransition>
    with SingleTickerProviderStateMixin {
  Animation<double> scaleTween1;
  Animation<double> cwSpin;
  Animation<double> opacityTween1;
  Animation<double> scaleTween2;
  Animation<double> opacityTween2;

  AnimationController _controller;

  /// First phase intervals
  static const double _firstPhaseStart = 0, _firstPhaseEnd = .5;

  /// Second phase intervals
  static const double _secondPhaseStart = _firstPhaseEnd, _secondPhaseEnd = 1;

  @override
  void initState() {
    _controller = widget.controller ??
        AnimationController(
          vsync: this,
          duration: widget.duration,
          reverseDuration: widget.reverseDuration ?? widget.duration,
        );

    /// Full 180 rotation tween
    cwSpin = Tween<double>(
      begin: 0,
      end: widget.direction == Direction.clockwise ? 180 : -180,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(_firstPhaseStart, _secondPhaseEnd,
            curve: Curves.easeInOut),
      ),
    );

    /// First Phase Tweens
    scaleTween1 = Tween<double>(begin: 1.0, end: 0.33).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(_firstPhaseStart, _firstPhaseEnd),
      ),
    );

    opacityTween1 = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        reverseCurve: Interval(
          _firstPhaseStart,
          _firstPhaseEnd,
          curve: Curves.easeOut,
        ),
        curve: Interval(
          _firstPhaseStart,
          _firstPhaseEnd,
          curve: Curves.easeIn,
        ),
      ),
    );

    // Second Phase Tweens
    opacityTween2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        reverseCurve: Interval(
          _firstPhaseStart,
          _firstPhaseEnd,
          curve: Curves.easeOut,
        ),
        curve: Interval(
          _secondPhaseStart,
          _secondPhaseEnd,
          curve: Curves.easeIn,
        ),
      ),
    );

    scaleTween2 = Tween<double>(begin: 0.33, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(_secondPhaseStart, _secondPhaseEnd),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) {
        return Transform.rotate(
          angle: (cwSpin.value) * (math.pi / 180),
          child: _controller.value < .5 ? _firstChild() : _secondChild(),
        );
      },
    );
  }

  Widget _firstChild() {
    return InkWell(
      onTap: () {
        _controller.forward();
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: scaleTween1,
        child: Opacity(
          opacity: opacityTween1.value,
          child: widget.child1,
        ),
      ),
    );
  }

  Widget _secondChild() {
    return InkWell(
      onTap: () {
        _controller.reverse();
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: scaleTween2,
        child: Opacity(
          opacity: opacityTween2.value,
          child: Transform.rotate(
            angle: math.pi,
            child: widget.child2,
          ),
        ),
      ),
    );
  }
}
