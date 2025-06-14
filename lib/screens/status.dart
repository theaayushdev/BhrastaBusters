import 'package:flutter/material.dart';
// Import or define CustomAppBar if it's a custom widget
import '../widget/topbar.dart'; // assuming it's defined here

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Status Page Content Here',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
