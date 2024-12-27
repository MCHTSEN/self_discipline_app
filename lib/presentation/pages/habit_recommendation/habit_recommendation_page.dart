import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HabitRecommendationPage extends StatelessWidget {
  const HabitRecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: const Center(
        child: Text('Habit Recommendations - Coming Soon'),
      ),
    );
  }
}
