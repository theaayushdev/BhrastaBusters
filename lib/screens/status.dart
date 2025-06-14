import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widget/topbar.dart'; // Adjust if path differs

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final TextEditingController _tokenController = TextEditingController();
  String? _statusMessage;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _checkToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      setState(() {
        _statusMessage = "Please enter a token.";
      });
      return;
    }

    final response = await http.get(
      Uri.parse("http://172.16.3.155:5000/status/$token"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _statusMessage = "Status: ${data['status']}";
      });
    } else {
      final error = jsonDecode(response.body);
      setState(() {
        _statusMessage = error['error'] ?? "Failed to fetch status.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Your top bar
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: 'Enter your token',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkToken,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003893),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Check Status',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            if (_statusMessage != null)
              Text(
                _statusMessage!,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}