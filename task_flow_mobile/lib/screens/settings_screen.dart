import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            children: [
              _buildThemeSection(context, settings),
              const Divider(),
              _buildNotificationSection(context, settings),
              const Divider(),
              _buildPrivacySection(context, settings),
              const Divider(),
              _buildProductivitySection(context, settings),
              const Divider(),
              _buildCollaborationSection(context, settings),
              const Divider(),
              _buildAboutSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, SettingsProvider settings) {
    return _buildSettingsSection(
      context,
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: Text(
            settings.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
          ),
          value: settings.isDarkMode,
          onChanged: (value) => settings.toggleDarkMode(),
        ),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context, SettingsProvider settings) {
    return _buildSettingsSection(
      context,
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          subtitle: const Text('Receive task reminders and updates'),
          value: settings.enableNotifications,
          onChanged: (value) => settings.setEnableNotifications(value),
        ),
        SwitchListTile(
          title: const Text('Sound'),
          subtitle: const Text('Play sound for notifications'),
          value: settings.enableSoundNotifications,
          onChanged: settings.enableNotifications
              ? (value) => settings.setEnableSoundNotifications(value)
              : null,
        ),
        SwitchListTile(
          title: const Text('Vibration'),
          subtitle: const Text('Vibrate for notifications'),
          value: settings.enableVibration,
          onChanged: settings.enableNotifications
              ? (value) => settings.setEnableVibration(value)
              : null,
        ),
        SwitchListTile(
          title: const Text('Location-based Reminders'),
          subtitle: const Text('Get reminders based on your location'),
          value: settings.enableLocationBasedReminders,
          onChanged: settings.enableNotifications
              ? (value) => settings.setEnableLocationBasedReminders(value)
              : null,
        ),
      ],
    );
  }

  Widget _buildPrivacySection(BuildContext context, SettingsProvider settings) {
    return _buildSettingsSection(
      context,
      title: 'Privacy & Security',
      icon: Icons.security_outlined,
      children: [
        SwitchListTile(
          title: const Text('Biometric Authentication'),
          subtitle: const Text('Use fingerprint or face ID to unlock'),
          value: settings.useBiometricAuth,
          onChanged: (value) => settings.setUseBiometricAuth(value),
        ),
        SwitchListTile(
          title: const Text('Data Sync'),
          subtitle: const Text('Sync data across devices'),
          value: settings.enableDataSync,
          onChanged: (value) => settings.setEnableDataSync(value),
        ),
        ListTile(
          title: const Text('Export Data'),
          subtitle: const Text('Download your data as JSON'),
          trailing: const Icon(Icons.download_outlined),
          onTap: () {
            // TODO: Implement data export
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exporting data...')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductivitySection(BuildContext context, SettingsProvider settings) {
    return _buildSettingsSection(
      context,
      title: 'Productivity',
      icon: Icons.trending_up_outlined,
      children: [
        SwitchListTile(
          title: const Text('Energy Level Tracking'),
          subtitle: const Text('Track energy levels for better task planning'),
          value: settings.enableEnergyLevelTracking,
          onChanged: (value) => settings.setEnableEnergyLevelTracking(value),
        ),
        SwitchListTile(
          title: const Text('Automatic Breaks'),
          subtitle: const Text('Get reminded to take breaks'),
          value: settings.enableAutomaticBreaks,
          onChanged: (value) => settings.setEnableAutomaticBreaks(value),
        ),
        ListTile(
          title: const Text('Work Session Duration'),
          subtitle: Text('${settings.workSessionDuration} minutes'),
          trailing: const Icon(Icons.timer_outlined),
          onTap: () => _showDurationPicker(
            context,
            'Work Session Duration',
            settings.workSessionDuration,
            (value) => settings.setWorkSessionDuration(value),
          ),
        ),
        ListTile(
          title: const Text('Break Duration'),
          subtitle: Text('${settings.breakDuration} minutes'),
          trailing: const Icon(Icons.timer_outlined),
          onTap: () => _showDurationPicker(
            context,
            'Break Duration',
            settings.breakDuration,
            (value) => settings.setBreakDuration(value),
          ),
        ),
      ],
    );
  }

  Widget _buildCollaborationSection(BuildContext context, SettingsProvider settings) {
    return _buildSettingsSection(
      context,
      title: 'Collaboration',
      icon: Icons.people_outline,
      children: [
        SwitchListTile(
          title: const Text('Show Collaborator Status'),
          subtitle: const Text('Display online status to team members'),
          value: settings.showCollaboratorStatus,
          onChanged: (value) => settings.setShowCollaboratorStatus(value),
        ),
        SwitchListTile(
          title: const Text('Auto-accept Team Invites'),
          subtitle: const Text('Automatically accept team invitations'),
          value: settings.autoAcceptTeamInvites,
          onChanged: (value) => settings.setAutoAcceptTeamInvites(value),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSettingsSection(
      context,
      title: 'About',
      icon: Icons.info_outline,
      children: [
        ListTile(
          title: const Text('Version'),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement terms of service navigation
          },
        ),
        ListTile(
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement privacy policy navigation
          },
        ),
        ListTile(
          title: const Text('Licenses'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            showLicensePage(
              context: context,
              applicationName: 'TaskFlow',
              applicationVersion: '1.0.0',
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  void _showDurationPicker(
    BuildContext context,
    String title,
    int currentValue,
    Function(int) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select duration in minutes'),
            const SizedBox(height: 16),
            DropdownButton<int>(
              value: currentValue,
              items: List.generate(12, (index) => (index + 1) * 5).map((duration) {
                return DropdownMenuItem(
                  value: duration,
                  child: Text('$duration minutes'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}