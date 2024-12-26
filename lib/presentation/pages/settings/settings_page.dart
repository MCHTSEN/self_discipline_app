import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final platform = Theme.of(context).platform;
    final isIOS = platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Settings'),
            ) as PreferredSizeWidget
          : AppBar(
              title: const Text('Settings'),
            ),
      body: isIOS
          ? CupertinoScrollbar(
              child: _buildSettingsList(context, ref, settings, isIOS),
            )
          : _buildSettingsList(context, ref, settings, isIOS),
    );
  }

  Widget _buildSettingsList(
      BuildContext context, WidgetRef ref, AppSettings settings, bool isIOS) {
    return ListView(
      children: [
        _buildSection(
          title: 'Appearance',
          children: [
            isIOS
                ? CupertinoListSection(
                    children: [
                      CupertinoListTile(
                        title: const Text('Theme'),
                        subtitle: Text(_getThemeText(settings.themeMode)),
                        leading: const Icon(Icons.brightness_6),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _showThemeSelector(context, ref, isIOS),
                      ),
                    ],
                  )
                : ListTile(
                    title: const Text('Theme'),
                    subtitle: Text(_getThemeText(settings.themeMode)),
                    leading: const Icon(Icons.brightness_6),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showThemeSelector(context, ref, isIOS),
                  ),
          ],
        ),
        _buildSection(
          title: 'Legal',
          children: [
            if (isIOS)
              CupertinoListSection(
                children: [
                  CupertinoListTile(
                    title: const Text('Privacy Policy'),
                    leading: const Icon(Icons.shield_outlined),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _launchURL(settings.privacyPolicyUrl),
                  ),
                  CupertinoListTile(
                    title: const Text('Terms of Service'),
                    leading: const Icon(Icons.description_outlined),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _launchURL(settings.termsOfServiceUrl),
                  ),
                ],
              )
            else ...[
              ListTile(
                title: const Text('Privacy Policy'),
                leading: const Icon(Icons.privacy_tip_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _launchURL(settings.privacyPolicyUrl),
              ),
              ListTile(
                title: const Text('Terms of Service'),
                leading: const Icon(Icons.description_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _launchURL(settings.termsOfServiceUrl),
              ),
            ],
          ],
        ),
        _buildSection(
          title: 'About',
          children: [
            if (isIOS)
              CupertinoListSection(
                children: [
                  CupertinoListTile(
                    title: const Text('Contact Us'),
                    leading: const Icon(Icons.mail_outline),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _launchURL('mailto:${settings.contactEmail}'),
                  ),
                  CupertinoListTile(
                    title: const Text('About App'),
                    subtitle: Text('Version ${settings.appVersion}'),
                    leading: const Icon(Icons.info_outline),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _showAboutDialog(context, isIOS),
                  ),
                  CupertinoListTile(
                    title: const Text('Data Usage'),
                    leading: const Icon(Icons.data_usage_outlined),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _showDataUsageInfo(context, isIOS),
                  ),
                ],
              )
            else ...[
              ListTile(
                title: const Text('Contact Us'),
                leading: const Icon(Icons.mail_outline),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _launchURL('mailto:${settings.contactEmail}'),
              ),
              ListTile(
                title: const Text('About App'),
                subtitle: Text('Version ${settings.appVersion}'),
                leading: const Icon(Icons.info_outline),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showAboutDialog(context, isIOS),
              ),
              ListTile(
                title: const Text('Data Usage'),
                leading: const Icon(Icons.data_usage_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showDataUsageInfo(context, isIOS),
              ),
            ],
          ],
        ),
        _buildSection(
          title: 'Preferences',
          children: [
            if (isIOS)
              CupertinoListSection(
                children: [
                  CupertinoListTile(
                    title: const Text('Notifications'),
                    leading: const Icon(Icons.notifications_outlined),
                    trailing: CupertinoSwitch(
                      value: settings.enableNotifications,
                      onChanged: (value) => ref
                          .read(settingsProvider.notifier)
                          .updateNotifications(value),
                    ),
                  ),
                  CupertinoListTile(
                    title: const Text('Sound Effects'),
                    leading: const Icon(Icons.volume_up_outlined),
                    trailing: CupertinoSwitch(
                      value: settings.enableSoundEffects,
                      onChanged: (value) => ref
                          .read(settingsProvider.notifier)
                          .updateSoundEffects(value),
                    ),
                  ),
                  CupertinoListTile(
                    title: const Text('Haptic Feedback'),
                    leading: const Icon(Icons.vibration_outlined),
                    trailing: CupertinoSwitch(
                      value: settings.enableHapticFeedback,
                      onChanged: (value) => ref
                          .read(settingsProvider.notifier)
                          .updateHapticFeedback(value),
                    ),
                  ),
                ],
              )
            else ...[
              SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Daily reminders and alerts'),
                secondary: const Icon(Icons.notifications_active_outlined),
                value: settings.enableNotifications,
                onChanged: (value) => ref
                    .read(settingsProvider.notifier)
                    .updateNotifications(value),
              ),
              SwitchListTile(
                title: const Text('Sound Effects'),
                subtitle: const Text('Play sounds on actions'),
                secondary: const Icon(Icons.volume_up_outlined),
                value: settings.enableSoundEffects,
                onChanged: (value) => ref
                    .read(settingsProvider.notifier)
                    .updateSoundEffects(value),
              ),
              SwitchListTile(
                title: const Text('Haptic Feedback'),
                subtitle: const Text('Vibrate on actions'),
                secondary: const Icon(Icons.vibration),
                value: settings.enableHapticFeedback,
                onChanged: (value) => ref
                    .read(settingsProvider.notifier)
                    .updateHapticFeedback(value),
              ),
            ],
          ],
        ),
        _buildSection(
          title: 'Customization',
          children: [
            if (isIOS)
              CupertinoListSection(
                children: [
                  CupertinoListTile(
                    title: const Text('Color Scheme'),
                    leading: const Icon(Icons.palette_outlined),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _showColorSchemePicker(context, isIOS),
                  ),
                  CupertinoListTile(
                    title: const Text('Widget Style'),
                    leading: const Icon(Icons.widgets_outlined),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _showWidgetStylePicker(context, isIOS),
                  ),
                ],
              )
            else ...[
              ListTile(
                title: const Text('Color Scheme'),
                subtitle: const Text('Customize app colors'),
                leading: const Icon(Icons.palette_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showColorSchemePicker(context, isIOS),
              ),
              ListTile(
                title: const Text('Widget Style'),
                subtitle: const Text('Change widget appearance'),
                leading: const Icon(Icons.widgets_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showWidgetStylePicker(context, isIOS),
              ),
            ],
          ],
        ),
        _buildSection(
          title: 'Advanced',
          children: [
            if (isIOS)
              CupertinoListSection(
                children: [
                  CupertinoListTile(
                    title: const Text('Sync Settings'),
                    leading: const Icon(Icons.cloud),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _showSyncSettings(context, isIOS),
                  ),
                  CupertinoListTile(
                    title: const Text('Backup & Restore'),
                    leading: const Icon(Icons.archive),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _showBackupOptions(context, isIOS),
                  ),
                  CupertinoListTile(
                    title: const Text('Analytics'),
                    leading: const Icon(Icons.graphic_eq),
                    trailing: CupertinoSwitch(
                      value: settings.enableAnalytics,
                      onChanged: (value) => ref
                          .read(settingsProvider.notifier)
                          .updateAnalytics(value),
                    ),
                  ),
                ],
              )
            else ...[
              ListTile(
                title: const Text('Sync Settings'),
                subtitle: const Text('Configure cloud sync'),
                leading: const Icon(Icons.sync_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showSyncSettings(context, isIOS),
              ),
              ListTile(
                title: const Text('Backup & Restore'),
                subtitle: const Text('Manage your data'),
                leading: const Icon(Icons.backup_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showBackupOptions(context, isIOS),
              ),
              SwitchListTile(
                title: const Text('Analytics'),
                subtitle: const Text('Help improve the app'),
                secondary: const Icon(Icons.analytics_outlined),
                value: settings.enableAnalytics,
                onChanged: (value) =>
                    ref.read(settingsProvider.notifier).updateAnalytics(value),
              ),
            ],
          ],
        ),
      ],
    );
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

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              color: AppSecondaryColors.dustyGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  void _showThemeSelector(BuildContext context, WidgetRef ref, bool isIOS) {
    if (isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: const Text('Select Theme'),
          actions: [
            CupertinoActionSheetAction(
              child: const Text('System Default'),
              onPressed: () {
                ref
                    .read(settingsProvider.notifier)
                    .updateThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Light'),
              onPressed: () {
                ref
                    .read(settingsProvider.notifier)
                    .updateThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Dark'),
              onPressed: () {
                ref
                    .read(settingsProvider.notifier)
                    .updateThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('System Default'),
                leading: const Icon(Icons.brightness_auto),
                onTap: () {
                  ref
                      .read(settingsProvider.notifier)
                      .updateThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Light'),
                leading: const Icon(Icons.brightness_5),
                onTap: () {
                  ref
                      .read(settingsProvider.notifier)
                      .updateThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                leading: const Icon(Icons.brightness_4),
                onTap: () {
                  ref
                      .read(settingsProvider.notifier)
                      .updateThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showDataUsageInfo(BuildContext context, bool isIOS) {
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Data Usage'),
          content: const SingleChildScrollView(
            child: Text(
              'We store your habit data locally on your device using Hive. '
              'This includes:\n\n'
              '• Your habits and their settings\n'
              '• Completion records\n'
              '• App preferences\n\n'
              'No personal data is collected or shared with third parties. '
              'All your data remains on your device and is never uploaded to any server.',
            ),
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
          content: const SingleChildScrollView(
            child: Text(
              'We store your habit data locally on your device using Hive. '
              'This includes:\n\n'
              '• Your habits and their settings\n'
              '• Completion records\n'
              '• App preferences\n\n'
              'No personal data is collected or shared with third parties. '
              'All your data remains on your device and is never uploaded to any server.',
            ),
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

  void _showAboutDialog(BuildContext context, bool isIOS) {
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('About Self Discipline'),
          content: Column(
            children: [
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
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  void _showBackupOptions(BuildContext context, bool isIOS) {
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Backup & Restore'),
          content: const Text('Choose an option to manage your data'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Export Data'),
              onPressed: () => _exportData(context),
            ),
            CupertinoDialogAction(
              child: const Text('Import Data'),
              onPressed: () => _importData(context),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Backup & Restore'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.upload_outlined),
                title: const Text('Export Data'),
                onTap: () => _exportData(context),
              ),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: const Text('Import Data'),
                onTap: () => _importData(context),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _exportData(BuildContext context) async {
    // Implementation will be added later
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export feature coming soon')),
    );
  }

  Future<void> _importData(BuildContext context) async {
    // Implementation will be added later
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import feature coming soon')),
    );
  }

  void _showSyncSettings(BuildContext context, bool isIOS) {
    // Implementation will be added later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sync settings coming soon')),
    );
  }

  void _showIconPicker(BuildContext context, bool isIOS) {
    // Implementation will be added later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Icon customization coming soon')),
    );
  }

  void _showColorSchemePicker(BuildContext context, bool isIOS) {
    // Implementation will be added later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Color scheme customization coming soon')),
    );
  }

  void _showWidgetStylePicker(BuildContext context, bool isIOS) {
    // Implementation will be added later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Widget style customization coming soon')),
    );
  }
}
