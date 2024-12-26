import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:self_discipline_app/core/router/app_router.dart';
import 'package:self_discipline_app/core/theme/app_theme.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';
import 'presentation/viewmodels/providers.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HabitModelAdapter());

  final habitBox = await Hive.openBox<HabitModel>('habits');
  final completionBox = await Hive.openBox<List<DateTime>>('habit_completions');
  await Hive.openBox('settings');

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ProviderScope(
        overrides: [
          habitBoxProvider.overrideWithValue(habitBox),
          completionBoxProvider.overrideWithValue(completionBox),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: settings.themeMode,
      routerConfig: _appRouter.config(),
    );
  }
}
