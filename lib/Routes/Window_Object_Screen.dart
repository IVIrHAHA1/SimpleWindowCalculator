import 'package:SimpleWindowCalculator/Tools/DatabaseProvider.dart';
import 'package:SimpleWindowCalculator/Tools/ImageLoader.dart';
import 'package:common_tools/StringFormater.dart' as formatter;

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
  double price;

  Imager imager = Imager();
  TextStyle textStyle, hintStyle;

  static const Border inputBorder = const Border(
    bottom: BorderSide(width: 2, color: Colors.white),
  );

  @override
  initState() {
    super.initState();
  }

  /// Substantiate in case user is editing a Window
  _WindowObjectScreenState(Window window) {
    if (window != null) {
      print('default asigned');
      this.imager.masterFile = window.getImageFile();
      this.name = window.name;
      this.duration = window.duration;
      this.price = window.price;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.textStyle = Theme.of(context).textTheme.button.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );

    this.hintStyle = Theme.of(context).textTheme.button.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );

    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        name ?? 'Create Window',
        style: Theme.of(context).textTheme.headline6,
      ),

      // Cancel Creation/Deletion
      leading: IconButton(
        icon: Icon(
          Icons.highlight_off,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),

      // Finished Creating/Editing
      actions: [
        IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          ),
          onPressed: () async {
            /// If window object is acceptible, then add to database
            if (widget.window != null &&
                name != null &&
                duration != null &&
                price != null &&
                imager.masterFile != null) {
                  widget.window.name = name;
                  widget.window.duration = duration;
                  widget.window.price = price;
                  widget.window.image = imager.masterFile;

                  await DatabaseProvider.instance.insert(widget.window);
                }

            else if (name != null &&
                duration != null &&
                price != null &&
                imager.masterFile != null) {
              await DatabaseProvider.instance.insert(Window(
                name: name,
                duration: duration,
                price: price,
                image: imager.masterFile,
              ));
            }

            /// Otherwise, reopen screen and ask user to fix any mistakes
            DatabaseProvider.instance.insert(widget.window);
            Navigator.of(context).pop();
          },
        )
      ],
    );

    /// Size screen for keyboard-trigger animation
    double bodyHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    double keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        alignment: Alignment.center,
        height: bodyHeight,
        child: Column(
          children: [
            _buildImage(keyBoardHeight > 0 ? 0 : (bodyHeight * .5)),
            _buildInputs(bodyHeight, context)
          ],
        ),
      ),
    );
  }

  Container _buildInputs(double bodyHeight, BuildContext context) {
    String priceHint =
        price != null ? formatter.Format.formatDouble(price, 2) : 'Price';

    return Container(
      height: bodyHeight * .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _dataInputFields(
              hint: name ?? 'Name',
              userInput: (input) {
                if (input.length > 0) {
                  name = input;
                }
                return name;
              }),
          _buildTimeButton(context),
          _dataInputFields(
            hint: priceHint,
            keyboardType: TextInputType.number,
            userInput: (input) {
              try {
                var parsedPrice = double.parse(input);
                price = parsedPrice;
                return '\$ ${formatter.Format.formatDouble(price, 2)}';
              } catch (Exception) {
                price = null;
                priceHint = 'Not a valid number';
                return null;
              }
            },
          ),
        ],
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
      child: _WindowImageInput(imager),
    );
  }

  // CREATE DATA INPUT FIELDS
  /// Input field for name and price
  _dataInputFields({
    var hint,
    TextInputType keyboardType,
    Function(String input) userInput,
  }) {
    return DetailInputBox(
      hint: hint,
      style: textStyle,
      hintStyle: hintStyle,
      textInputType: keyboardType,
      validator: userInput,
    );
  }

  /// Input field for a selection of time
  MaterialButton _buildTimeButton(BuildContext ctx) {
    return MaterialButton(
      child: Container(
        height: (MediaQuery.of(ctx).size.height / 16),
        width: MediaQuery.of(ctx).size.width * .5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(ctx).primaryColorLight,
          border: inputBorder,
        ),
        child: duration != null
            ? Text('${_printDuration(duration)}', style: textStyle)
            : Text('Choose Time', style: hintStyle),
      ),
      onPressed: () {
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

class _WindowImageInput extends StatefulWidget {
  final Imager _imageController;

  _WindowImageInput(this._imageController);

  @override
  _WindowImageInputState createState() =>
      _WindowImageInputState(this._imageController.masterImage);
}

class _WindowImageInputState extends State<_WindowImageInput> {
  Image windowImage;

  _WindowImageInputState(this.windowImage);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _obtainImageFile,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: windowImage == null
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('No Image Available'),
                    ),
                    Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                  ],
                ),
              )
            : Center(child: windowImage),
      ),
    );
  }

  /// Open camera or (TODO:gallery) to get an image to preview window object
  void _obtainImageFile() async {
    final savedImage = await widget._imageController
        .takePicture(maxWidth: 600, maxHeight: 600);

    if (savedImage != null) {
      setState(() {
        windowImage = savedImage;
      });
    }
  }
}

/*  DETAIL INPUT BOX WIDGET                                                    *
 * --------------------------------------------------------------------------- */
/// Text input boxes where necessary Window details will be gathered from user
class DetailInputBox extends StatefulWidget {
  final String text;
  final String hint;

  /// Message to display when [validator] returns false
  final String errorMessage;

  /// Validate input, if invalid [DetailInputBox] will display [errorMessage]
  final Function(String value) validator;
  final TextStyle style;
  final TextStyle hintStyle;
  final TextInputType textInputType;

  DetailInputBox({
    this.text,
    this.hint,
    this.errorMessage,
    this.style,
    this.hintStyle,
    @required this.validator,
    this.textInputType = TextInputType.text,
  });

  @override
  _DetailInputBoxState createState() => _DetailInputBoxState(text, hint);
}

class _DetailInputBoxState extends State<DetailInputBox> {
  String text, hint;
  String onError;

  // focused node validates the input text
  FocusNode _myFocusNode;
  TextEditingController _controller;

  _DetailInputBoxState(this.text, this.hint);

  @override
  void initState() {
    _controller = TextEditingController();
    _myFocusNode = FocusNode();
    _myFocusNode.addListener(() {
      if (!_myFocusNode.hasFocus) {
        String paramText = widget.validator(_controller.text);

        if (paramText != null) {
          // VALIDATED
          /// Updates TextField to output validated result as a hint
          /// abiding by the [text] parameters and style. Remove text
          /// from the controller to allow valid hint to show.
          setState(() {
            text = paramText;
            _controller.text = '';
            onError = null;
          });
        }
        // CONTROLLER HAD NO ENTRY
        /// Absorb no entry, that way to error is produced. Probably a
        /// better way to implement this, but this way is clear what is
        /// happening.
        else if (_controller.text.length <= 0) {
          setState(() {
            _controller.text = '';
            onError = null;
          });
        }
        // INVALID
        /// User entered an invalid input, use TextField's default
        /// error messaging. Keep text in [_controller] to let user
        /// update any errors.
        else {
          text = null;
          onError = widget.errorMessage ?? "Invalid Entry";
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: (MediaQuery.of(context).size.height / 16),
        width: MediaQuery.of(context).size.width * .5,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          border: _WindowObjectScreenState.inputBorder,
        ),
        child: TextField(
          keyboardType: widget.textInputType,
          style: widget.style,
          controller: _controller,
          textAlign: TextAlign.center,
          focusNode: _myFocusNode,
          decoration: _getInputDecoration(),
        ),
      ),
    );
  }

  // Decoration for TextField
  InputDecoration _getInputDecoration() {
    return InputDecoration(
      hintText: text ?? hint,
      hintStyle: text != null ? widget.style : widget.hintStyle,
      errorText: onError,
      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      border: InputBorder.none,
    );
  }
}
