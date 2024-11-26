import 'package:flutter/material.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';

class BaseBackground extends StatelessWidget {
  final Widget child;
  BorderRadiusGeometry? borderRadius;
  BaseBackground({
    super.key,
    required this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.11, 1.0],
          colors: [
            AppColors.backgroundDark,
            Color.fromARGB(255, 28, 28, 28),
            Color.fromARGB(255, 0, 0, 0),
          ],
        ),
      ),
      child: child,
    );
  }
}
