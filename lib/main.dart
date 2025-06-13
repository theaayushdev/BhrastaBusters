import 'package:flutter/material.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF003893),
          title: const Text('BhrastaBusters'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
