import 'package:TheWindowCalculator/GlobalValues.dart';
import 'package:TheWindowCalculator/Util/Format.dart';
import '../Animations/SpinnerTransition.dart';
import '../Animations/PopUpTextField.dart';
import 'package:flutter/material.dart';

class TechDetails extends StatelessWidget {
  final Map<String, Text> statList = Map();
  final double totalPrice;
  final Duration totalDuration;

  TechDetails(this.totalPrice, this.totalDuration);

  @override
  Widget build(BuildContext context) {
    _initStats(context);

    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          String labelKey = statList.keys.elementAt(index);

          return _MyListTile(
            labelKey: labelKey,
            statList: statList,
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
    @required this.labelKey,
    @required this.statList,
    this.withEdit = false,
  }) : super(key: key);

  final String labelKey;
  final Map<String, Text> statList;
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
    var textStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Lato',
      fontWeight: FontWeight.bold,
    );
    return Container(
      width: double.infinity,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${widget.labelKey}',
            style: textStyle,
          ),
          Expanded(
            child: _buildEditBtn(),
          ),
        ],
      ),
    );
    // return ListTile(
    //   title: Visibility(
    //     visible: !popUpExpanded,
    //     child: Text(
    //       widget.labelKey,
    //       style: TextStyle(
    //         color: Colors.black,
    //         fontFamily: 'Lato',
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ),
    //   leading: Visibility(
    //     visible: !popUpExpanded,
    //     child: widget.statList[widget.labelKey],
    //   ),
    //   trailing: widget.withEdit ? _buildEditBtn() : null,
    // );
  }

  _buildEditBtn() {
    return PopUpTextField(
      controller: controller,
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
          !popUpExpanded ? controller.forward() : controller.reverse();
          setState(() {
            popUpExpanded = !popUpExpanded;
          });
        },
      ),
      duration: duration,
    );
  }
}
