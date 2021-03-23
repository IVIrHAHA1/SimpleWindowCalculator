import 'package:flutter/material.dart';

class PopUpTextField extends StatefulWidget {
  final String hint;
  final TextStyle hintStyle;
  final bool Function(String) validator;
  final void Function(String submittedText) onSubmitted;
  final TextInputType textInputType;
  final Widget icon;
  final Color fillColor;
  final Duration duration;
  final AnimationController controller;
  final BorderSide borderSide;
  final double iconHeightFactor, iconWidthFactor;

  static const double iconSizeFactor = .75;

  PopUpTextField({
    this.hint,
    this.hintStyle,
    this.validator,
    this.onSubmitted,
    this.textInputType,
    this.fillColor = Colors.white,
    this.icon,
    this.controller,
    this.duration,
    this.iconHeightFactor = iconSizeFactor,
    this.iconWidthFactor = iconSizeFactor,
    this.borderSide = BorderSide.none,
  });

  @override
  _PopUpTextFieldState createState() => _PopUpTextFieldState();
}

class _PopUpTextFieldState extends State<PopUpTextField>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  /// How much the icon rises when activated
  Animation _rise;

  /// The transition opacity of the icon
  Animation _iconOpacity;

  /// The opacity of the text field
  Animation _textOpacity;

  /// The width of the widget when expanded
  Animation _expand;

  // constraints of this widget
  double _maxHeight;
  double _maxWidth;

  @override
  void initState() {
    // Animation Controller
    _controller = widget.controller ??
        AnimationController(
          vsync: this,
          duration: widget.duration,
          reverseDuration: widget.duration,
        );

    // Build Animations
    _buildAnims();

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) this._controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      this._maxHeight = constraints.maxHeight ?? 50;
      this._maxWidth = constraints.maxWidth ?? 200;

      return AnimatedBuilder(
        animation: _controller,
        builder: (ctx, child) {
          return _buildChild();
        },
      );
    });
  }

  Widget _buildChild() {
    // Container which gives max height determined by parent Widget
    print('This is height: $_maxHeight, this is width: $_maxWidth');

    return Container(
      height: _maxHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Container constrains the Card along with children, ie Icon and TextField
          // with a maxWidth. Using BoxConstraints, allows for child resizing.
          Container(
            constraints: BoxConstraints(
                maxWidth: _maxWidth,
                minWidth:
                    _maxHeight > _maxWidth ? _maxHeight - 16 : _maxHeight),
            alignment: Alignment.centerLeft,
            width: _maxWidth * _expand.value,
            child: Card(
              elevation: _rise.value,
              color: widget.fillColor,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_maxHeight),
                side: widget.borderSide,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Image
                  Expanded(
                    flex: 0,
                    child: GestureDetector(
                      onTap: () {
                        _actualizeWidget();
                      },
                      child: SizedBox(
                        child: FractionallySizedBox(
                          heightFactor: widget.iconHeightFactor,
                          widthFactor: widget.iconWidthFactor,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Opacity(
                              opacity: _iconOpacity.value,
                              child: widget.icon,
                            ),
                          ),
                        ),
                        height: (_maxHeight * widget.iconHeightFactor) -
                            riseHeightpx +
                            _rise.value,
                        width: (_maxHeight * widget.iconWidthFactor) -
                            riseHeightpx +
                            _rise.value,
                      ),
                    ),
                  ),
                  // TextField
                  Visibility(
                    visible: _textOpacity.value > 0,
                    child: Expanded(
                      flex: 1,
                      child: Opacity(
                        opacity: _textOpacity.value,
                        child: _buildTextField(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Whether the widget has expanded or not
  bool _expanded = false;
  _actualizeWidget() {
    _expanded ? _expandWidget() : _collapseWidget();
    _expanded = !_expanded;
  }

  _expandWidget() {
    _controller.forward();
  }

  _collapseWidget() {
    _controller.reverse();
  }

  var errorString;
  Widget _buildTextField() {
    return TextField(
      autofocus: true,
      textAlign: TextAlign.end,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        hintText: widget.hint,
        hintStyle: widget.hintStyle,
        border: InputBorder.none,
        errorText: errorString,
      ),
      onSubmitted: (submittedText) {
        /// Text was acceptable
        if (widget.validator(submittedText)) {
          errorString = null;
          _controller.reverse();
          widget.onSubmitted(submittedText);
        } else {
          errorString = 'invalid entry';
        }
      },
    );
  }

  static const double expInt_s = .5, expInt_e = 1;
  static const double raiseInt_s = 0, raiseInt_e = .25;
  static const double riseHeightpx = 5.0;

  _buildAnims() {
    // Rising Animation
    _rise = Tween<double>(begin: 0, end: riseHeightpx).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(raiseInt_s, raiseInt_e, curve: Curves.decelerate),
      ),
    );

    _iconOpacity = Tween<double>(begin: .25, end: .75).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(raiseInt_s, raiseInt_e),
      ),
    );

    // Expansion Animation
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(expInt_s, expInt_e),
      ),
    );

    _expand = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          expInt_s,
          expInt_e,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}
