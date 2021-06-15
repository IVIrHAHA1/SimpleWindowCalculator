import 'package:flutter/material.dart';
import 'package:the_window_calculator/Util/HexColors.dart';
import 'package:the_window_calculator/widgets/TechDetails.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height * .8;
    width = MediaQuery.of(context).size.width * .85;

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
                  'Settings',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),

              /// SETTINGS BODY
              Expanded(
                flex: 1,
                child: settingsBody(),
              ),

              /// SETTINGS FOOTER
              SizedBox(
                height: height * .1,
                child: buildFooterButton('ok', () {
                  Navigator.pop(context);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
        child: Container(
          child: Column(
            children: [
              // adjusting prices
              ExpandableListTile(
                title: Text('adjust prices'),
                subtitle: Text('this will change the results'),
                icon: Icon(
                  Icons.price_check_sharp,
                  color: Colors.black54,
                ),
                embeddedChild: TechDetails(),
              ),

              // change currency symbol
              ExpandableListTile(
                title: Text('change currency symbol'),
                subtitle: Text('this will change the results'),
                icon: Text(
                  '\$',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ),

              // how calculations work
              ExpandableListTile(
                title: Text('how calculations work'),
                subtitle: Text('this will change the results'),
                icon: Icon(
                  Icons.quiz_outlined,
                  color: Colors.black54,
                ),
              ),

              // about
              ExpandableListTile(
                title: Text('about'),
                subtitle: Text('this will change the results'),
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.black54,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Card buildFooterButton(String text, Function onPressed) {
    return Card(
      elevation: 4,
      color: onPressed != null ? Theme.of(context).primaryColor : Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onPressed,
        splashColor: Theme.of(context).primaryColorLight,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .5,
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

class ExpandableListTile extends StatefulWidget {
  const ExpandableListTile({
    Key key,
    @required this.title,
    this.targetHeight = 75,
    this.subtitle,
    this.icon,
    this.embeddedChild,
  }) : super(key: key);

  final Widget title, subtitle;
  final Widget icon;
  final double targetHeight;
  final embeddedChild;

  @override
  _ExpandableListTileState createState() => _ExpandableListTileState();
}

class _ExpandableListTileState extends State<ExpandableListTile> {
  double childHeight = 200;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Flexible(
            flex: 0,

            /// Visual Tile
            child: InkWell(
              onTap: () {
                setState(() {
                  print('tap registered');
                  expanded = !expanded;
                });
              },
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: widget.icon,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Material(
                            color: Colors.transparent,
                            textStyle: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(fontSize: 18),
                            child: widget.title,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          textStyle: Theme.of(context).textTheme.caption,
                          child: widget.subtitle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          /// Expanded to show embbeded child
          AnimatedContainer(
            height: expanded ? childHeight : 0,
            width: double.infinity,
            color: HexColors.fromHex('#FBFBFB'),
            duration: Duration(milliseconds: 300),
            child: widget.embeddedChild,
          ),
        ],
      ),
    );
  }
}
