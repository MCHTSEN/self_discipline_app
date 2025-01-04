import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 32,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF7F50), // Coral
                      Color(0xFFFF6B45), // Lighter coral
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildAppearanceSection(context, ref, settings),
              _buildPreferencesSection(context, ref, settings),
              _buildAboutSection(context, settings),
              _buildLegalSection(context, settings),
              if (kDebugMode) _buildDebugSection(context, ref),
              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    return _buildSection(
      context,
      'Appearance',
      [
        _buildSettingsTile(
          context,
          title: 'Theme',
          subtitle: _getThemeText(settings.themeMode),
          icon: Icons.brightness_6,
          onTap: () => _showThemeSelector(context, ref),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    return _buildSection(
      context,
      'Preferences',
      [
        _buildSwitchTile(
          context,
          title: 'Notifications',
          subtitle: 'Daily reminders and alerts',
          icon: Icons.notifications_outlined,
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
      context,
      'About',
      [
        _buildSettingsTile(
          context,
          title: 'Contact Us',
          icon: Icons.mail_outline,
          onTap: () => _launchURL('mailto:support@example.com'),
        ),
        _buildSettingsTile(
          context,
          title: 'About App',
          subtitle: 'Version 1.0.0',
          icon: Icons.info_outline,
          onTap: () => _showAboutDialog(context),
        ),
        _buildSettingsTile(
          context,
          title: 'Data Usage',
          icon: Icons.data_usage_outlined,
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
      context,
      'Legal',
      [
        _buildSettingsTile(
          context,
          title: 'Privacy Policy',
          icon: Icons.privacy_tip_outlined,
          onTap: () => _launchURL(defaultPrivacyPolicy),
        ),
        _buildSettingsTile(
          context,
          title: 'Terms of Service',
          icon: Icons.description_outlined,
          onTap: () => _launchURL(defaultTermsOfService),
        ),
      ],
    );
  }

  Widget _buildDebugSection(BuildContext context, WidgetRef ref) {
    return _buildSection(
      context,
      'Debug',
      [
        _buildSettingsTile(
          context,
          title: 'Clear All Data',
          subtitle: 'Delete all local data',
          icon: Icons.cleaning_services,
          isDestructive: true,
          onTap: () => _clearAllData(context, ref),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : AppSecondaryColors.liquidLava.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color:
                    isDestructive ? Colors.red : AppSecondaryColors.liquidLava,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDestructive ? Colors.red : null,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppSecondaryColors.liquidLava.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppSecondaryColors.liquidLava,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppSecondaryColors.liquidLava,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: AppSecondaryColors.dustyGrey,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: children.map((child) {
                final index = children.indexOf(child);
                if (index != children.length - 1) {
                  return Column(
                    children: [
                      child,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          height: 1,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[300],
                        ),
                      ),
                    ],
                  );
                }
                return child;
              }).toList(),
            ),
          ),
        ],
      ),
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
