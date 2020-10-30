import 'package:SimpleWindowCalculator/objects/OManager.dart';

import '../objects/Factor.dart';

import '../Tools/Format.dart';
import '../Tools/HexColors.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FactorModule extends StatelessWidget {
  Window activeWindow;
  bool modeOnIncrement = true;

  FactorModule(this.activeWindow);

  @override
  Widget build(BuildContext context) {
    double _size = MediaQuery.of(context).size.width / 6;
    const double _sizeRatio = 3 / 4;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Filthy Factor
        buildFactor(
          factorKey: Factors.filthy,
          circle: _FactorCircle(
            size: _size * _sizeRatio,
            image: OManager.factorList[Factors.filthy].getImage(),
            backgroundColor: HexColors.fromHex('#DCA065'),
          ),
        ),

        // Difficult Factor
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

        // Construction Factor
        buildFactor(
          factorKey: Factors.construction,
          circle: _FactorCircle(
            size: _size * _sizeRatio,
            alignment: Alignment.topCenter,
            image: OManager.factorList[Factors.construction].getImage(),
            backgroundColor: HexColors.fromHex('#FFB9B9'),
          ),
        ),

        // Sided Factor
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
      childWhenDragging: circle.passify(),
      child: InkWell(
        onTap: () {
          modeOnIncrement
              ? activeWindow.incrementTag(factorKey)
              : activeWindow.decrementTag(factorKey);
        },
        onLongPress: () {
          print('switching modes');
          modeOnIncrement ? modeOnIncrement = false : modeOnIncrement = true;
        },
        child: circle,
      ),
    );
  }
}

class _FactorCircle extends StatelessWidget {
  final double size;
  final Color backgroundColor, borderColor;
  final Alignment alignment;
  final Widget image;

  final bool activated;

  static const double iconRatio = 1 / 6;

  _FactorCircle({
    @required this.size,
    @required this.image,
    this.backgroundColor,
    this.alignment,
    this.borderColor,
    this.activated = false,
  });

  _FactorCircle resize(double altSizeRatio) {
    return _FactorCircle(
      size: size * altSizeRatio,
      image: image,
      alignment: alignment,
      backgroundColor: backgroundColor,
    );
  }

  passify() {
    return _FactorCircle(
      size: size,
      image: image,
      alignment: alignment,
      backgroundColor: backgroundColor,
      borderColor: Colors.blueGrey,
      activated: true,
    );
  }

  Color factorCircleBKG() {
    if (activated) {
      return Colors.grey;
    } else {
      return backgroundColor == null ? Colors.white : backgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: factorCircleBKG(),
      shape: CircleBorder(
        side: BorderSide(
          color: borderColor == null
              ? Theme.of(context).primaryColor
              : borderColor,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: activated
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: buildIMGContainer(),
            )
          : buildIMGContainer(),
    );
  }

  Container buildIMGContainer() {
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(size * _FactorCircle.iconRatio),
      alignment: alignment == null ? Alignment.center : alignment,
      child: this.image,
    );
  }
}
