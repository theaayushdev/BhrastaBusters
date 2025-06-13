import 'package:flutter/material.dart';

class NepalEmergencyInfoScreen extends StatelessWidget {
  final List<Map<String, String>> policeStations = [
    {'city': 'Kathmandu', 'number': '100 or 01-4200600'},
    {'city': 'Pokhara', 'number': '061-520000'},
    {'city': 'Biratnagar', 'number': '021-523243'},
    {'city': 'Butwal', 'number': '071-520000'},
    {'city': 'Nepalgunj', 'number': '081-520000'},
  ];

  final Map<String, String> importantNumbers = {
    'Ambulance': '102',
    'Traffic Police': '104',
    'Fire Brigade': '101',
    'Women\'s Helpline': '1145',
    'Child Helpline': '1098',
    'Tourist Police': '1420',
  };

