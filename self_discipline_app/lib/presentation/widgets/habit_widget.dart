import 'dart:math';
import 'package:flutter/material.dart';

import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/pages/home/components/flame_animation.dart';

class HabitWidget extends StatefulWidget {
  final Color? color;
  final String title;
  final int durationInMinutes;
  final String icon;
  const HabitWidget({
    super.key,
    this.color,
    required this.title,
    required this.durationInMinutes,
    required this.icon,
  });

  @override
  _HabitWidgetState createState() => _HabitWidgetState();
}

class _HabitWidgetState extends State<HabitWidget> {
  bool isCompleted = false;

  void _toggleCompleted() {
    setState(() {
      isCompleted = !isCompleted;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isCompleted = false;
      });
    });
  }

  Color _getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double height = 50;
    final Color color = widget.color ?? _getRandomColor();

    return isCompleted
        ? FittedBox(
            fit: BoxFit.cover,
            child: CustomLottie.explosion.toWidget(width: 100, height: 100))
        : AnimatedContainer(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: color),
              color: const Color.fromARGB(96, 68, 68, 68),
              borderRadius: ProjectRadiusType.defaultRadius.allRadius,
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 224, 255, 132).withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 100),
            child: Row(
              children: [
                AnimatedContainer(
                  height: height,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: ProjectRadiusType.defaultRadius.allRadius,
                      border: Border.all(color: color),
                      color: color),
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Text(
                      widget.icon,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Gap.normal,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 0.9),
                    ),
                    Text(
                      '${widget.durationInMinutes} min',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  color: Colors.black,
                  onPressed: _toggleCompleted,
                ),
              ],
            ),
          );
  }
}
