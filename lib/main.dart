import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:self_discipline_app/core/router/app_router.dart';
import 'package:self_discipline_app/core/theme/app_theme.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'presentation/viewmodels/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HabitModelAdapter());

  final habitBox = await Hive.openBox<HabitModel>('habits');
  final completionBox = await Hive.openBox<List<DateTime>>('habit_completions');

  runApp(
    ProviderScope(
      overrides: [
        habitBoxProvider.overrideWithValue(habitBox),
        completionBoxProvider.overrideWithValue(completionBox),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      routerConfig: _appRouter.config(),
    );
  }
}
