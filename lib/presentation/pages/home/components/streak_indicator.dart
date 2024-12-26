import 'package:flutter/material.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';

class StreakIndicator extends StatelessWidget {
  final int streak;

  const StreakIndicator({
    required this.streak,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ProjectPaddingType
          .xSmallPadding.symmetricHorizontalAndHalfVerticalPadding,
      decoration: BoxDecoration(
        color: AppSecondaryColors.liquidLava,
        borderRadius: ProjectRadiusType.defaultRadius.allRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${streak} Days🔗',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppSecondaryColors.snow,
                ),
          ),
        ],
      ),
    );
  }
}
