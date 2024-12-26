import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppSettings {
  final ThemeMode themeMode;
  final String appVersion;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String contactEmail;
  final bool enableNotifications;
  final bool enableSoundEffects;
  final bool enableHapticFeedback;
  final bool enableAnalytics;
  final String widgetStyle;
  final String colorScheme;
  final String appIconStyle;

  AppSettings({
    required this.themeMode,
    required this.appVersion,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.contactEmail,
    this.enableNotifications = true,
    this.enableSoundEffects = true,
    this.enableHapticFeedback = true,
    this.enableAnalytics = false,
    this.widgetStyle = 'default',
    this.colorScheme = 'default',
    this.appIconStyle = 'default',
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? appVersion,
    String? privacyPolicyUrl,
    String? termsOfServiceUrl,
    String? contactEmail,
    bool? enableNotifications,
    bool? enableSoundEffects,
    bool? enableHapticFeedback,
    bool? enableAnalytics,
    String? widgetStyle,
    String? colorScheme,
    String? appIconStyle,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      appVersion: appVersion ?? this.appVersion,
      privacyPolicyUrl: privacyPolicyUrl ?? this.privacyPolicyUrl,
      termsOfServiceUrl: termsOfServiceUrl ?? this.termsOfServiceUrl,
      contactEmail: contactEmail ?? this.contactEmail,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableSoundEffects: enableSoundEffects ?? this.enableSoundEffects,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      widgetStyle: widgetStyle ?? this.widgetStyle,
      colorScheme: colorScheme ?? this.colorScheme,
      appIconStyle: appIconStyle ?? this.appIconStyle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'appVersion': appVersion,
      'privacyPolicyUrl': privacyPolicyUrl,
      'termsOfServiceUrl': termsOfServiceUrl,
      'contactEmail': contactEmail,
      'enableNotifications': enableNotifications,
      'enableSoundEffects': enableSoundEffects,
      'enableHapticFeedback': enableHapticFeedback,
      'enableAnalytics': enableAnalytics,
      'widgetStyle': widgetStyle,
      'colorScheme': colorScheme,
      'appIconStyle': appIconStyle,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: ThemeMode.values[json['themeMode'] ?? 0],
      appVersion: json['appVersion'] ?? '1.0.0',
      privacyPolicyUrl:
          json['privacyPolicyUrl'] ?? 'https://example.com/privacy',
      termsOfServiceUrl:
          json['termsOfServiceUrl'] ?? 'https://example.com/terms',
      contactEmail: json['contactEmail'] ?? 'support@example.com',
      enableNotifications: json['enableNotifications'] ?? true,
      enableSoundEffects: json['enableSoundEffects'] ?? true,
      enableHapticFeedback: json['enableHapticFeedback'] ?? true,
      enableAnalytics: json['enableAnalytics'] ?? false,
      widgetStyle: json['widgetStyle'] ?? 'default',
      colorScheme: json['colorScheme'] ?? 'default',
      appIconStyle: json['appIconStyle'] ?? 'default',
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final Box<dynamic> settingsBox;

  SettingsNotifier(this.settingsBox)
      : super(AppSettings(
          themeMode: ThemeMode.system,
          appVersion: '1.0.0',
          privacyPolicyUrl: 'https://example.com/privacy',
          termsOfServiceUrl: 'https://example.com/terms',
          contactEmail: 'support@example.com',
        )) {
    _loadSettings();
  }

  void _loadSettings() {
    final settings = settingsBox.get('settings');
    if (settings != null) {
      state = AppSettings.fromJson(Map<String, dynamic>.from(settings));
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    await settingsBox.put('settings', state.toJson());
  }

  Future<void> updateNotifications(bool value) async {
    state = state.copyWith(enableNotifications: value);
    await _saveSettings();
  }

  Future<void> updateSoundEffects(bool value) async {
    state = state.copyWith(enableSoundEffects: value);
    await _saveSettings();
  }

  Future<void> updateHapticFeedback(bool value) async {
    state = state.copyWith(enableHapticFeedback: value);
    await _saveSettings();
  }

  Future<void> updateAnalytics(bool value) async {
    state = state.copyWith(enableAnalytics: value);
    await _saveSettings();
  }

  Future<void> updateWidgetStyle(String style) async {
    state = state.copyWith(widgetStyle: style);
    await _saveSettings();
  }

  Future<void> updateColorScheme(String scheme) async {
    state = state.copyWith(colorScheme: scheme);
    await _saveSettings();
  }

  Future<void> updateAppIcon(String style) async {
    state = state.copyWith(appIconStyle: style);
    await _saveSettings();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final settingsBox = Hive.box('settings');
  return SettingsNotifier(settingsBox);
});
