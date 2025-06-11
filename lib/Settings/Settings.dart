// settings.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSettingsItem(
            context,
            'Account Settings',
            Icons.person_outline,
            () => _showComingSoon(context),
          ),
          _buildSettingsItem(
            context,
            'Notifications',
            Icons.notifications_outlined,
            () => _showComingSoon(context),
          ),
          _buildSettingsItem(
            context,
            'Privacy & Security',
            Icons.lock_outline,
            () => _showComingSoon(context),
          ),
          _buildSettingsItem(
            context,
            'Appearance',
            Icons.color_lens_outlined,
            () => _showComingSoon(context),
          ),
          _buildSettingsItem(
            context,
            'Help & Support',
            Icons.help_outline,
            () => _showComingSoon(context),
          ),
          _buildSettingsItem(
            context,
            'About App',
            Icons.info_outline,
            () => _showComingSoon(context),
          ),
          const Divider(),
          _buildSettingsItem(
            context,
            'Logout',
            Icons.logout,
            () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out")),
              );
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("This feature is coming soon!")),
    );
  }
}