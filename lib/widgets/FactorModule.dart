import 'package:SimpleWindowCalculator/objects/OManager.dart';

import '../objects/Factor.dart';

import '../Tools/Format.dart';
import '../Tools/HexColors.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FactorModule extends StatelessWidget {
  Window activeWindow;
  bool incQA = true;

  FactorModule(this.activeWindow);

  @override
  Widget build(BuildContext context) {
    double _size = MediaQuery.of(context).size.width / 6;
    const double _sizeRatio = 3 / 4;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _FactorCircle(
          size: _size * _sizeRatio,
          image: Image.asset('assets/images/filthy_factor.png'),
          backgroundColor: HexColors.fromHex('#DCA065'),
        ),
        _FactorCircle(
          size: _size * _sizeRatio,
          alignment: Alignment.topCenter,
          image: Image.asset('assets/images/hazard_factor.png'),
          backgroundColor: HexColors.fromHex('#FFEDA5'),
        ),

        // Window specific counter
        _FactorCircle(
          size: _size,
          image: Text(
            '${Format.format(activeWindow.getCount())}',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),

        _FactorCircle(
          size: _size * _sizeRatio,
          alignment: Alignment.topCenter,
          image: Image.asset('assets/images/construction_factor.png'),
          backgroundColor: HexColors.fromHex('#FFB9B9'),
        ),

        Draggable(
          feedback: buildFactorCircle(
            size: _size * _sizeRatio * .75,
            factor: OManager.factorList[Factors.sided],
          ),
          child: InkWell(
            onTap: () {
              incQA
                  ? activeWindow.incrementTag(Factors.sided)
                  : activeWindow.decrementTag(Factors.sided);
            },
            onLongPress: () {
              print('switching modes');
              incQA ? incQA = false : incQA = true;
            },
            child: buildFactorCircle(
              size: _size * _sizeRatio,
              factor: OManager.factorList[Factors.sided],
            ),
          ),
        ),
      ],
    );
  }

  _FactorCircle buildFactorCircle({double size, Factor factor}) {
    return _FactorCircle(
      size: size,
      image: factor.getImage(),
    );
  }
}

// creates factor aesthetics
class _FactorCircle extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Alignment alignment;
  final Widget image;
  final Factor factor;

  static const double iconRatio = 1 / 6;

  _FactorCircle({
    @required this.size,
    @required this.image,
    this.backgroundColor,
    this.alignment,
    this.factor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor == null ? Colors.white : backgroundColor,
      shape: CircleBorder(
        side: BorderSide(
          color: Colors.blueGrey,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(size * _FactorCircle.iconRatio),
        alignment: alignment == null ? Alignment.center : alignment,
        child: this.image,
      ),
    );
  }
}
