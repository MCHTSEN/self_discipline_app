// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HabitCreationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HabitCreationPage(),
      );
    },
    HabitEditingRoute.name: (routeData) {
      final args = routeData.argsAs<HabitEditingRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HabitEditingPage(
          key: args.key,
          habit: args.habit,
        ),
      );
    },
    HabitRecommendationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HabitRecommendationPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    IdentifyRoute.name: (routeData) {
      final args = routeData.argsAs<IdentifyRouteArgs>(
          orElse: () => const IdentifyRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IdentifyPage(
          key: args.key,
          onComplete: args.onComplete,
        ),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainPage(),
      );
    },
    OnboardingRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OnboardingPage(
          key: args.key,
          pages: args.pages,
          showBackButtons: args.showBackButtons,
          showNextButtons: args.showNextButtons,
          onComplete: args.onComplete,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    StatsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StatsPage(),
      );
    },
  };
}

/// generated route for
/// [HabitCreationPage]
class HabitCreationRoute extends PageRouteInfo<void> {
  const HabitCreationRoute({List<PageRouteInfo>? children})
      : super(
          HabitCreationRoute.name,
          initialChildren: children,
        );

  static const String name = 'HabitCreationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HabitEditingPage]
class HabitEditingRoute extends PageRouteInfo<HabitEditingRouteArgs> {
  HabitEditingRoute({
    Key? key,
    required HabitEntity habit,
    List<PageRouteInfo>? children,
  }) : super(
          HabitEditingRoute.name,
          args: HabitEditingRouteArgs(
            key: key,
            habit: habit,
          ),
          initialChildren: children,
        );

  static const String name = 'HabitEditingRoute';

  static const PageInfo<HabitEditingRouteArgs> page =
      PageInfo<HabitEditingRouteArgs>(name);
}

class HabitEditingRouteArgs {
  const HabitEditingRouteArgs({
    this.key,
    required this.habit,
  });

  final Key? key;

  final HabitEntity habit;

  @override
  String toString() {
    return 'HabitEditingRouteArgs{key: $key, habit: $habit}';
  }
}

/// generated route for
/// [HabitRecommendationPage]
class HabitRecommendationRoute extends PageRouteInfo<void> {
  const HabitRecommendationRoute({List<PageRouteInfo>? children})
      : super(
          HabitRecommendationRoute.name,
          initialChildren: children,
        );

  static const String name = 'HabitRecommendationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IdentifyPage]
class IdentifyRoute extends PageRouteInfo<IdentifyRouteArgs> {
  IdentifyRoute({
    Key? key,
    VoidCallback? onComplete,
    List<PageRouteInfo>? children,
  }) : super(
          IdentifyRoute.name,
          args: IdentifyRouteArgs(
            key: key,
            onComplete: onComplete,
          ),
          initialChildren: children,
        );

  static const String name = 'IdentifyRoute';

  static const PageInfo<IdentifyRouteArgs> page =
      PageInfo<IdentifyRouteArgs>(name);
}

class IdentifyRouteArgs {
  const IdentifyRouteArgs({
    this.key,
    this.onComplete,
  });

  final Key? key;

  final VoidCallback? onComplete;

  @override
  String toString() {
    return 'IdentifyRouteArgs{key: $key, onComplete: $onComplete}';
  }
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingPage]
class OnboardingRoute extends PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({
    Key? key,
    required List<Widget> pages,
    List<bool>? showBackButtons,
    List<bool>? showNextButtons,
    VoidCallback? onComplete,
    List<PageRouteInfo>? children,
  }) : super(
          OnboardingRoute.name,
          args: OnboardingRouteArgs(
            key: key,
            pages: pages,
            showBackButtons: showBackButtons,
            showNextButtons: showNextButtons,
            onComplete: onComplete,
          ),
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const PageInfo<OnboardingRouteArgs> page =
      PageInfo<OnboardingRouteArgs>(name);
}

class OnboardingRouteArgs {
  const OnboardingRouteArgs({
    this.key,
    required this.pages,
    this.showBackButtons,
    this.showNextButtons,
    this.onComplete,
  });

  final Key? key;

  final List<Widget> pages;

  final List<bool>? showBackButtons;

  final List<bool>? showNextButtons;

  final VoidCallback? onComplete;

  @override
  String toString() {
    return 'OnboardingRouteArgs{key: $key, pages: $pages, showBackButtons: $showBackButtons, showNextButtons: $showNextButtons, onComplete: $onComplete}';
  }
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StatsPage]
class StatsRoute extends PageRouteInfo<void> {
  const StatsRoute({List<PageRouteInfo>? children})
      : super(
          StatsRoute.name,
          initialChildren: children,
        );

  static const String name = 'StatsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
