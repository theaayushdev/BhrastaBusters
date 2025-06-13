import 'package:flutter/material.dart';
import '../widget/topbar.dart'; // Adjust path as needed

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Using the custom AppBar
      body: const Center(
        child: Text("Empty for now"),
      ),
    );
  }
}
