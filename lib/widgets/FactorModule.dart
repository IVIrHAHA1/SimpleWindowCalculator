import 'package:SimpleWindowCalculator/Tools/HexColors.dart';
import 'package:SimpleWindowCalculator/objects/OneSideTag.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FactorModule extends StatelessWidget {
  Window activeWindow;

  FactorModule(this.activeWindow);

  @override
  Widget build(BuildContext context) {
    double _size = 75;
    const double _sizeRatio = 3 / 4;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _FactorCircle(
          size: _size * _sizeRatio,
          child: Image.asset('assets/images/filthy_factor.png'),
          backgroundColor: HexColors.fromHex('#DCA065'),
        ),
        _FactorCircle(
          size: _size * _sizeRatio,
          alignment: Alignment.topCenter,
          child: Image.asset('assets/images/hazard_factor.png'),
          backgroundColor: HexColors.fromHex('#FFEDA5'),
        ),

        // Window specific counter
        _FactorCircle(
          size: _size,
          child: Text('${activeWindow.getCount()}'),
        ),

        _FactorCircle(
          size: _size * _sizeRatio,
          alignment: Alignment.topCenter,
          child: Image.asset('assets/images/construction_factor.png'),
          backgroundColor: HexColors.fromHex('#FFB9B9'),
        ),
        GestureDetector(
          onTap: () => print('hello'),
          child: _FactorCircle(
            size: _size * _sizeRatio,
            child: Image.asset('assets/images/sided_factor.png'),
          ),
        ),
      ],
    );
  }
}

class _FactorCircle extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Alignment alignment;
  final Widget child;

  static const double iconRatio = 1 / 6;

  _FactorCircle(
      {@required this.size,
      @required this.child,
      this.backgroundColor,
      this.alignment});

  @override
  __FactorCircleState createState() => __FactorCircleState();
}

class __FactorCircleState extends State<_FactorCircle> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.backgroundColor == null
          ? Colors.white
          : widget.backgroundColor,
      shape: CircleBorder(
        side: BorderSide(
          color: Colors.blueGrey,
          width: 3,
          style: BorderStyle.solid,
        ),
      ),
      child: Container(
        height: widget.size,
        width: widget.size,
        padding: EdgeInsets.all(widget.size * _FactorCircle.iconRatio),
        alignment:
            widget.alignment == null ? Alignment.center : widget.alignment,
        child: this.widget.child,
      ),
    );
  }
}
