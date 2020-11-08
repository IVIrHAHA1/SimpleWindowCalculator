import 'package:flutter/material.dart';

class OverviewModule extends StatelessWidget {
  final double totalPrice;
  final Duration totalDuration;

  final Map<String, Text> statList = Map();

  _initStats() {
    statList.putIfAbsent('Hourly Rate', () => dictateHourlyRate());
  }

  dictateHourlyRate() {
    var total = 10 / 100;
    return Text('$total');
  }

  OverviewModule(this.totalPrice, this.totalDuration);

  @override
  Widget build(BuildContext context) {
    _initStats();
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          String labelKey = statList.keys.elementAt(index);

          return ListTile(leading: Text(labelKey), trailing: statList[labelKey],);
        },
        itemCount: statList.length,
      ),
    );
  }
}
