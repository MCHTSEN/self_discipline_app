import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HabitCompletionAnimation extends StatelessWidget {
  final VoidCallback onAnimationComplete;

  const HabitCompletionAnimation({
    Key? key,
    required this.onAnimationComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black12,
        ),
        Center(
          child: Lottie.asset(
            'assets/lotties/small_success.json',
            width: 100,
            height: 100,
            repeat: false,
            onLoaded: (composition) {
              Future.delayed(composition.duration, onAnimationComplete);
            },
          ),
        ),
      ],
    );
  }
}
