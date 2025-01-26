import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_discipline_app/core/router/app_router.dart';
import 'package:self_discipline_app/core/services/app_initializer.dart';
import 'package:self_discipline_app/core/theme/app_theme.dart';
import 'package:self_discipline_app/presentation/pages/onboarding/onboarding_page.dart';
import 'package:self_discipline_app/presentation/pages/onboarding/screens/first_screen.dart';
import 'package:self_discipline_app/presentation/pages/onboarding/screens/identify_page.dart';
import 'package:self_discipline_app/presentation/pages/onboarding/screens/social_proof_page.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';

void main() async {
  final overrides = await AppInitializer.initialize();
  runApp(AppInitializer.wrapWithProviders(const MyApp(), overrides));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeProvider);
    final router = AppRouter();

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Self Discipline',
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeMode,
          routerConfig: router.config(),
        );
      },
    );
  }
}
