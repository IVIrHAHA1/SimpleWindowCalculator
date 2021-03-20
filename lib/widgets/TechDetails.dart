import 'dart:async';

import 'package:TheWindowCalculator/objects/Setting.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Animations/SpinnerTransition.dart';
import '../Animations/PopUpTextField.dart';
import 'package:flutter/material.dart';
import '../objects/OManager.dart' as defaults;
import '../Util/Format.dart' as tools;

class TechDetails extends StatelessWidget {
  final double totalPrice;
  final Duration totalDuration;

  TechDetails(this.totalPrice, this.totalDuration);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return _MyListTile(
            setting: defaults.settingsList[index],
          );
        },
        itemCount: defaults.settingsList.length,
      ),
    );
  }
}

/// This way when updated, the setState method is not called on the entire list.
class _MyListTile extends StatefulWidget {
  _MyListTile({
    Key key,
    this.setting,
  }) : super(key: key);

  final Setting setting;

  @override
  __MyListTileState createState() => __MyListTileState();
}

class __MyListTileState extends State<_MyListTile>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool popUpExpanded = false;
  var duration = const Duration(milliseconds: 400);

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle valueStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.black,
        );
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      // Leading
                      Expanded(
                        flex: 3,
                        child: _buildValueText(valueStyle, context),
                      ),

                      // Title
                      Expanded(
                        flex: !popUpExpanded ? 5 : 3,
                        child: Text(
                          '${widget.setting.title}',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Subtitle
                Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(),
                      ),
                      Expanded(
                        flex: !popUpExpanded ? 5 : 3,
                        child: widget.setting.subtitle != null
                            ? Text(
                                '${widget.setting.subtitle}',
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(fontSize: 12),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Trailing
          Expanded(
            flex: !popUpExpanded ? 2 : 5,
            child: Container(
              alignment: Alignment.centerRight,
              child:
                  widget.setting.editable ? _buildEditBtn() : Container(),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<double> _buildValueText(
      TextStyle valueStyle, BuildContext context) {
    return FutureBuilder(
      future: _loadValue(widget.setting.title),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return LayoutBuilder(
            builder: (ctx, constraints) {
              String valueString =
                  '\$ ${tools.Format.format(snapshot.data, 2)}';
              Size textSize = _getTextSize(valueString, valueStyle);

              Text text = Text(valueString, style: valueStyle);

              if (textSize.width > constraints.maxWidth) {
                return FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: text,
                  ),
                );
              } else {
                return text;
              }
            },
          );
        } else if (snapshot.hasError) {
          return Text('error');
        } else {
          return Text(
            '${widget.setting.value}',
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.black,
                ),
          );
        }
      },
    );
  }

  Size _getTextSize(String text, TextStyle style) {
    TextPainter painter = TextPainter(
        text: TextSpan(
          text: text,
          style: style,
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(
        maxWidth: double.infinity,
        minWidth: 0,
      );

    return painter.size;
  }

  Widget _buildEditBtn() {
    return PopUpTextField(
      controller: controller,
      textInputType: TextInputType.number,
      onSubmitted: (submittedText) {
        double newValue = double.parse(submittedText);
        _saveValue(widget.setting.title, newValue).then((saved) {
          if (saved) {
            _collapseWidget();
          }
        });
      },
      validator: (textValue) {
        try {
          num value = double.parse(textValue);
          if (value != null)
            return true;
          else
            return false;
        } catch (Exception) {
          return false;
        }
      },
      icon: SpinnerTransition(
        controller: controller,
        child1: Icon(
          Icons.edit,
          color: Colors.black,
        ),
        child2: Icon(
          Icons.check,
          color: Colors.black,
        ),
        duration: duration,
        onPressed: () {
          if (!popUpExpanded) {
            _expandWidget();
          } else {
            _collapseWidget();
          }
        },
      ),
      duration: duration,
    );
  }

  _expandWidget() {
    controller.forward();
    setState(() {
      popUpExpanded = !popUpExpanded;
    });
  }

  _collapseWidget() {
    controller.reverse();
    _reshape();
  }

  _reshape() async {
    Timer(duration, () {
      setState(() {
        popUpExpanded = false;
      });
    });
  }

  SharedPreferences _prefs;
  Future<double> _loadValue(String key) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.getDouble(key);
  }

  Future<bool> _saveValue(String key, num value) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    bool saved = await _prefs.setDouble(key, value);
    return saved;
  }
}
