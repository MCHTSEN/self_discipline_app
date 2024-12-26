import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:self_discipline_app/core/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    await Hive.initFlutter();
    await Hive.openBox('habits');
    await Hive.openBox('completions');
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
  }

  static Widget wrapWithProviders(Widget app) {
    return ProviderScope(
      child: DevicePreview(
        enabled: false,
        builder: (context) => app,
      ),
    );
  }
}
