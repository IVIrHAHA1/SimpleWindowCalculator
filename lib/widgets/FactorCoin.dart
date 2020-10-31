import '../objects/Factor.dart';
import 'package:flutter/material.dart';

class FactorCoin extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Alignment alignment;
  final Factor factor;
  final Widget child;

  final bool activated;
  _FactorCoinState instance;

  static const double iconRatio = 1 / 6;

  FactorCoin({
    @required this.size,
    @required this.factor,
    this.child,
    this.backgroundColor = Colors.white,
    this.alignment = Alignment.center,
    this.activated = false,
  });

  /*
   * Method used as childWhenDragging (Draggable)
   */
  FactorCoin stasisCoin() {
    return FactorCoin(
      size: size,
      factor: factor,
      alignment: alignment,
      backgroundColor: backgroundColor,
      activated: true,
    );
  }

  /*
   * Method used as feedback (Draggable)
   */
  FactorCoin draggingCoin(double altSizeRatio) {
    return FactorCoin(
      size: size * altSizeRatio,
      factor: factor,
      alignment: alignment,
      backgroundColor: backgroundColor,
    );
  }

  FactorCoin disable(FactorCoin coin) {
    coin.instance.disable();
    return coin;
  }

  enable() {
    instance.enable();
  }

  changeMode() {
    instance.changeMode();
  }

  @override
  _FactorCoinState createState() {
    instance = _FactorCoinState(activated);
    return instance;
  }
}

/*
 *  FactorCoin, stateful widget because the border changes color
 *  indicated to the user whether they are incrmenting or decrementing. 
 */
class _FactorCoinState extends State<FactorCoin> {
  bool disabled = false;
  bool modeIncrement = true;

  _FactorCoinState(this.disabled);

  disable() {
    setState(() {
      disabled = true;
    });
  }

  enable() {
    setState(() {
      disabled = false;
    });
  }

  changeMode() {
    setState(() {
      modeIncrement ? modeIncrement = false : modeIncrement = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: disabled ? Colors.grey : widget.backgroundColor,
      shape: CircleBorder(
        side: BorderSide(
          color: styleBorder(context),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: disabled
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

  /*
   * Used for immutable circles
   */
  Color styleBorder(BuildContext ctx) {
    if (widget.factor == null) {
      return Theme.of(ctx).primaryColor;
    } else {
      return disabled
          ? Colors.grey
          : (modeIncrement ? Colors.green : Colors.red);
    }
  }

  /*
   *  Builds the inner image of the coin, needed as a method because
   *  when attached or dragged the entire image is grey-scaled.
   */
  Container _buildIMGContainer() {
    return Container(
      height: widget.size,
      width: widget.size,
      padding: EdgeInsets.all(widget.size * FactorCoin.iconRatio),
      alignment: widget.alignment,
      // Takes the factor image. Otherwise takes any widget child and builds the circle
      // around it. Used for Window Specific Counter.
      child: widget.factor != null ? widget.factor.getImage() : widget.child,
    );
  }
}
