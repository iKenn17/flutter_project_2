import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 193, 177),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentGeometry.topCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 40, 33, 31),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person,
                      size: 40.0,
                      color: Colors.white,)
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 40, 33, 31),
                padding: EdgeInsets.symmetric(horizontal: 5.5, vertical: 2),
                fixedSize: Size(100, 20)
              ),
              onPressed: () {
                
              },
              child: Text("EDIT PROFILE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12
              ),)
            ),

            SizedBox(height: 20),

            Text("")

          ],
        )
      )
    );
  }
}