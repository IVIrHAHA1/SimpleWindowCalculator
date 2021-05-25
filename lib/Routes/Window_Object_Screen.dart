import '../GlobalValues.dart';
import '../Pages/OptionsModal.dart';
import '../Tools/DatabaseProvider.dart';
import '../Tools/ImageLoader.dart';
import '../Util/ItemsManager.dart';
import '../widgets/DetailInputBox.dart';
import 'package:common_tools/StringFormater.dart' as formatter;
import 'package:shared_preferences/shared_preferences.dart';

import '../objects/Window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';

/// Window screen which allows user to create or edit window objects
class WindowObjectScreen extends StatefulWidget {
  /// NON-NULL if nothing to input, input a blank window object
  /// ```dart
  /// new WindowObjectScreen(Window());
  /// ```
  ///
  final Window window;

  WindowObjectScreen({this.window});

  @override
  _WindowObjectScreenState createState() => _WindowObjectScreenState(window);
}

class _WindowObjectScreenState extends State<WindowObjectScreen> {
  String name;
  Duration duration;
  double price = 0;

  Imager imager = Imager();
  TextStyle textStyle, hintStyle;

  bool missingName = false,
      missingDuration = false,
      missingPrice = false,
      missingImage = false;

  @override
  initState() {
    super.initState();
  }

  /// Substantiate in case user is editing a Window
  _WindowObjectScreenState(Window window) {
    if (window != null) {
      this.imager.masterFile = window.getImageFile();
      this.name = window.name;
      this.duration = window.duration;
      this.price = window.price;
    }
  }

  @override
  Widget build(BuildContext context) {
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

    this.textStyle = Theme.of(context).textTheme.button.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );

    this.hintStyle = Theme.of(context).textTheme.button.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );

    AppBar appBar = AppBar(
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      centerTitle: true,
      title: Text(
        name != null ? name.toUpperCase() : 'CREATE WINDOW',
        style: Theme.of(context).textTheme.headline6,
      ),

      // Cancel Creation/Deletion
      leading: IconButton(
        icon: Icon(
          Icons.highlight_off,
        ),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      ),

      // Finished Creating/Editing
      actions: [
        IconButton(
          disabledColor: Colors.grey,
          icon: Icon(
            Icons.check_circle_outline,
          ),
          onPressed: keyBoardHeight > 0
              ? null
              : () async {
                  /// Replace window in database
                  if (widget.window != null &&
                      name != null &&
                      duration != null &&
                      price != null &&
                      imager.masterFile != null) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    Window newWindow = Window(
                      name: name,
                      duration: duration,
                      price: price,
                      image: imager.masterFile,
                    );

                    if (widget.window.name ==
                            prefs.getString(DEFAULT_WINDOW_KEY) &&
                        widget.window.name != name) {
                      prefs.setString(DEFAULT_WINDOW_KEY, name);
                    }

                    /// Update if the editing-window is currently active
                    if (ItemsManager.instance.activeItem == widget.window) {
                      Window activeItem = ItemsManager.instance.activeItem;
                      activeItem.name = name;
                      activeItem.duration = duration;
                      activeItem.price = price;
                      activeItem.image = imager.masterFile;
                    }

                    await DatabaseProvider.instance
                        .replace(widget.window, newWindow);
                    Navigator.of(context).pop();
                  }

                  /// Add window to database
                  else if (name != null &&
                      duration != null &&
                      price != null &&
                      imager.masterFile != null) {
                    await DatabaseProvider.instance.insert(
                      Window(
                        name: name,
                        duration: duration,
                        price: price,
                        image: imager.masterFile,
                      ),
                    );
                    Navigator.of(context).pop();
                  }

                  /// Otherwise, reopen screen and ask user to fix any mistakes
                  else {
                    _notifyMissing();
                  }
                },
        )
      ],
    );

    /// Size screen for keyboard-trigger animation
    double bodyHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        height: bodyHeight,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildImage(keyBoardHeight > 0 ? 0 : (bodyHeight * .5)),
            _buildInputs(bodyHeight, context)
          ],
        ),
      ),
    );
  }

  /// Helps onError messaging to communicate to user whether a name already
  /// exists in the database or not
  bool nameExists = false;

  /// Validates the name
  final _maxInputLength = 16;
  final _minInputLength = 3;
  _nameValidator(String input) async {
    if (input.length > _minInputLength && input.length < _maxInputLength) {
      nameExists = await DatabaseProvider.instance.contains(input);
      if (!nameExists) {
        name = input;
        return name;
      }
    }
    return null;
  }

  /// Validates the Price value (Could be used later perhaps)
  // ignore: unused_element
  _numberValidator(String input) {
    try {
      var parsedPrice = double.parse(input);
      price = parsedPrice;
      return '\$ ${formatter.Format.formatDouble(price, 2)}';
    } catch (Exception) {
      price = null;
      return null;
    }
  }

  _notifyMissing() {
    setState(() {
      if (name == null) missingName = true;

      if (duration == null) missingDuration = true;

      if (price == null) missingPrice = true;

      if (imager.masterFile == null) missingImage = true;
    });
  }

  Container _buildInputs(double bodyHeight, BuildContext context) {
    return Container(
      height: bodyHeight * .5,
      width: MediaQuery.of(context).size.width * .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Name Detail Box
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DetailInputBox(
                hint: name ?? 'Name',
                style: textStyle,
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: missingName ? Colors.red : Colors.white,
                  ),
                ),
                onError: (entry) {
                  if (nameExists) {
                    nameExists = false;
                    return "Unavailable";
                  } else if (entry.length <= _minInputLength) {
                    return "Too Short";
                  } else if (entry.length > _maxInputLength) {
                    return "Too Long";
                  } else {
                    return "Invalid Entry";
                  }
                },
                hintStyle: hintStyle,
                validator: _nameValidator,
              ),
              _inputTitle('name'),
            ],
          ),

          // Time Detail Box
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTimeButton(context),
              _inputTitle('mm:ss'),
            ],
          ),

          /// PRICE BOX INPUT, IF NEEDED UNCOMMENT(Also, hardcoded a price as 0 in vars)
          // Price Detail Box
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     DetailInputBox(
          //       hint: priceHint,
          //       style: textStyle,
          //       hintStyle: hintStyle,
          //       border: Border(
          //         bottom: BorderSide(
          //           width: 2,
          //           color: missingPrice ? Colors.red : Colors.white,
          //         ),
          //       ),
          //       textInputType: TextInputType.number,
          //       validator: _numberValidator,
          //     ),
          //     _inputTitle('price')
          //   ],
          // ),
        ],
      ),
    );
  }

  _inputTitle(String title) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        '$title',
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: Colors.blueGrey),
      ),
    );
  }

  // Image portion of the create a window screen
  Widget _buildImage(double size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: size,
      alignment: Alignment.center,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      child: AnimatedOpacity(
        opacity: size != 0 ? 1.0 : 0.0,
        duration: Duration(milliseconds: 200),
        child: _WindowImageInput(imager, missingImage: missingImage),
      ),
    );
  }

  /// Input field for a selection of time
  _buildTimeButton(BuildContext ctx) {
    bool isHint =
        widget.window != null && widget.window.duration == this.duration;

    return InkWell(
      child: Container(
        height: (MediaQuery.of(ctx).size.height / 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(ctx).primaryColorLight,
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: missingDuration ? Colors.red : Colors.white,
            ),
          ),
        ),
        child: duration != null
            ? Text('${_printDuration(duration)}',
                style: isHint ? hintStyle : textStyle)
            : Text('Choose Time', style: hintStyle),
      ),
      onTap: () {
        _timePicker(ctx);
      },
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  _timePicker(BuildContext ctx) {
    Picker(
      builderHeader: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('minutes'),
              Text('seconds'),
            ],
          ),
        );
      },
      adapter: NumberPickerAdapter(
        data: [
          NumberPickerColumn(begin: 0, end: 100),
          NumberPickerColumn(begin: 0, end: 59),
        ],
      ),
      delimiter: [
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Text(
              ':',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
      hideHeader: false,
      selectedTextStyle: TextStyle(
        color: Colors.blue,
      ),
      textStyle: TextStyle(
        color: Colors.black,
      ),
      title: Text(
        "How long does it take to clean?",
        style: TextStyle(color: Colors.black),
      ),
      onConfirm: (Picker picker, List value) {
        int min = value[0];
        int sec = value[1];

        if (min == 0 && sec == 0) {
          setState(() {
            duration = null;
          });
        } else {
          setState(() {
            duration = Duration(
              minutes: min,
              seconds: sec,
            );
          });
        }
      },
    ).showDialog(ctx);
  }
}

/*  WINDOW IMAGE INPUT                                                         *
 * --------------------------------------------------------------------------- */
/// Controls the image view
class _WindowImageInput extends StatefulWidget {
  final Imager _imageController;
  final bool missingImage;

  _WindowImageInput(this._imageController, {this.missingImage = false});

  @override
  _WindowImageInputState createState() =>
      _WindowImageInputState(this._imageController.masterImage);
}

class _WindowImageInputState extends State<_WindowImageInput> {
  Image windowImage;

  _WindowImageInputState(this.windowImage);

  void _selectCapureType() {
    Navigator.push(context, OptionsModal(optionListener: _obtainImageFile));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectCapureType,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
          GlobalValues.cornerRadius,
        )),
        child: windowImage == null
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('No Image Available'),
                      ),
                    ),
                    Flexible(
                      child: Icon(
                        Icons.camera_alt,
                        color: widget.missingImage ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(GlobalValues.cornerRadius),
                  image: DecorationImage(
                    image: windowImage.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }

  void _obtainImageFile(ImagerMechanism method) async {
    final savedImage = await widget._imageController
        .getPicture(method, maxWidth: 600, maxHeight: 600);

    if (savedImage != null) {
      setState(() {
        windowImage = savedImage;
      });
    }
  }
}
