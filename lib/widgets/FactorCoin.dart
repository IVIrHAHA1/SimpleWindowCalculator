import '../objects/OManager.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

class FactorCoin extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Alignment alignment;
  final Factors factorKey;
  final Widget child; // TODO: Remove when redesign occurs
  final Window window;

  final bool activated;

  static const double iconRatio = 1 / 6;

  FactorCoin({
    @required this.size,
    this.factorKey,
    this.window,
    this.child,
    this.backgroundColor = Colors.white,
    this.alignment = Alignment.center,
    this.activated = false,
  });

  /*
   * Method used as childWhenDragging (Draggable)
   */
  stasisCoin() {
    return Container(
      child: FactorCoin(
        size: size,
        factorKey: factorKey,
        window: window,
        alignment: alignment,
        backgroundColor: backgroundColor,
        activated: true,
      ),
    );
  }

  /*
   * Method used as feedback (Draggable)
   */
  draggingCoin(double altSizeRatio) {
    return Container(
      child: FactorCoin(
        size: size * altSizeRatio,
        factorKey: factorKey,
        alignment: alignment,
        window: window,
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  _FactorCoinState createState() {
    return _FactorCoinState(activated);
  }
}

/*  STATE !!!
 *  --------------------------------------------------------------------
 *  FactorCoin, stateful widget because the border changes color
 *  indicated to the user whether they are incrmenting or decrementing. 
 *  --------------------------------------------------------------------
 */
class _FactorCoinState extends State<FactorCoin> {
  bool disabled = false;
  bool modeIncrement = true;

  _FactorCoinState(this.disabled);

  // amend(Factors key, Function function) {
  //   setState(() {
  //     disabled ? disabled = false : disabled = true;
  //   });
  // }

  changeMode() {
    setState(() {
      modeIncrement ? modeIncrement = false : modeIncrement = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<Factors>(
      data: widget.factorKey,
      feedback: mintCoin(context, false, widget.size * 1.1),
      childWhenDragging: mintCoin(context, true, widget.size),
      child: InkWell(
        onTap: () {
          modeIncrement
              ? widget.window.incrementTag(widget.factorKey)
              : widget.window.decrementTag(widget.factorKey);
        },
        onLongPress: () {
          changeMode();
        },
        child: mintCoin(context, disabled, widget.size),
      ),
    );
  }

  /*
   *  Builds the coin aesthetics 
   */
  Card mintCoin(BuildContext context, bool greyed, double coinSize) {
    return Card(
      color: greyed ? Colors.grey : widget.backgroundColor,
      shape: CircleBorder(
        side: BorderSide(
          color: styleBorder(context),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: greyed
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: _buildIMGContainer(coinSize),
            )
          : _buildIMGContainer(coinSize),
    );
  }

  /*
   *  Builds the inner image of the coin, needed as a method because
   *  when attached or dragged the entire image is grey-scaled.
   */
  Container _buildIMGContainer(double coinSize) {
    return Container(
      height: coinSize,
      width: coinSize,
      padding: EdgeInsets.all(coinSize * FactorCoin.iconRatio),
      alignment: widget.alignment,
      // Takes the factor image. Otherwise takes any widget child and builds the circle
      // around it. Used for Window Specific Counter.
      child: widget.window != null
          ? widget.window.getFactor(widget.factorKey).getImage()
          : widget.child,
    );
  }

  /*
   * Used for immutable circles
   *  ** TODO: Remove when design occurs.
   */
  Color styleBorder(BuildContext ctx) {
    if (widget.child != null) {
      return Theme.of(ctx).primaryColor;
    } else {
      return disabled
          ? Colors.grey
          : (modeIncrement ? Colors.green : Colors.red);
    }
  }
}
