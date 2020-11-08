import 'package:flutter/material.dart';

class OverviewModule extends StatelessWidget {
  final double totalPrice;
  final Duration totalDuration;

  final Map<String, Text> statList = Map();

  _initStats() {
    statList.putIfAbsent('Hourly Rate', () => dictateHourlyRate());
    statList.putIfAbsent('Tech Rate', () => techHourlyRate());
  }

  dictateHourlyRate() {
    var hourlyRate;
    totalPrice == null || totalDuration == null
        ? hourlyRate = 0.0
        : hourlyRate = totalPrice / (totalDuration.inMinutes / 60);
    return Text('$hourlyRate');
  }

  techHourlyRate() {
    var techRate;

    totalPrice == null || totalDuration == null
        ? techRate = 0.0
        : techRate = (totalPrice / (totalDuration.inMinutes / 60)) * .3;
    return Text('$techRate');
  }

  OverviewModule(this.totalPrice, this.totalDuration);

  @override
  Widget build(BuildContext context) {
    _initStats();
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          String labelKey = statList.keys.elementAt(index);

          return ListTile(
            leading: Text(labelKey),
            trailing: statList[labelKey],
          );
        },
        itemCount: statList.length,
      ),
    );
  }
}
