import '../Util/ItemsManager.dart';

/**
 * Overview module controllers the TabView which in turn conatains the
 * Job Details and Tech Details widgets.
 * 
 */

import 'ActiveItemsLister.dart';
import '../widgets/TechDetails.dart';
import 'package:flutter/material.dart';

class OverviewModule extends StatelessWidget {
  final double totalPrice;
  final Duration totalDuration;
  final Function collapseNotifier;

  OverviewModule(this.totalPrice, this.totalDuration, this.collapseNotifier);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // TODO: Add Overview header

          // OVERVIEW BODY
          Flexible(
            flex: 1,
            child: ActiveItemsLister(
              ItemsManager.instance.items,
              collapseNotifier,
            ),
          ),
        ],
      ),
    );
  }
}
