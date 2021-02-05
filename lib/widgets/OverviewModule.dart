import 'package:SimpleWindowCalculator/Tools/GlobalValues.dart';

/**
 * Overview module controllers the TabView which in turn conatains the
 * Job Details and Tech Details widgets.
 * 
 */

import '../widgets/Pallet.dart';
import '../widgets/TechDetails.dart';
import 'package:flutter/material.dart';

class OverviewModule extends StatelessWidget {
  final double totalPrice;
  final Duration totalDuration;
  final List windowList;
  final pageController = PageController(initialPage: 0);

  OverviewModule(this.totalPrice, this.totalDuration, this.windowList);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Job Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Tech Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: TabBarView(
              children: [
                Pallet(windowList),
                TechDetails(totalPrice, totalDuration),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
