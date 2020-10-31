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
        FactorCoin(
          size: _size * _sizeRatio,
          factorKey: Factors.filthy,
          window: activeWindow,
          backgroundColor: HexColors.fromHex('#DCA065'),
        ),

        // Difficult Factor
        FactorCoin(
          factorKey: Factors.difficult,
          window: activeWindow,
          size: _size * _sizeRatio,
          alignment: Alignment.topCenter,
          backgroundColor: HexColors.fromHex('#FFEDA5'),
        ),

        // Window specific counter
        FactorCoin(
          size: _size,
          child: Text(
            '${Format.format(activeWindow.getCount())}',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),

        // Construction Factor
        FactorCoin(
          factorKey: Factors.construction,
          window: activeWindow,
          size: _size * _sizeRatio,
          alignment: Alignment.topCenter,
          backgroundColor: HexColors.fromHex('#FFB9B9'),
        ),

        // Sided Factor
        FactorCoin(
          factorKey: Factors.sided,
          window: activeWindow,
          size: _size * _sizeRatio,
        ),
      ],
    );
  }
}
