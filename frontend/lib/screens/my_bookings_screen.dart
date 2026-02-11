import 'package:flutter/material.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          Card(
            child: ListTile(
              title: Text("Electrician Visit",
                  style: TextStyle(color: Colors.white)),
              subtitle: Text("Tomorrow • 5 PM",
                  style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
