import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 15),
            const Text("User Name",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.login);
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
