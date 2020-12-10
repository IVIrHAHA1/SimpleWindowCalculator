import 'package:SimpleWindowCalculator/Tools/Format.dart';
import 'package:SimpleWindowCalculator/widgets/WindowPallet.dart';
import 'package:flutter/material.dart';

class OverviewModule extends StatelessWidget {
  final double totalPrice;
  final Duration totalDuration;
  final List windowList;
  final pageController = PageController(initialPage: 0);

  final Map<String, Text> statList = Map();

  OverviewModule(this.totalPrice, this.totalDuration, this.windowList);

  _initStats(BuildContext ctx) {
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

  @override
  Widget build(BuildContext context) {
    _initStats(context);
    return PageView(
      controller: pageController,
      children: [
        Card(child: WindowPallet(windowList),),
        _techDetails(),
      ],
    );
  }

  Container _techDetails() {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          String labelKey = statList.keys.elementAt(index);

          return ListTile(
            title: Text(
              labelKey,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: statList[labelKey],
          );
        },
        itemCount: statList.length,
      ),
    );
  }
}
