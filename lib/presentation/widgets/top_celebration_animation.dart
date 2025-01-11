import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:self_discipline_app/core/helper/gap.dart';

class TopCelebrationAnimation extends StatefulWidget {
  const TopCelebrationAnimation({Key? key}) : super(key: key);

  @override
  State<TopCelebrationAnimation> createState() =>
      _TopCelebrationAnimationState();
}

class _TopCelebrationAnimationState extends State<TopCelebrationAnimation> {
  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.1),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Lottie.asset('assets/lotties/big_celebration.json',
                  width: MediaQuery.of(context).size.width,
                  repeat: true,
                  fit: BoxFit.cover),
              const SizedBox(height: 8),
              Text(
                'Tüm Görevler Tamamlandı! 🎉',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.purple, fontWeight: FontWeight.bold),
              ),
              Gap.normal,
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tamam')),
              Gap.extraExtraHigh,
            ],
          ),
        ),
      ),
    );
  }
}
