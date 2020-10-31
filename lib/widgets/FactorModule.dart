import '../objects/OManager.dart';
import './FactorCoin.dart';
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
          circle: FactorCoin(
            size: _size * _sizeRatio,
            factor: OManager.factorList[Factors.filthy],
            backgroundColor: HexColors.fromHex('#DCA065'),
          ),
        ),

        // Difficult Factor
        buildFactor(
          factorKey: Factors.difficult,
          circle: FactorCoin(
            size: _size * _sizeRatio,
            alignment: Alignment.topCenter,
            factor: OManager.factorList[Factors.difficult],
            backgroundColor: HexColors.fromHex('#FFEDA5'),
          ),
        ),

        // Window specific counter
        FactorCoin(
          size: _size,
          factor: null,
          child: Text(
            '${Format.format(activeWindow.getCount())}',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),

        // Construction Factor
        buildFactor(
          factorKey: Factors.construction,
          circle: FactorCoin(
            size: _size * _sizeRatio,
            alignment: Alignment.topCenter,
            factor: OManager.factorList[Factors.construction],
            backgroundColor: HexColors.fromHex('#FFB9B9'),
          ),
        ),

        // Sided Factor
        buildFactor(
          factorKey: Factors.sided,
          circle: FactorCoin(
            size: _size * _sizeRatio,
            factor: OManager.factorList[Factors.sided],
          ),
        ),
      ],
    );
  }

  // Implements behaviour
  Draggable buildFactor({
    @required Factors factorKey,
    @required FactorCoin circle,
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
