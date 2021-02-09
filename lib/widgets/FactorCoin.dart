import 'package:SimpleWindowCalculator/Routes/FactorOptionsRoute.dart';
import 'package:SimpleWindowCalculator/Util/Calculator.dart';
import 'package:flutter/services.dart';

import '../objects/OManager.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

class FactorCoin extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Alignment alignment;
  final Factors factorKey;
  final Window window;
  final isDummy;

  static const double iconRatio = 1 / 6;

  FactorCoin({
    @required this.size,
    @required this.factorKey,
    this.isDummy = true,
    this.window,
    this.backgroundColor = Colors.white,
    this.alignment = Alignment.center,
  });

  @override
  _FactorCoinState createState() {
    return _FactorCoinState();
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

  _FactorCoinState();

// Makes the Factor count along with the window count
// ** Does not necessarily mean they have the same count
// ** Factor counting occurs inside the window object
  changeAttachmentStatus() {
    setState(() {
      // If disable is true then factor is affixed
      disabled ? disabled = false : disabled = true;
    });
    widget.window.affixFactor(widget.factorKey, disabled);
  }

// Changes mode from incrementing to decrementing and vice-versa
  changeMode() {
    setState(() {
      modeIncrement ? modeIncrement = false : modeIncrement = true;
    });
  }

  // Hard set for incrementing mode
  setMode(bool mode) {
    setState(() {
      modeIncrement = mode;
    });
  }

  /*
   *  Gives option menu control of various states throught the app. 
   */
  optionController(Function stateOperation, FactorOptions option) {
    switch (option) {
      case FactorOptions.decrement:
        changeMode();
        Navigator.of(context).pop();
        break;

      case FactorOptions.apply:
        stateOperation();
        changeAttachmentStatus();
        Calculator.instance.update();
        Navigator.of(context).pop();
        break;

      case FactorOptions.clear:
        stateOperation();
        Calculator.instance.update();
        Navigator.of(context).pop();
        break;

      case FactorOptions.edit:
        // TODO: implement
        Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isDummy
        ? buildInteractiveCoin(context)
        : buildDummyCoin();
  }

  Widget buildDummyCoin() {
    return mintCoin(context, false, widget.size);
  }

  Widget buildInteractiveCoin(BuildContext context) {
    disabled = widget.window.getFactor(widget.factorKey).isAffixed();
    // Gives window object some control over this FactorCoin
    widget.window.registerFactorQAListener(widget.factorKey, setMode);

    return disabled
        // (disabled) -> Coin is grayed out and has to be held to re-enable
        //  * while disabled cannot drag or increment/decrement
        ? InkWell(
            onLongPress: () {
              changeAttachmentStatus();
            },
            child: mintCoin(context, true, widget.size),
          )
        // (enabled) -> Coin is draggable and increments
        : Draggable<Function>(
            data: changeAttachmentStatus,
            feedback: mintCoin(context, false, widget.size * 1.5),
            childWhenDragging: mintCoin(context, true, widget.size),
            child: InkWell(
              onTap: () {
                HapticFeedback.heavyImpact();
                modeIncrement
                    ? widget.window.incrementFactor(widget.factorKey)
                    : widget.window.decrementFactor(widget.factorKey);
                Calculator.instance.update();
              },
              onLongPress: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  FactorOptionRoute(
                    incrementingMode: modeIncrement,
                    optionsController: optionController,
                    window: widget.window,
                    factorKey: widget.factorKey,
                  ),
                );
                //changeMode();
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
      elevation: 0,
      color: greyed ? Colors.grey : widget.backgroundColor,
      shape: CircleBorder(
        side: BorderSide(
          color: styleBorder(context, greyed),
          width: coinSize / 12,
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
   *  ** IconImage and container holder
   */
  Container _buildIMGContainer(double coinSize) {
    return Container(
      height: coinSize,
      width: coinSize,
      padding: EdgeInsets.all(coinSize * FactorCoin.iconRatio),
      alignment: widget.alignment,
      // Takes the factor image. Otherwise takes any widget child and builds the circle
      // around it. Used for Window Specific Counter.
      child: OManager.factorList[widget.factorKey].getImage(),
    );
  }

  /*
   * Used for immutable circles
   */
  Color styleBorder(BuildContext ctx, bool gray) {
    return disabled || gray
        ? Colors.blueGrey
        : (modeIncrement ? Theme.of(ctx).primaryColor : Colors.red);
  }
}
