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
      bool needsReauth =
          emailController.text.trim() != user?.email ||
          passwordController.text.trim().isNotEmpty;

      if (needsReauth) {
        if (currentPasswordController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Enter current password")),
          );
          return;
        }

        await reauthenticate();
      }

      if (nameController.text.trim() != user?.displayName) {
        await user!.updateDisplayName(nameController.text.trim());
      }

      if (emailController.text.trim() != user?.email) {
        await user!.verifyBeforeUpdateEmail(emailController.text.trim());
      }

      if (passwordController.text.trim().isNotEmpty) {
        await user!.updatePassword(passwordController.text.trim());

        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

        return;
      }

      await user!.reload();

      passwordController.clear();
      currentPasswordController.clear();

      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile Updated")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
      style: const TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        filled: true,
        fillColor: const Color.fromARGB(255, 235, 225, 210),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 40, 33, 31),
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 204, 193, 177),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
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
                child: Text(
                  isEditing ? "Save" : "Edit Profile",
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              buildField(
                label: "Name",
                controller: nameController,
                enabled: isEditing,
              ),
              const SizedBox(height: 20),
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
              if (isEditing) const SizedBox(height: 10),
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
      ),
    );
  }
}
