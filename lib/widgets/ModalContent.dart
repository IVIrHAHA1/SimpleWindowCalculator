import 'package:SimpleWindowCalculator/Routes/Window_Object_Screen.dart';
import 'package:SimpleWindowCalculator/Tools/DatabaseProvider.dart';
import 'package:SimpleWindowCalculator/GlobalValues.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';
import 'package:SimpleWindowCalculator/Tools/ImageLoader.dart';

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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return WindowObjectScreen(
            Window(
              /// TODO: DELETE THIS AFTER TESTING
              name: 'test',
              duration: Duration(minutes: 2),
              price: 12.0,
            ),
          );
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
      width: double.infinity,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        height: size * .7,
        width: MediaQuery.of(context).size.width * .4,
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
    );
  }

  Container buildBody(double size, BuildContext context) {
    var imageSize = MediaQuery.of(context).size.width / 4;
    return Container(
      color: widget.backgroundColor,
      //height: size,
      child: FutureBuilder<List<Window>>(
          initialData: OManager.presetWindows,
          future: DatabaseProvider.instance.querySearch(_textEditingController.text),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length <= 0) {
                return Container(
                  alignment: Alignment.center,
                  child: Text("no windows found by the name of ${_textEditingController.text}"),
                  height: size,
                  width: double.infinity,
                );
              } else {
                return GridView.count(
                  crossAxisCount: 3,
                  scrollDirection: Axis.vertical,
                  children: snapshot.data.map((element) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 8),
                              child: ImageLoader.fromFile(element.getImage(),
                                  borderRadius: 0),
                              width: imageSize,
                              height: imageSize,
                            ),
                            Text(element.getName()),
                          ],
                        ),
                      ),
                      onLongPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return WindowObjectScreen(element);
                            },
                          ),
                        );
                      },
                      onTap: () {
                        widget.addWindow(element);
                      },
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

  Container buildButtonFooter(double size, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size,
      width: double.infinity,
      color: widget.backgroundColor,
      child: Card(
        elevation: 4,
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => createWindow(context),
          splashColor: Theme.of(context).primaryColorLight,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * .5,
            child: Text(
              'create',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 2),
            ),
          ),
        ),
      ),
    );
  }
}
