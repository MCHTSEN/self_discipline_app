import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:self_discipline_app/presentation/viewmodels/providers.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';

class HeaderSection extends ConsumerWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Hello, Mucahit',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        if (kDebugMode) _buildClearCacheButton(context, ref),
      ],
    );
  }

  Widget _buildClearCacheButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => _clearCache(context, ref),
      icon: const Icon(Icons.cleaning_services),
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
