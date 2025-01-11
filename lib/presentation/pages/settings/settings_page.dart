import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/app_strings.dart';
import 'package:self_discipline_app/core/utils/logger.dart';
import 'package:self_discipline_app/presentation/pages/settings/components/settings_dialogs.dart';
import 'package:self_discipline_app/presentation/pages/settings/components/settings_section.dart';
import 'package:self_discipline_app/presentation/pages/settings/components/settings_switch_tile.dart';
import 'package:self_discipline_app/presentation/pages/settings/components/settings_tile.dart';
import 'package:self_discipline_app/presentation/pages/settings/components/settings_utils.dart';
import 'package:self_discipline_app/presentation/viewmodels/providers.dart';
import 'package:self_discipline_app/presentation/viewmodels/settings_notifier.dart';

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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings_outlined, size: 32),
                  const SizedBox(height: 8),
                  Text(AppStrings.settings,
                      style: Theme.of(context).textTheme.titleLarge),
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
              _buildAppearanceSection(context, ref),
              _buildPreferencesSection(context, ref, settings),
              _buildAboutSection(context),
              _buildLegalSection(context),
              if (kDebugMode) _buildDebugSection(context, ref),
              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeProvider);
    final language = ref.watch(appLanguageProvider);

    return SettingsSection(
      title: AppStrings.appearance,
      children: [
        SettingsTile(
          title: AppStrings.theme,
          subtitle: SettingsUtils.getThemeText(themeMode),
          icon: Icons.brightness_6,
          onTap: () => SettingsDialogs.showThemeSelector(context, ref),
        ),
        SettingsTile(
          title: AppStrings.language,
          subtitle: SettingsUtils.getLanguageText(language),
          icon: Icons.language,
          onTap: () => SettingsDialogs.showLanguageSelector(context, ref),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    return SettingsSection(
      title: AppStrings.preferences,
      children: [
        SettingsSwitchTile(
          title: AppStrings.notifications,
          subtitle: AppStrings.notificationsSubtitle,
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

  Widget _buildAboutSection(BuildContext context) {
    return SettingsSection(
      title: AppStrings.about,
      children: [
        SettingsTile(
          title: AppStrings.contactUs,
          icon: Icons.mail_outline,
          onTap: () => SettingsUtils.launchURL(AppStrings.supportEmail),
        ),
        SettingsTile(
          title: AppStrings.aboutApp,
          subtitle: AppStrings.appVersion,
          icon: Icons.info_outline,
          onTap: () => SettingsDialogs.showAboutDialog(context),
        ),
        SettingsTile(
          title: AppStrings.dataUsage,
          icon: Icons.data_usage_outlined,
          onTap: () => SettingsDialogs.showDataUsageInfo(context),
        ),
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return SettingsSection(
      title: AppStrings.legal,
      children: [
        SettingsTile(
          title: AppStrings.privacyPolicy,
          icon: Icons.privacy_tip_outlined,
          onTap: () => SettingsUtils.launchURL(AppStrings.privacyPolicyUrl),
        ),
        SettingsTile(
          title: AppStrings.termsOfService,
          icon: Icons.description_outlined,
          onTap: () => SettingsUtils.launchURL(AppStrings.termsOfServiceUrl),
        ),
      ],
    );
  }

  Widget _buildDebugSection(BuildContext context, WidgetRef ref) {
    return SettingsSection(
      title: AppStrings.debug,
      children: [
        SettingsTile(
          title: AppStrings.clearAllData,
          subtitle: AppStrings.clearAllDataSubtitle,
          icon: Icons.cleaning_services,
          isDestructive: true,
          onTap: () async {
            final shouldClear =
                await SettingsDialogs.showClearDataConfirmation(context);
            if (shouldClear && context.mounted) {
              final habitBox = ref.read(habitBoxProvider);
              final settingsBox = ref.read(settingsBoxProvider);

              await habitBox.clear();
              await settingsBox.clear();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.dataCleared),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
