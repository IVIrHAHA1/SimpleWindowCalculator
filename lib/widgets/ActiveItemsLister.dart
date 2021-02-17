import 'package:SimpleWindowCalculator/Tools/ImageLoader.dart';

import '../GlobalValues.dart';
import '../Util/HexColors.dart';
import '../objects/OManager.dart';
import 'FactorCoin.dart';

import '../Util/Format.dart';

import '../objects/Window.dart';
import 'package:flutter/material.dart';

class ActiveItemsLister extends StatelessWidget {
  final List<Window> windowList;

  ActiveItemsLister(this.windowList);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: windowList.map((window) {
            return _ItemListing(
              window: window,
              height: MediaQuery.of(context).size.height / 8,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ItemListing extends StatelessWidget {
  final Window window;
  final double height;

  const _ItemListing({
    Key key,
    @required this.window,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(GlobalValues.cornerRadius),
                image: DecorationImage(
                    image: (Imager.fromFile(window.getImageFile())
                        .masterImage as Image)
                        .image, fit: 
                        BoxFit.cover),
              ),
              height: height,
              width: height,
            ),

            // Window results
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: GlobalValues.appMargin),
                alignment: Alignment.topLeft,
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Format.format(window.quantity, 1)}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '\$${Format.format(window.totalPrice, 2)}',
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
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildFactorOverview(
                      height,
                      Factors.filthy,
                      HexColors.fromHex('#DCA065'),
                    ),
                    buildFactorOverview(
                      height,
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
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildFactorOverview(
                      height,
                      Factors.construction,
                      HexColors.fromHex('#FFB9B9'),
                    ),
                    buildFactorOverview(
                      height,
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
