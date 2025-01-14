import 'package:flutter/material.dart';

class CircularSpotlightText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  /// Spot ışığı yarıçapının, metnin bulunduğu kutuya oranı.
  /// 1.0 => kutunun tamamı kadar,
  /// 0.5 => kutunun yarıçapı kadar vb.
  final double circleScale;

  /// Dairesel gradyanın beyazdan siyaha geçmeye başladığı nokta (0..1)
  final double fadeStart;

  /// Beyazdan siyaha geçişin bittiği nokta (fadeStart <= fadeEnd <= 1)
  final double fadeEnd;

  const CircularSpotlightText({
    Key? key,
    required this.text,
    this.style,
    this.circleScale = 0.5,
    this.fadeStart = 0.4,
    this.fadeEnd = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.center,
          radius: circleScale,
          colors: const [
            Colors.white,
            Colors.black,
          ],
          stops: [
            fadeStart,
            fadeEnd,
          ],
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: style ?? const TextStyle(fontSize: 28, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
