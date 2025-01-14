import 'dart:ui';

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

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
    close();
  }

  void close() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
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
