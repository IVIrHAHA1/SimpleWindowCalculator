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
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                alignment: Alignment.center,
                height: size * .7,
                child: MaterialButton(
                  onPressed: () {
                    /// TODO: HANDLE MODE CHANGE
                  },
                  child: Text(
                    "Edit Mode",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(GlobalValues.cornerRadius),
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
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

  Container buildBody(double size, BuildContext context) {
    var imageSize = MediaQuery.of(context).size.width / 4;
    return Container(
      color: widget.backgroundColor,
      //height: size,
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
                    return Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image:
                                        Imager.fromFile(element.getImageFile())
                                            .masterImage
                                            .image,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.blue,
                                    onLongPress: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return WindowObjectScreen(
                                                window: element);
                                          },
                                        ),
                                      );
                                    },
                                    onTap: () {
                                      widget.addWindow(element);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 0,
                              child: Text('${element.name.toLowerCase()}'),
                            ),
                          ],
                        ),
                      ),
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
