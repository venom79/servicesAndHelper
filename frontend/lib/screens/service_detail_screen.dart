import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Professional Electrician",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 10),
            const Text("₹500 per hour",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            const Text(
              "Experienced electrician available for home repairs and wiring.",
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.booking);
              },
              child: const Text("Book Now"),
            )
          ],
        ),
      ),
    );
  }
}
