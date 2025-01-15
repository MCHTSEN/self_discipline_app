import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/pages/habit_creation/habit_creation_page.dart';
import 'package:self_discipline_app/presentation/pages/habit_editing/habit_editing_page.dart';
import 'package:self_discipline_app/presentation/pages/home/home_page.dart';
import 'package:self_discipline_app/presentation/pages/onboarding/screens/identify_page.dart';
import 'package:self_discipline_app/presentation/pages/main/main_page.dart';
import 'package:self_discipline_app/presentation/pages/onboarding/onboarding_page.dart';
import 'package:self_discipline_app/presentation/pages/settings/settings_page.dart';
import 'package:self_discipline_app/presentation/pages/splash/splash_page.dart';
import 'package:self_discipline_app/presentation/pages/stats/stats_page.dart';
import 'package:self_discipline_app/presentation/pages/habit_recommendation/habit_recommendation_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: MainRoute.page,
          initial: true,
          children: [
            CustomRoute(page: HomeRoute.page),
            CustomRoute(page: StatsRoute.page),
            CustomRoute(page: HabitRecommendationRoute.page),
            CustomRoute(page: SettingsRoute.page),
          ],
        ),
        CustomRoute(page: HabitCreationRoute.page),
        CustomRoute(page: HabitEditingRoute.page),
        CustomRoute(page: OnboardingRoute.page),
        CustomRoute(page: IdentifyRoute.page),
      ];
}
