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
        buildFactor(
          factorKey: Factors.filthy,
          circle: _FactorCircle(
            size: _size * _sizeRatio,
            image: OManager.factorList[Factors.filthy].getImage(),
            backgroundColor: HexColors.fromHex('#DCA065'),
          ),
        ),

        buildFactor(
          factorKey: Factors.difficult,
          circle: _FactorCircle(
            size: _size * _sizeRatio,
            alignment: Alignment.topCenter,
            image: OManager.factorList[Factors.difficult].getImage(),
            backgroundColor: HexColors.fromHex('#FFEDA5'),
          ),
        ),

        // Window specific counter
        _FactorCircle(
          size: _size,
          image: Text(
            '${Format.format(activeWindow.getCount())}',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),

        buildFactor(
          factorKey: Factors.construction,
          circle: _FactorCircle(
            size: _size * _sizeRatio,
            alignment: Alignment.topCenter,
            image: OManager.factorList[Factors.construction].getImage(),
            backgroundColor: HexColors.fromHex('#FFB9B9'),
          ),
        ),

        buildFactor(
          factorKey: Factors.sided,
          circle: _FactorCircle(
            size: _size * _sizeRatio,
            image: OManager.factorList[Factors.sided].getImage(),
          ),
        ),
      ],
    );
  }

  // Implements behaviour
  Draggable buildFactor({
    @required Factors factorKey,
    @required _FactorCircle circle,
  }) {
    Factor factor = activeWindow.getFactor(factorKey);

    return Draggable<Factor>(
      data: factor,
      feedback: circle.resize(1.1),
      child: InkWell(
        onTap: () {
          incQA
              ? activeWindow.incrementTag(factorKey)
              : activeWindow.decrementTag(factorKey);
        },
        onLongPress: () {
          print('switching modes');
          incQA ? incQA = false : incQA = true;
        },
        child: circle,
      ),
    );
  }
}

// creates factor aesthetics
class _FactorCircle extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Alignment alignment;
  final Widget image;

  static const double iconRatio = 1 / 6;

  _FactorCircle({
    @required this.size,
    @required this.image,
    this.backgroundColor,
    this.alignment,
  });

  _FactorCircle resize(double altSizeRatio) {
    return _FactorCircle(
      size: size * altSizeRatio,
      image: image,
      alignment: alignment,
      backgroundColor: backgroundColor,
    );
  }

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
