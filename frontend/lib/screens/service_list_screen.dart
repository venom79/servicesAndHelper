import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Services")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: const Text("Electrician Service",
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text("₹500/hr • ⭐ 4.5",
                  style: TextStyle(color: Colors.grey)),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.grey),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.serviceDetail);
              },
            ),
          );
        },
      ),
    );
  }
}

