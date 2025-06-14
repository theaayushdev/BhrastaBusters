import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widget/topbar.dart'; // adjust path if necessary

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

    try {
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
    } catch (e) {
      setState(() {
        _statusMessage = "Error: Could not connect to server.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Your custom top bar widget
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
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
            const SizedBox(height: 30),

            // Graph Section (Expandable)
            Expanded(
              child: SingleChildScrollView(
            child: Column(
  children: [
    const SizedBox(height: 10),
    const Text(
      "Reports by District",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ),
    const SizedBox(height: 20),
    SizedBox(
      height: 300, // Set the desired height
      width: double.infinity, // Optional: make it take full width
      child: Image.network(
        "http://172.16.3.155:5000/external-static/graph/location_graph.png",
        fit: BoxFit.contain, // or BoxFit.cover if you want to crop
        errorBuilder: (context, error, stackTrace) {
          return const Text("Failed to load district graph");
        },
      ),
    ),
    const SizedBox(height: 30),
    const Text(
      "Reports by Department",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ),
    const SizedBox(height: 20),
    SizedBox(
      height: 300, // Set the desired height
      width: double.infinity, // Optional
      child: Image.network(
        "http://172.16.3.155:5000/external-static/graph/department_graph.png",
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Text("Failed to load department graph");
        },
      ),
    ),
    const SizedBox(height: 30),
  ],
),

              ),
            )
          ],
        ),
      ),
    );
  }
}