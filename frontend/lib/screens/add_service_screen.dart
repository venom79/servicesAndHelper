import 'package:flutter/material.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Service")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            TextField(
              decoration: InputDecoration(labelText: "Service Title"),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(labelText: "Price per hour"),
            ),
          ],
        ),
      ),
    );
  }
}
