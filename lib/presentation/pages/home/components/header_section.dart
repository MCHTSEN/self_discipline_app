import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/presentation/viewmodels/providers.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';

class HeaderSection extends ConsumerWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsState = ref.watch(habitListProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Mucahit',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              habitsState.when(
                data: (habits) {
                  final completedToday =
                      habits.where((h) => h.isCompletedToday).length;
                  final total = habits.length;
                  return Text(
                    '$completedToday of $total tasks completed',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        if (kDebugMode) _buildClearCacheButton(context, ref),
      ],
    );
  }

  Widget _buildClearCacheButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => _clearCache(context, ref),
      icon: const Icon(Icons.cleaning_services, color: Colors.white, size: 20),
      padding: EdgeInsets.zero,
      tooltip: 'Clear Cache (Debug)',
    );
  }

  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    final habitBox = ref.read(habitBoxProvider);
    final settingsBox = ref.read(settingsBoxProvider);

    await habitBox.clear();
    await settingsBox.clear();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cache cleared'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
