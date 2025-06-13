// main.dart
import 'package:flutter/material.dart';
import 'screens/homescreen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BhrastaSprasta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF003893),
      ),
      home: const HomePage(),
    );
  }
}
