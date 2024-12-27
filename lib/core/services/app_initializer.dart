import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/presentation/viewmodels/providers.dart';

class AppInitializer {
  static Future<List<Override>> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    await Hive.initFlutter();

    // Clear old data
    await Hive.deleteBoxFromDisk('habits');
    await Hive.deleteBoxFromDisk('habit_completions');
    await Hive.deleteBoxFromDisk('settings');

    // Register Adapters
    Hive.registerAdapter(HabitModelAdapter());

    // Open Boxes
    final habitBox = await Hive.openBox<HabitModel>('habits');
    final completionBox =
        await Hive.openBox<List<DateTime>>('habit_completions');
    await Hive.openBox('settings');

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return [
      habitBoxProvider.overrideWithValue(habitBox),
      completionBoxProvider.overrideWithValue(completionBox),
    ];
  }

  static Widget wrapWithProviders(Widget app, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => app,
      ),
    );
  }
}
