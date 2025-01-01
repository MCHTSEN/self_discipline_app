import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/utils/logger.dart';
import 'package:self_discipline_app/presentation/viewmodels/providers.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Logger.pageBuild('SettingsPage');
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildAppearanceSection(context, ref, settings),
          _buildPreferencesSection(context, ref, settings),
          _buildAboutSection(context, settings),
          _buildLegalSection(context, settings),
          if (kDebugMode) _buildDebugSection(context, ref),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    return _buildSection(
      'Appearance',
      [
        ListTile(
          title: const Text('Theme'),
          subtitle: Text(_getThemeText(settings.themeMode)),
          leading: const Icon(Icons.brightness_6),
          onTap: () => _showThemeSelector(context, ref),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    return _buildSection(
      'Preferences',
      [
        SwitchListTile(
          title: const Text('Notifications'),
          subtitle: const Text('Daily reminders and alerts'),
          secondary: const Icon(Icons.notifications_outlined),
          value: settings.isNotificationsEnabled,
          onChanged: (value) async {
            await ref
                .read(appSettingsProvider.notifier)
                .setNotificationsEnabled(value);
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, AppSettings settings) {
    return _buildSection(
      'About',
      [
        ListTile(
          title: const Text('Contact Us'),
          leading: const Icon(Icons.mail_outline),
          onTap: () => _launchURL('mailto:support@example.com'),
        ),
        ListTile(
          title: const Text('About App'),
          subtitle: const Text('Version 1.0.0'),
          leading: const Icon(Icons.info_outline),
          onTap: () => _showAboutDialog(context),
        ),
        ListTile(
          title: const Text('Data Usage'),
          leading: const Icon(Icons.data_usage_outlined),
          onTap: () => _showDataUsageInfo(context),
        ),
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context, AppSettings settings) {
    const String defaultPrivacyPolicy =
        'https://enshrined-xylophone-794.notion.site/Privacy-Policy-1684dd6a6c7380d0b48afeadf1266019';
    const String defaultTermsOfService =
        'https://enshrined-xylophone-794.notion.site/Terms-of-Service-1684dd6a6c7380b2ae91fb917e6bf321';
    return _buildSection(
      'Legal',
      [
        ListTile(
          title: const Text('Privacy Policy'),
          leading: const Icon(Icons.privacy_tip_outlined),
          onTap: () => _launchURL(defaultPrivacyPolicy),
        ),
        ListTile(
          title: const Text('Terms of Service'),
          leading: const Icon(Icons.description_outlined),
          onTap: () => _launchURL(defaultTermsOfService),
        ),
      ],
    );
  }

  Widget _buildDebugSection(BuildContext context, WidgetRef ref) {
    return _buildSection(
      'Debug',
      [
        ListTile(
          title: const Text('Clear All Data'),
          subtitle: const Text('Delete all local data'),
          leading: const Icon(Icons.cleaning_services),
          onTap: () => _clearAllData(context, ref),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text('Select Theme'),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.brightness_auto),
                  SizedBox(width: 10),
                  Text('System Default'),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.brightness_5),
                  SizedBox(width: 10),
                  Text('Light'),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.brightness_4),
                  SizedBox(width: 10),
                  Text('Dark'),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: const Text('Cancel'),
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
              title: const Text('System Default'),
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
              title: const Text('Light'),
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
              title: const Text('Dark'),
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

  void _showDataUsageInfo(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Data Usage'),
          content: const Text(
            'We store your habit data locally on your device. '
            'This includes:\n\n'
            '• Your habits and their settings\n'
            '• Completion records\n'
            '• App preferences\n\n'
            'No personal data is collected or shared with third parties. '
            'All your data remains on your device and is never uploaded to any server.',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Data Usage'),
          content: const Text(
            'We store your habit data locally on your device. '
            'This includes:\n\n'
            '• Your habits and their settings\n'
            '• Completion records\n'
            '• App preferences\n\n'
            'No personal data is collected or shared with third parties. '
            'All your data remains on your device and is never uploaded to any server.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Self Discipline',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(size: 64),
      children: const [
        Text(
          'Self Discipline is a habit tracking app designed to help you build '
          'better habits and achieve your goals. Track your daily and weekly '
          'habits, build streaks, and stay motivated with visual progress indicators.',
        ),
        SizedBox(height: 16),
        Text(
          '© 2024 Self Discipline. All rights reserved.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _clearAllData(BuildContext context, WidgetRef ref) async {
    bool shouldClear = false;

    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
            'This will delete all your habits and settings. '
            'This action cannot be undone. Are you sure?',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                shouldClear = true;
                Navigator.pop(context);
              },
              isDestructiveAction: true,
              child: const Text('Clear'),
            ),
          ],
        ),
      );
    } else {
      shouldClear = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Clear All Data'),
              content: const Text(
                'This will delete all your habits and settings. '
                'This action cannot be undone. Are you sure?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text('Clear'),
                ),
              ],
            ),
          ) ??
          false;
    }

    if (shouldClear && context.mounted) {
      final habitBox = ref.read(habitBoxProvider);
      final settingsBox = ref.read(settingsBoxProvider);

      await habitBox.clear();
      await settingsBox.clear();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _getThemeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}
