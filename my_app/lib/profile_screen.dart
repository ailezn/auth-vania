import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> data; // Data dari LoginScreen

  const ProfileScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("ID: ${data['id'] ?? 'No ID'}"),
            Text("Name: ${data['name'] ?? 'No Name'}"),
            Text("Email: ${data['email'] ?? 'No Email'}"),
            Text("Created At: ${data['created_at'] ?? 'No Date'}"),
            Text("Updated At: ${data['updated_at'] ?? 'No Update'}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke LoginScreen
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
