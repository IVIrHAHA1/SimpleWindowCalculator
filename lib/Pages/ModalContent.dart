import 'dart:async';

import '../Routes/Window_Object_Screen.dart';
import '../Tools/DatabaseProvider.dart';
import '../GlobalValues.dart';
import '../Util/ItemsManager.dart';
import '../objects/Window.dart';
import '../widgets/GridTileItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../objects/OManager.dart';
import 'package:flutter/material.dart';

class ModalContent extends StatefulWidget {
  final Function addWindow;
  final Color backgroundColor;

  ModalContent({this.addWindow, this.backgroundColor = Colors.white});

  @override
  _ModalContentState createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  TextEditingController _textEditingController;
  String searchQuery;

  bool _editMode;
  Window selectedWindow;

  _ModalContentState() {
    _editMode = false;
  }

  @override
  void initState() {
    _textEditingController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void createWindow(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return WindowObjectScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double modalSheetHeight = (MediaQuery.of(context).size.height) / 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildSearchHeading(modalSheetHeight * .15, context),
        Flexible(
            fit: FlexFit.loose,
            child: buildBody(modalSheetHeight * .8, context)),
        buildButtonFooter(modalSheetHeight * .15, context),
      ],
    );
  }

  Container buildSearchHeading(double size, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GlobalValues.appMargin),
      alignment: Alignment.topRight,
      width: MediaQuery.of(context).size.width,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Edit Button
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: AnimatedContainer(
                duration: Duration(
                  milliseconds: GlobalValues.animDuration,
                ),
                alignment: Alignment.center,
                height: size * .7,
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _editMode = !_editMode;
                    });
                  },
                  child: Text(
                    _editMode ? "Editing" : "Edit Mode",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(GlobalValues.cornerRadius),
                  color: _editMode
                      ? Theme.of(context).primaryColorLight
                      : Colors.grey,
                ),
              ),
            ),
          ),

          // Search Bar
          Flexible(
            flex: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              height: size * .7,
              width: MediaQuery.of(context).size.width * .5,
              alignment: Alignment.topRight,
              child: TextField(
                controller: _textEditingController,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.right,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  isDense: false,
                  alignLabelWithHint: true,
                  border: InputBorder.none,
                  hintText: 'search ...',
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _allowDeletion = false;

  /// TODO: Extract this method and create an interface. THINK S.O.L.I.D
  _deleteSelection() async {
    /// Delete from database
    await DatabaseProvider.instance.delete(selectedWindow);

    // Update SharedPrefs if needed
    SharedPreferences sp = await SharedPreferences.getInstance();
    String defaultWindowName = sp.getString(DEFAULT_WINDOW_KEY);
    if (selectedWindow.name == defaultWindowName) {
      List<Window> availWindows = await DatabaseProvider.instance.loadAll();
      if (availWindows.length > 0) {
        sp.setString(DEFAULT_WINDOW_KEY, availWindows.first.name);
      }
    }

    // Update activeItems/HomePage if needed
    ItemsManager itemsManager = ItemsManager.instance;
    itemsManager.forceRemove(selectedWindow);

    if (itemsManager.activeItem == null) {
      Window defaultWindow = await DatabaseProvider.instance
          .queryWindow(sp.getString(DEFAULT_WINDOW_KEY));

      itemsManager.activeItem = defaultWindow;
      itemsManager.notifyListeners();
    }
  }

  newSelection(Window selection) async {
    setState(() {
      if (selectedWindow != selection)
        selectedWindow = selection;
      else
        selectedWindow = null;
    });
    int count = await DatabaseProvider.instance.entryLength();
    if (count > 1) {
      _allowDeletion = true;
    } else {
      _allowDeletion = false;
    }
  }

  Container buildBody(double size, BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: FutureBuilder<List<Window>>(
          initialData: OManager.presetWindows,
          future: DatabaseProvider.instance
              .querySearch(_textEditingController.text),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length <= 0) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                      "no windows found by the name of ${_textEditingController.text}"),
                  height: size,
                  width: double.infinity,
                );
              } else {
                return GridView.count(
                  crossAxisCount: 3,
                  scrollDirection: Axis.vertical,
                  children: snapshot.data.map((element) {
                    return GridTileItem(
                      item: element,
                      onPressed: widget.addWindow,
                      onSelected: newSelection,
                      selectable: _editMode,
                      selected: selectedWindow == element && _editMode,
                    );
                  }).toList(),
                );
              }
            } else {
              /// TODO: TRY AND RECOVER FROM CRASH
              return Container(child: Text('Fatal Crash'));
            }
          }),
    );
  }

  /// Footer background, animation and buttons.
  buildButtonFooter(double size, BuildContext context) {
    Widget createBtn = buildFooterButton('create', () => createWindow(context));
    Widget editBtns = Row(
      children: [
        Flexible(
          child: buildFooterButton(
            'delete',
            selectedWindow != null || !_editMode
                ? () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          titleTextStyle:
                              Theme.of(context).textTheme.headline6.copyWith(
                                    color: Colors.black,
                                  ),
                          title: Text(
                            _allowDeletion
                                ? 'Remove \"${selectedWindow.name.toLowerCase()}\"?'
                                : 'Unable to Remove',
                          ),
                          content: selectedWindow ==
                                  ItemsManager.instance.activeItem
                              ? Text(_allowDeletion
                                  ? 'about to remove active window'
                                  : 'must have at least one window available')
                              : null,
                          actions: [
                            _allowDeletion
                                ? TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                : Container(),
                            _allowDeletion
                                ? TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      _deleteSelection();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  )
                                : TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'),
                                  ),
                          ],
                        );
                      },
                    );
                  }
                : null,
          ),
        ),
        Flexible(
            child: buildFooterButton(
          'edit',
          selectedWindow != null && _editMode
              ? () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (ctx) {
                    return WindowObjectScreen(
                      window: selectedWindow,
                    );
                  }));
                }
              : null,
        )),
      ],
    );

    return Container(
      alignment: Alignment.center,
      height: size,
      width: double.infinity,
      color: widget.backgroundColor,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: _editMode ? editBtns : createBtn,
        transitionBuilder: (childWidget, parentAnim) {
          Animation anim =
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(parentAnim);

          return SlideTransition(
            position: anim,
            child: childWidget,
          );
        },
      ),
    );
  }

  /// Builds the button aesthetics to be used for the footer
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
