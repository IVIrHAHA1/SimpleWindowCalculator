import 'package:flutter/material.dart';

/*  DETAIL INPUT BOX WIDGET                                                    *
 * --------------------------------------------------------------------------- */
/// Text input boxes where necessary Window details will be gathered from user
class DetailInputBox extends StatefulWidget {
  final String text;
  final String hint;

  /// Message to display when [validator] returns false
  final String Function(String invalidEntry) onError;

  /// Validate input, if invalid [DetailInputBox] will display [errorMessage]
  final Function(String value) validator;
  final TextStyle style;
  final TextStyle hintStyle;
  final TextInputType textInputType;
  final Border border;

  static const Border inputBorder = const Border(
    bottom: BorderSide(width: 2, color: Colors.white),
  );

  DetailInputBox({
    this.text,
    this.hint,
    this.onError,
    this.style,
    this.hintStyle,
    @required this.validator,
    this.border = inputBorder,
    this.textInputType = TextInputType.text,
  });

  @override
  _DetailInputBoxState createState() => _DetailInputBoxState(text, hint);
}

class _DetailInputBoxState extends State<DetailInputBox> {
  String text, hint;
  String onErrorMsg;

  // focused node validates the input text
  FocusNode _myFocusNode;
  TextEditingController _controller;

  _DetailInputBoxState(this.text, this.hint);

  @override
  void initState() {
    _controller = TextEditingController();
    _myFocusNode = FocusNode();
    _myFocusNode.addListener(() async {
      if (!_myFocusNode.hasFocus) {
        String paramText = await widget.validator(_controller.text);

        if (paramText != null) {
          // VALIDATED
          /// Updates TextField to output validated result as a hint
          /// abiding by the [text] parameters and style. Remove text
          /// from the controller to allow valid hint to show.
          setState(() {
            text = paramText;
            _controller.text = '';
            onErrorMsg = null;
          });
        }
        // CONTROLLER HAD NO ENTRY
        /// Absorb no entry, that way no error is produced. Probably a
        /// better way to implement this, but this way is clear what is
        /// happening.
        else if (_controller.text.length <= 0) {
          setState(() {
            _controller.text = '';
            onErrorMsg = null;
          });
        }
        // INVALID
        /// User entered an invalid input, use TextField's default
        /// error messaging. Keep text in [_controller] to let user
        /// update any errors.
        else {
          text = null;
          onErrorMsg = widget.onError != null
              ? widget.onError(_controller.text)
              : "Invalid Entry";
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
        alignment: Alignment.center,
        height: (MediaQuery.of(context).size.height / 16),
        width: MediaQuery.of(context).size.width * .5,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          border: widget.border,
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
      errorText: onErrorMsg,
      contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      border: InputBorder.none,
    );
  }
}
