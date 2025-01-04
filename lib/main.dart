import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/router/app_router.dart';
import 'package:self_discipline_app/core/services/app_initializer.dart';
import 'package:self_discipline_app/core/theme/app_theme.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';

void main() async {
  final overrides = await AppInitializer.initialize();
  runApp(AppInitializer.wrapWithProviders(const MyApp(), overrides));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final router = AppRouter();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Self Discipline',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: settings.themeMode,
      routerConfig: router.config(),
    );
  }
}
