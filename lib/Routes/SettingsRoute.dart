import 'package:flutter/material.dart';

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
    width = MediaQuery.of(context).size.width * .8;

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
    return Column(
      children: [
        // adjusting prices

        // change currency symbol

        // how calculations work

        // about
      ],
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
