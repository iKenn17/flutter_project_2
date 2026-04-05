import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get user => auth.currentUser;

  bool isEditing = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final currentPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = user?.displayName ?? '';
    emailController.text = user?.email ?? '';
  }

  Future<void> reauthenticate() async {
    final currentUser = auth.currentUser;

    if (currentUser == null) return;

    final credential = EmailAuthProvider.credential(
      email: currentUser.email!,
      password: currentPasswordController.text.trim(),
    );

    await currentUser.reauthenticateWithCredential(credential);
  }

  Future<void> saveChanges() async {
    try {
      if (nameController.text.trim() != user?.displayName) {
        await user!.updateDisplayName(nameController.text.trim());
      }

      if (emailController.text.trim() != user?.email) {
        await reauthenticate();
        await user!.verifyBeforeUpdateEmail(emailController.text.trim());
      }

      if (passwordController.text.trim().isNotEmpty) {
        await reauthenticate();
        await user!.updatePassword(passwordController.text.trim());
      }

      await user!.reload();

      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Widget buildField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    bool enabled = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 193, 177),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 40, 33, 31),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  saveChanges();
                } else {
                  setState(() {
                    isEditing = true;
                  });
                }
              },
              child: Text(isEditing ? "Save" : "Edit Profile",
              style: TextStyle(
                color: Colors.blue
              ),),
            ),

            const SizedBox(height: 20),

            buildField(
              label: "Name",
              controller: nameController,
              enabled: isEditing,
            ),
            const SizedBox(height: 10),

            buildField(
              label: "Email",
              controller: emailController,
              enabled: isEditing,
            ),
            const SizedBox(height: 10),

            if (isEditing)
              buildField(
                label: "New Password",
                controller: passwordController,
                obscure: true,
                enabled: true,
              ),

            if (isEditing)
              const SizedBox(height: 10),

            if (isEditing)
              buildField(
                label: "Current Password",
                controller: currentPasswordController,
                obscure: true,
                enabled: true,
              ),

            const SizedBox(height: 20),

            
          ],
        ),
      ),
    );
  }
}