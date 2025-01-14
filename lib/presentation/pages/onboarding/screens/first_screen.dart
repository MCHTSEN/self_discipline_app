import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/presentation/viewmodels/onboarding_provider.dart';

class FirstScreen extends ConsumerStatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends ConsumerState<FirstScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _containerController;
  late Animation<double> _containerAnimation;

  // Hangi metinlerin gösterileceğini kontrol için bir index tutuyoruz
  int _currentIndex = 0;

  // Animasyon kontrolü için bir liste oluşturuyoruz.
  // Her metin için başlangıçta görünürlük 0 (şeffaf).
  List<double> _opacityValues = [];
  bool _isDisposed = false;
  final int _textCount = 7;

  @override
  void initState() {
    super.initState();
    _opacityValues = List.filled(_textCount, 0.0); // 6 tane metin için opacity değerleri

    // Container animasyonu için controller
    _containerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _containerAnimation = Tween<double>(
      begin: 0.0,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: Curves.easeOut,
    ));

    _showTextsSequentially();
    _containerController.forward();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _containerController.dispose();
    super.dispose();
  }

  Future<void> _showTextsSequentially() async {
    // Her metni 1 saniye arayla göstermek için Future.delayed kullanıyoruz.
    for (int i = 0; i < _textCount; i++) {
      if (_isDisposed) return;
      await Future.delayed(const Duration(seconds: 1));
      if (_isDisposed) return;
      if (mounted) {
        setState(() {
          _currentIndex = i;
          _opacityValues[i] = 1.0; // i. metin görünür olsun
        });
      }
    }

    // Tüm metinler gösterildikten sonra
    if (!_isDisposed) {
      await Future.delayed(const Duration(seconds: 1));
      ref.read(onboardingAnimationProvider.notifier).setAnimationComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            bottom: -100,
            left: -200,
            child: AnimatedBuilder(
              animation: _containerAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white
                              .withOpacity(_containerAnimation.value),
                          blurRadius: 100,
                        )
                      ],
                      color:
                          Colors.white.withOpacity(_containerAnimation.value),
                      shape: BoxShape.circle),
                  height: _containerAnimation.value * 3000,
                  width: _containerAnimation.value * 3000,
                );
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _opacityValues[0],
                  child: _TextWidget(text: "Her yıl"),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _opacityValues[1],
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius:
                          ProjectRadiusType.extraLargeRadius.allRadius,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(232, 0, 119, 255)
                              .withOpacity(_containerAnimation.value),
                          Color.fromARGB(230, 123, 237, 255)
                              .withOpacity(_containerAnimation.value),
                        ],
                      ),
                    ),
                    child: _TextWidget(text: "32.9 kat"),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _opacityValues[2],
                  child: _TextWidget(text: "büyü"),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _opacityValues[3],
                  child: _TextWidget(text: "sadece"),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _opacityValues[4],
                  child: _TextWidget(text: "günde"),
                ),
                AnimatedBuilder(
                  animation: _containerAnimation,
                  builder: (context, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width *
                          _containerAnimation.value /
                          3,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius:
                            ProjectRadiusType.extraLargeRadius.allRadius,
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(232, 0, 17, 255)
                                .withOpacity(_containerAnimation.value),
                            Color.fromARGB(230, 123, 237, 255)
                                .withOpacity(_containerAnimation.value),
                          ],
                        ),
                      ),
                      child: Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: _opacityValues[5],
                          child: _TextWidget(text: "%1"),
                        ),
                      ),
                    );
                  },
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _opacityValues[6],
                  child: _TextWidget(text: "çalışarak"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextWidget extends StatelessWidget {
  final String text;
  const _TextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 44),
    );
  }
}
