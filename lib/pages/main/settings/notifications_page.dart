<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _pushNotifications = true;
  bool _emailReminder = false;
  bool _dailyReminder = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences(); 
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailReminder = prefs.getBool('email_reminder') ?? false;
      _dailyReminder = prefs.getBool('daily_reminder') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('email_reminder', _emailReminder);
    await prefs.setBool('daily_reminder', _dailyReminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications & Reminder"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Pengaturan Notifikasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          SwitchListTile(
            title: const Text("Push Notifications"),
            subtitle: const Text("Terima notifikasi langsung di aplikasi"),
            value: _pushNotifications,
            onChanged: (value) {
              setState(() => _pushNotifications = value);
              _savePreferences();
            },
            secondary: const Icon(Icons.notifications_active),
          ),

          SwitchListTile(
            title: const Text("Email Reminder"),
            subtitle: const Text("Kirim pengingat melalui email"),
            value: _emailReminder,
            onChanged: (value) {
              setState(() => _emailReminder = value);
              _savePreferences();
            },
            secondary: const Icon(Icons.email),
          ),

          SwitchListTile(
            title: const Text("Daily Reminder"),
            subtitle: const Text("Ingatkan saya setiap hari"),
            value: _dailyReminder,
            onChanged: (value) {
              setState(() => _dailyReminder = value);
              _savePreferences();
            },
            secondary: const Icon(Icons.alarm),
          ),

          const Divider(height: 30),

          ElevatedButton.icon(
            onPressed: () async {
              await _savePreferences();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pengaturan notifikasi disimpan ✅"),
                  ),
                );
              }
            },
            icon: const Icon(Icons.save),
            label: const Text("Simpan Pengaturan"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _pushNotifications = true;
  bool _emailReminder = false;
  bool _dailyReminder = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // ambil data dari SharedPreferences
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailReminder = prefs.getBool('email_reminder') ?? false;
      _dailyReminder = prefs.getBool('daily_reminder') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('email_reminder', _emailReminder);
    await prefs.setBool('daily_reminder', _dailyReminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications & Reminder"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Pengaturan Notifikasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          SwitchListTile(
            title: const Text("Push Notifications"),
            subtitle: const Text("Terima notifikasi langsung di aplikasi"),
            value: _pushNotifications,
            onChanged: (value) {
              setState(() => _pushNotifications = value);
              _savePreferences();
            },
            secondary: const Icon(Icons.notifications_active),
          ),

          SwitchListTile(
            title: const Text("Email Reminder"),
            subtitle: const Text("Kirim pengingat melalui email"),
            value: _emailReminder,
            onChanged: (value) {
              setState(() => _emailReminder = value);
              _savePreferences();
            },
            secondary: const Icon(Icons.email),
          ),

          SwitchListTile(
            title: const Text("Daily Reminder"),
            subtitle: const Text("Ingatkan saya setiap hari"),
            value: _dailyReminder,
            onChanged: (value) {
              setState(() => _dailyReminder = value);
              _savePreferences();
            },
            secondary: const Icon(Icons.alarm),
          ),

          const Divider(height: 30),

          ElevatedButton.icon(
            onPressed: () async {
              await _savePreferences();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pengaturan notifikasi disimpan ✅"),
                  ),
                );
              }
            },
            icon: const Icon(Icons.save),
            label: const Text("Simpan Pengaturan"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
>>>>>>> bc4ed19293464f12c16099e9a02ca1f1ebdf90f4
