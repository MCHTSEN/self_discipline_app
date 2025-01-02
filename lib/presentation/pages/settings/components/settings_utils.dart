import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:self_discipline_app/core/constants/app_strings.dart';

class SettingsUtils {
  static String getThemeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return AppStrings.systemDefault;
      case ThemeMode.light:
        return AppStrings.light;
      case ThemeMode.dark:
        return AppStrings.dark;
    }
  }

  static String getLanguageText(String code) {
    switch (code) {
      case 'en':
        return AppStrings.english;
      case 'tr':
        return AppStrings.turkish;
      default:
        return AppStrings.english;
    }
  }

  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
