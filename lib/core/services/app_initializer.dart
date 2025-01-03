import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/presentation/viewmodels/providers.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';

class AppInitializer {
  static Future<List<Override>> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(HabitModelAdapter());

    // Open boxes with error handling
    Box<HabitModel> habitBox;
    Box settingsBox;

    try {
      habitBox = await Hive.openBox<HabitModel>('habits');
    } catch (e) {
      // If there's an error, delete the box and try again
      await Hive.deleteBoxFromDisk('habits');
      habitBox = await Hive.openBox<HabitModel>('habits');
    }

    try {
      settingsBox = await Hive.openBox('settings');
    } catch (e) {
      // If there's an error, delete the box and try again
      await Hive.deleteBoxFromDisk('settings');
      settingsBox = await Hive.openBox('settings');
    }

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
      settingsBoxProvider.overrideWithValue(settingsBox),
    ];
  }

  static Widget wrapWithProviders(Widget app, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: DevicePreview(
        enabled: true,
        builder: (context) => app,
      ),
    );
  }
}
