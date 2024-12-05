import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum CustomLottie {
  flame;

  String get path => 'assets/lotties/$name.json';

  Widget get toWidget => Lottie.asset(path, height: 24, width: 24);
}