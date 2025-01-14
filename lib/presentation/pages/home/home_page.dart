import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/core/utils/logger.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/pages/home/components/daily_streak_widget.dart';
import 'package:self_discipline_app/presentation/pages/home/components/habits_section.dart';
import 'package:self_discipline_app/presentation/pages/home/components/header_section.dart';
import 'package:self_discipline_app/presentation/pages/home/components/performance_widget.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'package:self_discipline_app/presentation/widgets/dotted_divider.dart';
import 'package:self_discipline_app/presentation/widgets/predict_line_chart.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final habitListState = ref.watch(habitListProvider);
    final formattedCurrentMonth = DateFormat.MMMM().format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(context),
                  Gap.normal,
                  _dailyStreakAndYearlyProgress(formattedCurrentMonth, context),
                  Gap.normal,
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: _buildHabitsSection(habitListState),
            ),
          ],
        ),
      ),
    );
  }

  Container _dailyStreakAndYearlyProgress(
      String formattedCurrentMonth, BuildContext context) {
    return Container(
      margin: ProjectPaddingType.defaultPadding.symmetricHorizontalPadding,
      padding: ProjectPaddingType.defaultPadding.allPadding,
      decoration: BoxDecoration(
        borderRadius: ProjectRadiusType.extraLargeRadius.allRadius,
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formattedCurrentMonth),
          _buildStreakCard(context),
          Gap.low,
          Row(
            children: [
              Expanded(
                  child:
                      Divider(color: Colors.black, thickness: 1, endIndent: 5)),
              Text("Küçük adımlar, büyük değişimlere yol açar.",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic)),
              Expanded(
                  child: Divider(color: Colors.black, thickness: 1, indent: 5)),
            ],
          ),
          Gap.low,
          Row(
            children: [
              _buildProgressCard(context),
              Gap.low,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PerformanceWidget(type: PerformanceMetricType.improvement),
                    Gap.extraLow,
                    DottedDivider(),
                    Gap.extraLow,
                    PerformanceWidget(type: PerformanceMetricType.streak),
                    Gap.extraLow,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      margin: ProjectPaddingType.defaultPadding.symmetricHorizontalPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(105, 245, 15, 237),
            AppSecondaryColors.liquidLava.withOpacity(0.4),
            Color.fromARGB(94, 245, 15, 203).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.6, 0.99],
        ),
        borderRadius: ProjectRadiusType.extraLargeRadius.allRadius,
        boxShadow: [
          BoxShadow(
            color: AppSecondaryColors.liquidLava.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: AppSecondaryColors.liquidLava.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: const HeaderSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: ProjectRadiusType.extraLargeRadius.bottomLeftRightRadius,
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: const DailyStreakWidget(),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      width: 200,
      height: 130,
      child: LineChartSample5(),
    );
  }

  Widget _buildHabitsSection(AsyncValue<List<HabitEntity>> habitListState) {
    return habitListState.when(
      data: (habits) => HabitsSection(
        habits: habits,
        onCompleteHabit: (habitId) {
          Logger.info('Completing habit: $habitId');
          ref.read(habitListProvider.notifier).completeHabit(habitId, context);
        },
        onUncompleteHabit: (habitId) {
          Logger.info('Uncompleting habit: $habitId');
          ref.read(habitListProvider.notifier).uncompleteHabit(habitId);
        },
        onQuantityAdd: (habitId, quantity) {
          Logger.info('Updating quantity for habit: $habitId to $quantity');
          ref
              .read(habitListProvider.notifier)
              .updateQuantity(habitId, quantity, context);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
