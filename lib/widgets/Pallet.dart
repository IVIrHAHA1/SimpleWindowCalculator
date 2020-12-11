import 'package:SimpleWindowCalculator/Tools/GlobalValues.dart';
import 'package:SimpleWindowCalculator/objects/OManager.dart';
import 'package:SimpleWindowCalculator/widgets/FactorCoin.dart';

import '../Tools/Format.dart';

import '../objects/Window.dart';
import 'package:flutter/material.dart';

class WindowPallet extends StatelessWidget {
  final List<Window> windowList;

  WindowPallet(this.windowList);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('windows in use'),
        Divider(
          thickness: 2,
          height: 4,
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: windowList.map((window) {
                  return _WindowPreview(window: window);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WindowPreview extends StatelessWidget {
  final Window window;
  const _WindowPreview({
    Key key,
    @required this.window,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getHeight = () {
      return MediaQuery.of(context).size.height / 6;
    };

    var width =
        MediaQuery.of(context).size.width - (GlobalValues.appMargin * 2);

    return Column(
      children: [
        Container(
          width: double.infinity, // Sets the width of the Column
          child: Row(
            children: [
              // Get Image
              Container(
                child: window.getPicture(),
                height: getHeight(),
              ),

              // Window results
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: GlobalValues.appMargin),
                  alignment: Alignment.topLeft,
                  height: getHeight(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Format.format(window.getCount(), 1)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '\$${Format.format(window.grandTotal(), 2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              // Filthy and Difficult
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  height: getHeight(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildFactorOverview(getHeight(), Factors.filthy),
                      buildFactorOverview(getHeight(), Factors.difficult),
                    ],
                  ),
                ),
              ),

              // Construction and Sided
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  height: getHeight(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildFactorOverview(getHeight(), Factors.construction),
                      buildFactorOverview(getHeight(), Factors.sided),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 2,
          height: 5,
          endIndent: 8,
          indent: 8,
        ),
      ],
    );
  }

  Container buildFactorOverview(double height, Factors factorType) {
    return Container(
      height: height / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${Format.format(window.factorList[factorType].getCount(), 1)}',
          ),
          FactorCoin(
            size: height / 3,
            factorKey: factorType,
            window: window,
          ),
        ],
      ),
    );
  }
}
