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

  static const String defaultPrivacyPolicy =
      'https://enshrined-xylophone-794.notion.site/Privacy-Policy-1684dd6a6c7380d0b48afeadf1266019';
  static const String defaultTermsOfService =
      'https://enshrined-xylophone-794.notion.site/Terms-of-Service-1684dd6a6c7380b2ae91fb917e6bf321';

  AppSettings({
    required this.themeMode,
    required this.appVersion,
    this.privacyPolicyUrl = defaultPrivacyPolicy,
    this.termsOfServiceUrl = defaultTermsOfService,
    required this.contactEmail,
    this.enableNotifications = true,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? appVersion,
    String? privacyPolicyUrl,
    String? termsOfServiceUrl,
    String? contactEmail,
    bool? enableNotifications,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      appVersion: appVersion ?? this.appVersion,
      privacyPolicyUrl: privacyPolicyUrl ?? this.privacyPolicyUrl,
      termsOfServiceUrl: termsOfServiceUrl ?? this.termsOfServiceUrl,
      contactEmail: contactEmail ?? this.contactEmail,
      enableNotifications: enableNotifications ?? this.enableNotifications,
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
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: ThemeMode.values[json['themeMode'] ?? 0],
      appVersion: json['appVersion'] ?? '1.0.0',
      privacyPolicyUrl: json['privacyPolicyUrl'] ?? defaultPrivacyPolicy,
      termsOfServiceUrl: json['termsOfServiceUrl'] ?? defaultTermsOfService,
      contactEmail: json['contactEmail'] ?? 'support@example.com',
      enableNotifications: json['enableNotifications'] ?? true,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final Box<dynamic> settingsBox;

  SettingsNotifier(this.settingsBox)
      : super(AppSettings(
          themeMode: ThemeMode.system,
          appVersion: '1.0.0',
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

  Future<void> updateNotifications(bool value) async {
    state = state.copyWith(enableNotifications: value);
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    await settingsBox.put('settings', state.toJson());
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final settingsBox = Hive.box('settings');
  return SettingsNotifier(settingsBox);
});
