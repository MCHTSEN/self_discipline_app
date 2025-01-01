import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final appSettingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return SettingsNotifier(box);
});

final settingsBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('settingsBoxProvider not initialized');
});

class AppSettings {
  final ThemeMode themeMode;
  final bool isNotificationsEnabled;
  final String language;
  final bool isFirstLaunch;

  AppSettings({
    this.themeMode = ThemeMode.system,
    this.isNotificationsEnabled = true,
    this.language = 'en',
    this.isFirstLaunch = true,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? isNotificationsEnabled,
    String? language,
    bool? isFirstLaunch,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      language: language ?? this.language,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final Box settingsBox;

  SettingsNotifier(this.settingsBox) : super(AppSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final themeModeIndex =
        settingsBox.get('themeMode', defaultValue: ThemeMode.system.index);
    final isNotificationsEnabled =
        settingsBox.get('isNotificationsEnabled', defaultValue: true);
    final language = settingsBox.get('language', defaultValue: 'en');
    final isFirstLaunch = settingsBox.get('isFirstLaunch', defaultValue: true);

    state = AppSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      isNotificationsEnabled: isNotificationsEnabled,
      language: language,
      isFirstLaunch: isFirstLaunch,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await settingsBox.put('themeMode', mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await settingsBox.put('isNotificationsEnabled', value);
    state = state.copyWith(isNotificationsEnabled: value);
  }

  Future<void> setLanguage(String value) async {
    await settingsBox.put('language', value);
    state = state.copyWith(language: value);
  }

  Future<void> setFirstLaunch(bool value) async {
    await settingsBox.put('isFirstLaunch', value);
    state = state.copyWith(isFirstLaunch: value);
  }
}
