import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login_page.dart';
import '../services/notification_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loadToggle();
  }

  Future<void> loadToggle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notifications') ?? false;
    });
  }

  Future<void> saveToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
  }

  Future<void> onToggleChanged(bool value) async {
    if (value) {
      final status = await Permission.notification.request();

      if (status.isDenied || status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification permission denied.')),
          );
          if (status.isPermanentlyDenied) openAppSettings();
        }
        return;
      }
    } else {
      await NotificationService.cancelAllNotifications();
    }

    setState(() => notificationsEnabled = value);
    await saveToggle(value);
  }

  Future<void> logout(BuildContext context) async {
    await auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 193, 177),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SwitchListTile(
                  title: const Text(
                    "Enable Notifications:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  value: notificationsEnabled,
                  onChanged: onToggleChanged,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async => await logout(context),
                      child: const Text("Log out"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}