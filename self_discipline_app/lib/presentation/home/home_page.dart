import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/home/components/flame_animation.dart';
import 'package:self_discipline_app/presentation/widgets/base_background.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: ProjectPaddingType.defaultPadding.allPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nameAndStreak(context),
                _quote(context),
                Gap.extraHigh,
                
              
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _quote(BuildContext context) {
    return Text(
                'Small steps lead to big changes.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: AppColors.textSecondaryDark),
              );
  }

  Row _nameAndStreak(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Hello, Mucahit',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Container(
          padding: ProjectPaddingType
              .smallPadding.symmetricHorizontalAndHalfVerticalPadding,
          decoration: BoxDecoration(
            color: const Color(0xffE7FF55),
            borderRadius: ProjectRadiusType.defaultRadius.allRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '5 Days Streak',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black),
              ),
              CustomLottie.flame.toWidget,
            ],
          ),
        ),
      ],
    );
  }
}
