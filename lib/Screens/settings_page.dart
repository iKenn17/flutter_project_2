import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/notification_service.dart';
import '../Screens/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = false;

  // Shared colors used throughout the page
  static const darkBrown = Color.fromARGB(255, 40, 33, 31);
  static const warmBeige = Color.fromARGB(255, 204, 193, 177);

  @override
  void initState() {
    super.initState();
    loadToggle(); // Load saved notification setting on startup
  }

  // Reads the saved notification toggle value from local storage
  Future<void> loadToggle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notifications') ?? false;
    });
  }

  // Saves the current toggle value to local storage
  Future<void> saveToggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
  }

  // Called when the user flips the notification switch
  Future<void> onToggleChanged(bool value) async {
    if (value) {
      // Ask for notification permission when enabling
      final status = await Permission.notification.request();

      if (status.isDenied || status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification permission denied.')),
          );
          // If permanently denied, open system settings so the user can fix it
          if (status.isPermanentlyDenied) openAppSettings();
        }
        return;
      }
    } else {
      // Cancel all scheduled notifications when disabling
      await NotificationService.cancelAllNotifications();
    }

    setState(() => notificationsEnabled = value);
    await saveToggle(value);
  }

  // Signs the user out of Firebase
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Shows a confirmation dialog before logging out
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: warmBeige,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(color: darkBrown, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: darkBrown),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: darkBrown)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: darkBrown,
              foregroundColor: warmBeige,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx); // Close the dialog first
              await FirebaseAuth.instance.signOut();

              if (mounted) {
                // Go to login and clear the entire navigation stack
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warmBeige,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: darkBrown,
        foregroundColor: Colors.white,
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Toggle for enabling/disabling notifications
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(14),
              ),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                title: const Text(
                  "Enable Notifications",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkBrown,
                  ),
                ),
                secondary: const Icon(
                  Icons.notifications_outlined,
                  color: darkBrown,
                ),
                value: notificationsEnabled,
                activeColor: darkBrown,
                onChanged: onToggleChanged,
              ),
            ),

            const Spacer(),

            // Log out button pinned to the bottom of the screen
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showLogoutDialog,
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Log Out",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBrown,
                  foregroundColor: warmBeige,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
