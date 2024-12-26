import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:self_discipline_app/presentation/pages/habit_creation_page.dart';
import 'package:self_discipline_app/presentation/pages/home/home_page.dart';
import 'package:self_discipline_app/presentation/pages/habit_list_page.dart';
import 'package:self_discipline_app/presentation/pages/main/main_page.dart';
import 'package:self_discipline_app/core/router/route_transitions.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: MainRoute.page,
          initial: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          children: [
            CustomRoute(
              page: HomeRoute.page,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                );
              },
            ),
            CustomRoute(
              page: HabitListRoute.page,
              transitionsBuilder: RouteTransitions.scaleTransition,
            ),
            CustomRoute(
              page: HabitCreationRoute.page,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    )),
                    child: child,
                  ),
                );
              },
              durationInMilliseconds: 400,
              reverseDurationInMilliseconds: 400,
            ),
          ],
        ),
      ];
}
