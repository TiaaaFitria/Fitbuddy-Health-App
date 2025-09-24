import 'package:flutter/material.dart';
import '../../../model/app_state.dart';
import '../../auth/login_page.dart';
import 'notifications_page.dart';
import 'appearance_page.dart';
import 'about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              currentUser = null; // hapus user global
              Navigator.pop(context); // tutup dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.teal),
              title: const Text("Notifications & Reminder"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens, color: Colors.teal),
              title: const Text("Appearance"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AppearancePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.teal),
              title: const Text("About"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
