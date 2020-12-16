import '../Tools/GlobalValues.dart';
import '../Tools/HexColors.dart';
import '../objects/OManager.dart';
import '../widgets/FactorCoin.dart';

import '../Tools/Format.dart';

import '../objects/Window.dart';
import 'package:flutter/material.dart';

class Pallet extends StatelessWidget {
  final List<Window> windowList;

  Pallet(this.windowList);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: windowList.map((window) {
            return _WindowPreview(window: window);
          }).toList(),
        ),
      ),
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
      return MediaQuery.of(context).size.height / 8;
    };

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          GlobalValues.cornerRadius,
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity, // Sets the width of the Column
        child: Row(
          children: [
            // Get Image
            Container(
              child: window.getImage(),
              height: getHeight(),
            ),

            // Window results
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: GlobalValues.appMargin),
                alignment: Alignment.topLeft,
                height: getHeight(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Format.format(window.getCount(), 1)}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '\$${Format.format(window.grandTotal(), 2)}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    buildFactorOverview(
                      getHeight(),
                      Factors.filthy,
                      HexColors.fromHex('#DCA065'),
                    ),
                    buildFactorOverview(
                      getHeight(),
                      Factors.difficult,
                      HexColors.fromHex('#FFEDA5'),
                    ),
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
                    buildFactorOverview(
                      getHeight(),
                      Factors.construction,
                      HexColors.fromHex('#FFB9B9'),
                    ),
                    buildFactorOverview(
                      getHeight(),
                      Factors.sided,
                      null,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildFactorOverview(
    double height,
    Factors factorType,
    Color color,
  ) {
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
            backgroundColor: color,
          ),
        ],
      ),
    );
  }
}
