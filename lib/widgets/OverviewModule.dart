import 'package:SimpleWindowCalculator/Tools/GlobalValues.dart';
import 'package:SimpleWindowCalculator/Util/ItemsManager.dart';

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

  OverviewModule(this.totalPrice, this.totalDuration);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 0,
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
            flex: 1,
            child: TabBarView(
              children: [
                Pallet(ItemsManager.instance.items),
                TechDetails(totalPrice, totalDuration),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
