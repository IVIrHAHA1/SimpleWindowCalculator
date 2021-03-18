import 'package:flutter/material.dart';

class PopUpTextField extends StatefulWidget {
  final String hint;
  final TextStyle hintStyle;
  final bool Function(String) validator;
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

  /// Whether the widget has expanded or not
  bool _expanded;

  /// How much the icon rises when activated
  Animation _rise;

  /// The transition opacity of the icon
  Animation _iconOpacity;

  /// The opacity of the text field
  Animation _textOpacity;

  /// The width of the widget when expanded
  Animation _expand;

  _PopUpTextFieldState() {
    this._expanded = false;
  }

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
    _controller.dispose();
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
    return Container(
      height: _maxHeight,
      child: Row(
        /// TODO: ALLOW USER TO SET TO EXPAND LEFT OR RIGHT
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: _maxWidth,
            ),
            child: Card(
              elevation: _rise.value,
              color: widget.fillColor,
              shadowColor: Colors.black,
              shape: !(_expand.value > 0)
                  ? CircleBorder(
                      side: widget.borderSide,
                    )
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
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
                        _expanded
                            ? _controller.forward()
                            : _controller.reverse();
                        _expanded = !_expanded;
                      },
                      child: SizedBox(
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: widget.icon,
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
                        child: TextField(
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            hintText: widget.hint,
                            hintStyle: widget.hintStyle,
                            border: InputBorder.none,
                          ),
                        ),
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
