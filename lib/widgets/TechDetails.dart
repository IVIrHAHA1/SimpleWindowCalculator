import 'dart:async';

import 'package:TheWindowCalculator/objects/Setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Animations/SpinnerTransition.dart';
import '../Animations/PopUpTextField.dart';
import 'package:flutter/material.dart';
import '../objects/OManager.dart' as defaults;

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
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Leading
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: _loadValue(widget.setting.title),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.black,
                        ),
                  );
                } else if (snapshot.hasError) {
                  return Text('error');
                } else {
                  return Text(
                    '0.0',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.black,
                        ),
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: !popUpExpanded ? 3 : 1,
            child: Text(
              '${widget.setting.title}',
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                  ),
            ),
          ),
          Expanded(
            flex: !popUpExpanded ? 1 : 3,
            child: Container(
              alignment: Alignment.centerRight,
              child: widget.setting.editable ? _buildEditBtn() : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBtn() {
    return PopUpTextField(
      controller: controller,
      textInputType: TextInputType.number,
      onSubmitted: (submittedText) {
        double newValue = double.parse(submittedText);
        _saveValue(widget.setting.title, newValue).then((saved) {
          if (saved) {
            setState(() {});
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
