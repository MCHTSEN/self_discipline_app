import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class BottomCompletionAnimation extends StatefulWidget {
  const BottomCompletionAnimation({Key? key}) : super(key: key);

  @override
  State<BottomCompletionAnimation> createState() =>
      _BottomCompletionAnimationState();
}

class _BottomCompletionAnimationState extends State<BottomCompletionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _controller.reverse().then((_) {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      });
    });
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
