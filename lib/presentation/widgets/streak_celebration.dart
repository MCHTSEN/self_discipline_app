import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/presentation/viewmodels/streak_celebration_provider.dart';

class StreakCelebration extends ConsumerWidget {
  const StreakCelebration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final celebrationState = ref.watch(streakCelebrationProvider);

    if (!celebrationState.isShowing) return const SizedBox.shrink();

    return Stack(
      children: [
        // Yarı saydam arka plan
        Container(
          color: Colors.black54,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lotties/celebration.json',
                width: 200,
                height: 200,
                repeat: true,
              ),
              const SizedBox(height: 16),
              Text(
                '🎉 Incredible! ${celebrationState.streak} Day Streak! 🎉',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Keep up the great work!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
