import 'package:flutter/material.dart';

class SizingTween extends StatefulWidget {
  final double size;
  final Widget child;

  SizingTween({
    this.size,
    this.child,
  });

  @override
  _SizingTweenState createState() => _SizingTweenState();
}

class _SizingTweenState extends State<SizingTween>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: widget.size, end: 0).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (_, Widget child) {
        return GestureDetector(
          onTap: () {
            _controller.forward();
          },
          child: Container(
            height: _animation.value,
            child: child,
          ),
        );
      },
    );
  }
}
