import 'package:flutter/material.dart';

class SpotlightText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final double spotRadius;
  final bool repeat;

  const SpotlightText({
    Key? key,
    required this.text,
    this.style,
    this.duration = const Duration(seconds: 3),
    this.spotRadius = 0.3, // Spot ışığının yarıçapı
    this.repeat = true, // Animasyon tekrar etsin mi
  }) : super(key: key);

  @override
  _SpotlightTextState createState() => _SpotlightTextState();
}

class _SpotlightTextState extends State<SpotlightText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // 0 -> 1 aralığında bir animasyon
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Animasyon bittikçe tekrar başa alsın istersen:
    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder, animasyonun her değerinde ShaderMask’i yeniden çiziyor
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            // Spot ışığının merkezini hesaplarken, soldan sağa kaydırmak için
            // x konumunu animasyon değerine göre ayarlıyoruz
            final centerX = bounds.width * _animation.value;
            final centerY = bounds.height / 2;

            // RadialGradient kullanarak dairesel bir alanı "aydınlık" bırakacağız
            return RadialGradient(
              center: Alignment(
                // 0 => en solda, 1 => en sağda
                _animation.value * 2 - 1, // -1 ile 1 arası (daha geniş hareket)
                0.0, // Yukarıdan aşağıya ortalasın diye 0
              ),
              radius: widget.spotRadius,
              colors: [
                // Merkezde beyaz (tam görünüm),
                // dışta siyah (karartma) - fakat BlendMode srcATop ile
                // siyah kısım aslında metni karartacak şekilde çalışıyor
                Colors.white,
                Colors.black,
              ],
              stops: const [0.0, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style ?? const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
