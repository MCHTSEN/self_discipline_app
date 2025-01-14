import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class BottomCompletionAnimation extends StatefulWidget {
  const BottomCompletionAnimation({Key? key}) : super(key: key);

  @override
  State<BottomCompletionAnimation> createState() =>
      _BottomCompletionAnimationState();
}

class _BottomCompletionAnimationState extends State<BottomCompletionAnimation> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 32),
        child: Lottie.asset('assets/lotties/small_celebration.json',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            repeat: false),
      ),
    );
  }
}
