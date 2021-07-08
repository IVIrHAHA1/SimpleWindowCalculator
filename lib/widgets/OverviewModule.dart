import 'package:the_window_calculator/Util/HexColors.dart';

import '../Util/ItemsManager.dart';

/**
 * Overview module controllers the TabView which in turn conatains the
 * Job Details and Tech Details widgets.
 * 
 */

import 'ActiveItemsLister.dart';
import '../widgets/TechDetails.dart';
import 'package:flutter/material.dart';
import '../GlobalValues.dart' as R;

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
          Flexible(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: HexColors.fromHex(R.TEXT_COLOR),
                            ),
                      ),
                      Text(
                        'tap on item to edit',
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Colors.black26,
                            ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1.5,
                  )
                ],
              ),
            ),
          ),

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
