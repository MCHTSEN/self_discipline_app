import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  /// The text to display and animate.
  final String text;

  /// Optional font size for the text.
  final double? fontSize;

  /// Optional color for the text.
  final Color? color;

  /// Custom [TextStyle] for text appearance.
  final TextStyle? textStyle;

  /// [AnimatedText] is a reusable widget that animates the scale of a text
  /// whenever the text value changes. Ideal for emphasizing updates in UI.
  ///
  /// ### Example Usage
  /// ```dart
  /// AnimatedText(
  ///   text: "Hello Flutter!",
  ///   fontSize: 20,
  ///   color: Colors.blue,
  /// )
  /// ```
  ///
  /// - `text`: The text to display and animate.
  /// - `fontSize`: Custom font size for the text (default: 14.0).
  /// - `color`: Custom color for the text (default: Colors.white).
  /// - `textStyle`: Custom [TextStyle] to fully control the appearance of the text.
  const AnimatedText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.textStyle,
  });

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    /// Initialize the animation controller with a duration of 200ms.
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    /// Define a scale animation that grows the text and then shrinks it back.
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_scaleController);

    /// Start the animation when the widget is first built.
    _scaleController.forward();
  }

  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Trigger the animation whenever the text changes.
    if (oldWidget.text != widget.text) {
      _scaleController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    /// Dispose the animation controller to free up resources.
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Build the animated text using [ScaleTransition].
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        widget.text,
        style: widget.textStyle ??
            TextStyle(
              fontSize: widget.fontSize ?? 14.0,
              fontWeight: FontWeight.bold,
              color: widget.color ?? Colors.white,
            ),
      ),
    );
  }
}
