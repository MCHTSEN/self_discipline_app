import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum CustomLottie {
  flame,
  explosion,
  brain_explosion;

  String get path => 'assets/lotties/$name.json';

  Widget toWidget({double width = 24.0, double height = 24}) {
    return Lottie.asset(path, width: width, height: height);
  }
}
