import 'package:flutter/material.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';

class HabitIconSelector extends StatelessWidget {
  final String selectedIcon;
  final Function(String) onIconSelected;

  const HabitIconSelector({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  static const List<String> availableIcons = [
    '🏃',
    '💪',
    '📚',
    '🧘‍♂️',
    '💻',
    '🎨',
    '🎵',
    '🏊‍♂️',
    '🚴‍♂️',
    '✍️',
    '🧠',
    '💤',
    '🥗',
    '💧',
    '🚭',
    '⏰',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 100,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color:
            isDarkMode ? AppSecondaryColors.gluonGrey : AppSecondaryColors.snow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppSecondaryColors.slateGrey),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: availableIcons.length,
        itemBuilder: (context, index) {
          final icon = availableIcons[index];
          final isSelected = icon == selectedIcon;

          return InkWell(
            onTap: () => onIconSelected(icon),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppSecondaryColors.liquidLava : null,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? AppSecondaryColors.liquidLava
                      : AppSecondaryColors.slateGrey,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
