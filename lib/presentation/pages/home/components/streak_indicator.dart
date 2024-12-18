import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/pages/home/components/flame_animation.dart';

class StreakIndicator extends ConsumerStatefulWidget {
  final String streak;
  const StreakIndicator({required this.streak, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StreakIndicatorState();
}

class _StreakIndicatorState extends ConsumerState<StreakIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ProjectPaddingType
          .xSmallPadding.symmetricHorizontalAndHalfVerticalPadding,
      decoration: BoxDecoration(
        color: AppColors.primaryYellow,
        borderRadius: ProjectRadiusType.defaultRadius.allRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${widget.streak} Days🔗',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black),
          ),
          
        ],
      ),
    );
  }
}
