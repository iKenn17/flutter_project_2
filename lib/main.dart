import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart';
import 'Screens/login_page.dart';
import 'package:questifie_app/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCxcTmfXvcPdXpHYv3fBHW2wloEPQ-AY4c',
      appId: '1:232979945221:android:11715f7ae0c20818bf496c',
      messagingSenderId: '232979945221',
      projectId: 'questifie-app',
      storageBucket: 'questifie-app.firebasestorage.app',
    ),
  );

  try {
    await NotificationService.init();
  } catch (e) {
    debugPrint('Notification init error: $e');
  }

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/login': (context) => const LoginPage()},
      home: const SplashScreen(),
    );
  }
}
