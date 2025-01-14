import 'package:flutter/material.dart';

class LightBeamPainter extends CustomPainter {
  final Offset target; // Işığın ulaşacağı hedefin merkezi
  final double beamWidth; // Işık huzmesinin yarı genişliği
  final Color color; // Işık huzmesinin rengi

  LightBeamPainter({
    required this.target,
    this.beamWidth = 80.0,
    this.color = Colors.yellow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Kaynak noktasını: Ekranın üst ortası seçiyoruz
    final source = Offset(size.width / 2, 0);

    // Işık demetinin sol ve sağ kenarlarını tanımla:
    // (target.x ± beamWidth, target.y)
    final leftPoint = Offset(target.dx - beamWidth, target.dy);
    final rightPoint = Offset(target.dx + beamWidth, target.dy);

    // Üçgen (veya dar bir trapez) şeklinde path çiziyoruz
    final path = Path()
      ..moveTo(source.dx, source.dy) // üst merkez
      ..lineTo(leftPoint.dx, leftPoint.dy) // hedefin sol kenarı
      ..lineTo(rightPoint.dx, rightPoint.dy) // hedefin sağ kenarı
      ..close();

    // Renk geçişli (fade) bir ışık efekti istiyorsak LinearGradient kullanabiliriz
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.0), // Kaynak ucunda tamamen şeffaf
          color.withOpacity(0.2), // Ortalarda biraz renk
          color.withOpacity(0.0), // Dilersen tekrar 0 yapabilirsin
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromPoints(source, rightPoint));

    // Path'i boya
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LightBeamPainter oldDelegate) {
    return oldDelegate.target != target ||
        oldDelegate.beamWidth != beamWidth ||
        oldDelegate.color != color;
  }
}
