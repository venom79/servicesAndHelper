import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Service")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: "Select Date"),
            ),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(labelText: "Select Time"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.myBookings);
              },
              child: const Text("Confirm Booking"),
            )
          ],
        ),
      ),
    );
  }
}
