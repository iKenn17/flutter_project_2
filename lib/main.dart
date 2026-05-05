import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Screens/login_page.dart';
import 'Screens/homepage.dart';
import 'package:questifie_app/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCxcTmfXvcPdXpHYv3fBHW2wloEPQ-AY4c',
        appId: '1:232979945221:android:11715f7ae0c20818bf496c',
        messagingSenderId: '232979945221',
        projectId: 'questifie-app',
        storageBucket: 'questifie-app.firebasestorage.app',
      ),
    );
  } catch (e) {
    print('Firebase init failed: $e');
  }
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  await NotificationService.init();
  await requestNotificationPermission();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/login': (context) => const LoginPage()},
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            return const HomePage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}
