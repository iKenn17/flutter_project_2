import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  bool notificationsEnabled = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> logout(BuildContext context) async {
    await auth.signOut();

    if (mounted) {
      setState(() {
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
        );
      }); 
    }
  }

@override

  void initState() {
    super.initState();
    loadToggle();
  }
  

  void saveToggle(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('notifications', value);
}

void loadToggle() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    notificationsEnabled = prefs.getBool('notifications') ?? false;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 193, 177),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
        title: Text("Settings",
        style: TextStyle(
          color: Colors.white
        )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
                children: [
                  SwitchListTile(
                    title: Text("Enable Notifications:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )),             
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                  ),
            
                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await logout(context);
                      },
                       
                      child: Text("Log out")
                      ),
                  ],
                 )
                  
                ],
            ),
          ),
        ],
      ),
        
    );
    
  }
}