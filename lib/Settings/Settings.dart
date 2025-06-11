import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:admin/Settings/AccountInformationPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricAuthEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Settings'),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.settings_backup_restore),
      //       onPressed: () => _showResetDialog(context),
      //       tooltip: 'Reset settings',
      //     ),
      //   ],
      // ),
      body: ListView(
        children: [
          _buildSectionHeader('Account'),
          _buildSettingsItem(
            context,
            'Account Information',
            Icons.person_outline,
            subtitle: 'View and edit your profile',
            onTap: () => _navigateToAccountInfo(context),
          ),
          _buildSettingsItem(
            context,
            'Change Password',
            Icons.lock_reset,
            subtitle: 'Update your security credentials',
            onTap: () => _navigateToChangePassword(context),
          ),
          
          _buildSectionHeader('Preferences'),
          _buildSwitchSetting(
            'Dark Mode',
            Icons.dark_mode_outlined,
            _darkModeEnabled,
            (value) => setState(() {
              _darkModeEnabled = value;
              // Implement theme change logic here
            }),
          ),
          _buildDropdownSetting(
            'App Language',
            Icons.language,
            _selectedLanguage,
            ['English', 'Spanish', 'French', 'German', 'Japanese'],
            (newValue) => setState(() {
              _selectedLanguage = newValue!;
              // Implement language change logic here
            }),
          ),
          
          _buildSectionHeader('Security'),
          _buildSwitchSetting(
            'Biometric Authentication',
            Icons.fingerprint,
            _biometricAuthEnabled,
            (value) => setState(() {
              _biometricAuthEnabled = value;
              // Implement biometric auth toggle logic here
            }),
          ),
          _buildSettingsItem(
            context,
            'Privacy Policy',
            Icons.privacy_tip_outlined,
            onTap: () => _showPrivacyPolicy(context),
          ),
          
          _buildSectionHeader('Support'),
          _buildSettingsItem(
            context,
            'Help Center',
            Icons.help_center_outlined,
            onTap: () => _navigateToHelpCenter(context),
          ),
          _buildSettingsItem(
            context,
            'Contact Support',
            Icons.support_agent,
            onTap: () => _contactSupport(context),
          ),
          _buildSettingsItem(
            context,
            'About App',
            Icons.info_outline,
            subtitle: 'Version 2.3.1 • Build 47',
            onTap: () => _showAboutDialog(context),
          ),
          
          const SizedBox(height: 20),
          _buildLogoutButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon, {
    String? subtitle,
    VoidCallback? onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchSetting(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    IconData icon,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        underline: Container(),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text('Logout', style: TextStyle(color: Colors.red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => _showLogoutConfirmation(context),
      ),
    );
  }

 void _navigateToAccountInfo(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AccountInfoPage(),
    ),
  );
}

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Change Password')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password changed successfully')),
                    );
                  },
                  child: const Text('Update Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            '📄 Privacy Policy'
              'This Privacy Policy applies to the administrative section of our Textile E-Commerce Application.'
              'We are committed to protecting the privacy and security of all administrators and authorized personnel '
              'who access this platform. When you log in or perform actions as an admin, we may collect certain'
              'information such as your name, email address, role, contact number, and secure login credentials.'
              'Additionally, we log your activity, including product management actions, order processing,'
              'user management, and timestamps of your actions for security and audit purposes. We may also collect '
              'technical details such as IP address, device type, and browser information to ensure secure access and'
              'performance monitoring. All collected data is used solely to manage and maintain the integrity of the platform.'
              'We do not share admin data with third parties unless legally required. Passwords and sensitive data are encrypted '
              'and stored securely. By using the admin panel, you agree to the collection and use of information in accordance with '
              'this policy. We may update this Privacy Policy from time to time to reflect changes in our system or '
              'compliance requirements. Continued use of the admin dashboard after any updates indicates your '
              'acceptance of those changes. If you have any questions or concerns regarding your data or privacy, '
              'please contact the system administrator or our support team.',
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

  void _navigateToHelpCenter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Help Center')),
          body: ListView(
            children: [
              _buildHelpItem('Getting Started', Icons.play_circle_outline),
              _buildHelpItem('Account Issues', Icons.person_outline),
              _buildHelpItem('Payment Problems', Icons.payment),
              _buildHelpItem('App Features', Icons.help_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {}, // Add navigation to specific help topic
    );
  }

  void _contactSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Contact Support', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email Support'),
              subtitle: const Text('support@example.com'),
              onTap: () {
                Navigator.pop(context);
                // Implement email launch
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call Support'),
              subtitle: const Text('+1 (555) 123-4567'),
              onTap: () {
                Navigator.pop(context);
                // Implement phone call
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('Live Chat'),
              onTap: () {
                Navigator.pop(context);
                // Implement live chat
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'My Awesome App',
      applicationVersion: 'Version 2.3.1 • Build 47',
      applicationLegalese: '© 2023 My Company. All rights reserved.',
      children: [
        const SizedBox(height: 16),
        const Text('This app is built with Flutter'),
        TextButton(
          onPressed: () {
            // Open app store for review
          },
          child: const Text('Rate this app'),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You have been logged out')),
              );
              // Implement actual logout logic here
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('This will reset all settings to their default values. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notificationsEnabled = true;
                _darkModeEnabled = false;
                _biometricAuthEnabled = false;
                _selectedLanguage = 'English';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}