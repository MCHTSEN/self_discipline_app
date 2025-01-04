import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/app_strings.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';
import 'dart:io';

class SettingsDialogs {
  static void showLanguageSelector(BuildContext context, WidgetRef ref) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Text(AppStrings.selectLanguage),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                await ref.read(appSettingsProvider.notifier).setLanguage('en');
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(AppStrings.english),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await ref.read(appSettingsProvider.notifier).setLanguage('tr');
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🇹🇷', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(AppStrings.turkish),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: Text(AppStrings.cancel),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
              title: Text(AppStrings.english),
              onTap: () async {
                await ref.read(appSettingsProvider.notifier).setLanguage('en');
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Text('🇹🇷', style: TextStyle(fontSize: 20)),
              title: Text(AppStrings.turkish),
              onTap: () async {
                await ref.read(appSettingsProvider.notifier).setLanguage('tr');
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      );
    }
  }

  static void showThemeSelector(BuildContext context, WidgetRef ref) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Text(AppStrings.selectTheme),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                await ref
                    .read(appSettingsProvider.notifier)
                    .setThemeMode(ThemeMode.system);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.brightness_auto),
                  const SizedBox(width: 10),
                  Text(AppStrings.systemDefault),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await ref
                    .read(appSettingsProvider.notifier)
                    .setThemeMode(ThemeMode.light);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.brightness_5),
                  const SizedBox(width: 10),
                  Text(AppStrings.light),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await ref
                    .read(appSettingsProvider.notifier)
                    .setThemeMode(ThemeMode.dark);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.brightness_4),
                  const SizedBox(width: 10),
                  Text(AppStrings.dark),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: Text(AppStrings.cancel),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: Text(AppStrings.systemDefault),
              onTap: () async {
                await ref
                    .read(appSettingsProvider.notifier)
                    .setThemeMode(ThemeMode.system);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_5),
              title: Text(AppStrings.light),
              onTap: () async {
                await ref
                    .read(appSettingsProvider.notifier)
                    .setThemeMode(ThemeMode.light);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_4),
              title: Text(AppStrings.dark),
              onTap: () async {
                await ref
                    .read(appSettingsProvider.notifier)
                    .setThemeMode(ThemeMode.dark);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      );
    }
  }

  static void showDataUsageInfo(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(AppStrings.dataUsageTitle),
          content: Text(AppStrings.dataUsageContent),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.close),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppStrings.dataUsageTitle),
          content: Text(AppStrings.dataUsageContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.close),
            ),
          ],
        ),
      );
    }
  }

  static void showAboutDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(AppStrings.aboutTitle),
          content: Column(
            children: [
              const SizedBox(height: 16),
              const FlutterLogo(size: 64),
              const SizedBox(height: 16),
              Text(
                '${AppStrings.appVersion}\n\n'
                '${AppStrings.appDescription}\n\n'
                '${AppStrings.copyright}',
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.close),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AboutDialog(
          applicationName: AppStrings.appName,
          applicationVersion: AppStrings.appVersion,
          applicationIcon: const FlutterLogo(size: 64),
          children: [
            Text(AppStrings.appDescription),
            const SizedBox(height: 16),
            Text(
              AppStrings.copyright,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }
  }

  static Future<bool> showClearDataConfirmation(BuildContext context) async {
    bool shouldClear = false;

    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(AppStrings.clearAllData),
          content: Text(AppStrings.clearAllDataConfirmation),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.cancel),
            ),
            CupertinoDialogAction(
              onPressed: () {
                shouldClear = true;
                Navigator.pop(context);
              },
              isDestructiveAction: true,
              child: Text(AppStrings.clear),
            ),
          ],
        ),
      );
    } else {
      shouldClear = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppStrings.clearAllData),
              content: Text(AppStrings.clearAllDataConfirmation),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(AppStrings.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(AppStrings.clear),
                ),
              ],
            ),
          ) ??
          false;
    }

    return shouldClear;
  }
}
