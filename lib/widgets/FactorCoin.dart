import '../objects/Factor.dart';
import 'package:flutter/material.dart';

class FactorCoin extends StatelessWidget {
  final double size;
  final Color backgroundColor, borderColor;
  final Alignment alignment;
  final Factor factor;
  final Widget child;

  final bool activated;

  static const double iconRatio = 1 / 6;

  FactorCoin({
    @required this.size,
    @required this.factor,
    this.child,
    this.backgroundColor = Colors.white,
    this.alignment = Alignment.center,
    this.borderColor,
    this.activated = false,
  });

  FactorCoin resize(double altSizeRatio) {
    return FactorCoin(
      size: size * altSizeRatio,
      factor: factor,
      alignment: alignment,
      backgroundColor: backgroundColor,
    );
  }

  passify() {
    return FactorCoin(
      size: size,
      factor: factor,
      alignment: alignment,
      backgroundColor: backgroundColor,
      borderColor: Colors.blueGrey,
      activated: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: activated ? Colors.grey : backgroundColor,
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
              child: _buildIMGContainer(),
            )
          : _buildIMGContainer(),
    );
  }

  Container _buildIMGContainer() {
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(size * FactorCoin.iconRatio),
      alignment: alignment,
      child: factor != null ? factor.getImage() : child,
    );
  }
}
