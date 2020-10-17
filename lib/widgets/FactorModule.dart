import 'package:flutter/material.dart';

class FactorModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _size = 75;
    const double _sizeRatio = 3/4;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _FactorCircle(
          size: _size *_sizeRatio,
          child: Image.asset('assets/images/filthy_factor.png'),
        ),
        _FactorCircle(
          size: _size *_sizeRatio,
          alignment: Alignment.topCenter,
          child: Image.asset('assets/images/hazard_factor.png'),
        ),

        // Window specific counter
        _FactorCircle(
          size: _size,
          child: Text('20'),
        ),

        _FactorCircle(
          size: _size *_sizeRatio,
          alignment: Alignment.topCenter,
          child: Image.asset('assets/images/construction_factor.png'),
        ),
        _FactorCircle(
          size: _size *_sizeRatio,
          child: Image.asset('assets/images/sided_factor.png'),
        ),
      ],
    );
  }
}

class _FactorCircle extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Alignment alignment;
  final Widget child;

  static const double iconRatio = 1/6;

  _FactorCircle(
      {@required this.size,
      @required this.child,
      this.backgroundColor,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor == null ? Colors.white : backgroundColor,
      shape: CircleBorder(
        side: BorderSide(
          color: Colors.blueGrey,
          width: 3,
          style: BorderStyle.solid,
        ),
      ),
      child: Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(size * iconRatio),
        alignment: alignment == null ? Alignment.center : alignment,
        child: this.child,
      ),
    );
  }
}
