import '../objects/OManager.dart';
import './FactorCoin.dart';
import '../Tools/Format.dart';
import '../Tools/HexColors.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

class FactorModule extends StatelessWidget {
  final Window activeWindow;
  final Function updateTotalFun;

  FactorModule(this.activeWindow, this.updateTotalFun);

  @override
  Widget build(BuildContext context) {
    double _size = MediaQuery.of(context).size.width / 6.75;
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
          updateTotal: updateTotalFun,
        ),

        // Difficult Factor
        FactorCoin(
          factorKey: Factors.difficult,
          window: activeWindow,
          size: _size * _sizeRatio,
          alignment: Alignment.topCenter,
          backgroundColor: HexColors.fromHex('#FFEDA5'),
          updateTotal: updateTotalFun,
        ),

        // Window specific counter
        FactorCoin(
          size: _size,
          child: Text(
            '${Format.format(activeWindow.getCount(), 1)}',
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
          updateTotal: updateTotalFun,
        ),

        // Sided Factor
        FactorCoin(
          factorKey: Factors.sided,
          window: activeWindow,
          size: _size * _sizeRatio,
          updateTotal: updateTotalFun,
        ),
      ],
    );
  }
}
