import 'dart:async';

import 'package:TheWindowCalculator/GlobalValues.dart';
import 'package:TheWindowCalculator/Util/Format.dart';
import '../Animations/SpinnerTransition.dart';
import '../Animations/PopUpTextField.dart';
import 'package:flutter/material.dart';

class TechDetails extends StatelessWidget {
  final Map<String, Widget> statList = Map();
  final double totalPrice;
  final Duration totalDuration;

  TechDetails(this.totalPrice, this.totalDuration);

  @override
  Widget build(BuildContext context) {
    _initStats(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          String labelKey = statList.keys.elementAt(index);

          return _MyListTile(
            title: Text(
              '$labelKey',
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                  ),
            ),
            amount: statList[labelKey],
            withEdit: true,
          );
        },
        itemCount: statList.length,
      ),
    );
  }

  _initStats(BuildContext ctx) {
    statList.putIfAbsent(
        'Target Production Rate',
        () => Text(
              '\$${Format.format(TARGET_HOURLY_RATE, 2)}',
              style: Theme.of(ctx).textTheme.headline5,
            ));
    statList.putIfAbsent('Hourly Rate', () => _dictateHourlyRate(ctx));
    statList.putIfAbsent('Tech Rate', () => _techHourlyRate(ctx));
  }

  _dictateHourlyRate(BuildContext ctx) {
    var hourlyRate;
    _verifyTotals()
        ? hourlyRate = 0.0
        : hourlyRate = totalPrice / (totalDuration.inMinutes / 60);
    return Text(
      '\$${Format.format(hourlyRate, 2)}',
      style: Theme.of(ctx).textTheme.headline5,
    );
  }

  _techHourlyRate(BuildContext ctx) {
    var techRate;

    _verifyTotals()
        ? techRate = 0.0
        : techRate = (totalPrice / (totalDuration.inMinutes / 60)) * .3;
    return Text(
      '\$${Format.format(techRate, 2)}',
      style: Theme.of(ctx).textTheme.headline5,
    );
  }

  bool _verifyTotals() {
    return totalPrice == null ||
        totalPrice == 0 ||
        totalDuration == null ||
        totalDuration == Duration();
  }
}

class _MyListTile extends StatefulWidget {
  _MyListTile({
    Key key,
    @required this.title,
    @required this.amount,
    this.subtitle,
    this.withEdit = false,
  }) : super(key: key);

  final Widget title;
  final Widget subtitle;
  final Widget amount;
  final bool withEdit;

  @override
  __MyListTileState createState() => __MyListTileState();
}

class __MyListTileState extends State<_MyListTile>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool popUpExpanded = false;
  var duration = const Duration(milliseconds: 400);

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: widget.amount,
          ),
          Expanded(
            flex: !popUpExpanded ? 3 : 1,
            child: widget.title,
          ),
          Expanded(
            flex: !popUpExpanded ? 1 : 3,
            child: Container(
              alignment: Alignment.centerRight,
              child: widget.withEdit ? _buildEditBtn() : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBtn() {
    return PopUpTextField(
      controller: controller,
      textInputType: TextInputType.number,
      validator: (textValue) {
        try {
          num value = double.parse(textValue);
          if (value != null)
            return true;
          else
            return false;
        } catch (Exception) {
          return false;
        }
      },
      icon: SpinnerTransition(
        child1: Icon(
          Icons.edit,
          color: Colors.black,
        ),
        child2: Icon(
          Icons.check,
          color: Colors.black,
        ),
        duration: duration,
        onPressed: () {
          if (!popUpExpanded) {
            controller.forward();
            setState(() {
              popUpExpanded = !popUpExpanded;
            });
          } else {
            controller.reverse();
            _reshape();
          }
        },
      ),
      duration: duration,
    );
  }

  _reshape() async {
    Timer(duration, () {
      setState(() {
        popUpExpanded = false;
      });
    });
  }
}
