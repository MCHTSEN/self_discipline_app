import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:self_discipline_app/core/theme/app_theme.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/viewmodels/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HabitModelAdapter());
  // build_runner'dan sonra oluşan adapteri import etmeyi unutmayın.

  final habitBox = await Hive.openBox<HabitModel>('habits');
  final completionBox = await Hive.openBox<List<DateTime>>('habit_completions');

  runApp(
    ProviderScope(
      overrides: [
        habitBoxProvider.overrideWithValue(habitBox),
        completionBoxProvider.overrideWithValue(completionBox),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      title: 'Habit Tracker',
      home: const HomePage(),
    );
  }
}
