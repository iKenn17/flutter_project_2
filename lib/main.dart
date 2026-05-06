import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart';
import 'Screens/login_page.dart';
import 'package:questifie_app/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // Makes sure Flutter is ready before doing anything
  WidgetsFlutterBinding.ensureInitialized();

  // Connect the app to Firebase using project credentials
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCxcTmfXvcPdXpHYv3fBHW2wloEPQ-AY4c',
      appId: '1:232979945221:android:11715f7ae0c20818bf496c',
      messagingSenderId: '232979945221',
      projectId: 'questifie-app',
      storageBucket: 'questifie-app.firebasestorage.app',
    ),
  );

  // Set up notifications, and ignore errors if it fails
  try {
    await NotificationService.init();
  } catch (e) {
    debugPrint('Notification init error: $e');
  }

  // Ask the user for notification permission if not yet granted
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Start the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner on screen
      routes: {
        '/login': (context) => const LoginPage(),
      }, // Named route for login
      home: const SplashScreen(), // First screen shown when app opens
    );
  }
}
