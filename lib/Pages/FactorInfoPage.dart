import 'package:flutter/material.dart';
import 'package:the_window_calculator/objects/OManager.dart';
import 'package:the_window_calculator/widgets/FactorCoin.dart';

class FactorInfoPage extends StatelessWidget {
  const FactorInfoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * .8;
    final width = MediaQuery.of(context).size.width * .85;

    final factorSize = width * .25;

    return SWCWindow(
      winHeight: height,
      winWidth: width,
      heading: 'About Factor Coins',
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Sided
              _factorDisplay(
                context,
                title: 'One-Side Only',
                coin: FactorCoin(
                  size: factorSize,
                  factorKey: Factors.sided,
                  isDummy: true,
                ),
                sub1: 'increments/decrements 1',
                sub2: 'multiplier value x.6',
              ),
              // Obstructed
              _factorDisplay(
                context,
                title: 'Obstructed',
                coin: FactorCoin(
                  size: factorSize,
                  factorKey: Factors.difficult,
                  isDummy: true,
                  backgroundColor: Color(0xFFFFEDA5),
                ),
                sub2: 'multiplier value x1.5',
              ),
              // Filthy
              _factorDisplay(
                context,
                title: 'Filthy',
                coin: FactorCoin(
                  size: factorSize,
                  factorKey: Factors.filthy,
                  isDummy: true,
                  backgroundColor: Color(0xFFDCA065),
                ),
                sub2: 'multiplier value x1.75',
              ),
              // Construction
              _factorDisplay(
                context,
                title: 'Construction',
                coin: FactorCoin(
                  size: factorSize,
                  factorKey: Factors.construction,
                  isDummy: true,
                  backgroundColor: Color(0xFFFFB9B9),
                ),
                sub2: 'multiplier value x2',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _factorDisplay(
    BuildContext ctx, {
    FactorCoin coin,
    String title,
    String sub1 = 'increments/decrements 0.5',
    String sub2,
  }) {
    final TextTheme theme = Theme.of(ctx).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0, top: 8.0),
      child: Column(
        children: [
          Text(
            '$title',
            style: theme.headline6.copyWith(
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: coin,
          ),
          Text(
            '$sub1',
            style: theme.subtitle1,
          ),
          Text(
            '$sub2',
            style: theme.subtitle1,
          ),
        ],
      ),
    );
  }
}

class SWCWindow extends StatelessWidget {
  final String heading;
  final Widget body;
  final double winHeight, winWidth;

  SWCWindow({
    this.heading = '',
    @required this.body,
    this.winHeight,
    this.winWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Use this as default if user did not enter value
    final double height = winHeight ?? MediaQuery.of(context).size.height * .8;
    final double width = winWidth ?? MediaQuery.of(context).size.height * .85;

    return Container(
      alignment: Alignment.center,
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// SETTING HEADER
              Container(
                height: height * .15,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.0),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$heading',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),

              /// SETTINGS BODY
              Expanded(
                flex: 1,
                child: body,
              ),

              /// SETTINGS FOOTER
              SizedBox(
                height: height * .1,
                child: buildFooterButton(context, 'ok', () {
                  Navigator.pop(context);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Card buildFooterButton(
    BuildContext ctx,
    String text,
    Function onPressed,
  ) {
    return Card(
      elevation: 4,
      color: onPressed != null ? Theme.of(ctx).primaryColor : Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onPressed,
        splashColor: Theme.of(ctx).primaryColorLight,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(ctx).size.width * .5,
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 2),
          ),
        ),
      ),
    );
  }
}
