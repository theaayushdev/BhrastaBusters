import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widget/topbar.dart';

class Emergency extends StatelessWidget {
  final List<Map<String, String>> policeStations = [
    {'city': 'Kathmandu', 'number': '100 or 01-4200600'},
    {'city': 'Pokhara', 'number': '061-520000'},
    {'city': 'Biratnagar', 'number': '021-523243'},
    {'city': 'Butwal', 'number': '071-520000'},
    {'city': 'Nepalgunj', 'number': '081-520000'},
    {'city': 'Dhangadhi', 'number': '091-521111'},
    {'city': 'Janakpur', 'number': '041-520123'},
    {'city': 'Hetauda', 'number': '057-520789'},
    {'city': 'Dharan', 'number': '025-520345'},
    {'city': 'Bharatpur', 'number': '056-520456'},
    {'city': 'Gaur', 'number': '055-520987'},
    {'city': 'Ilam', 'number': '027-520654'},
    {'city': 'Lahan', 'number': '033-521111'},
    {'city': 'Tulsipur', 'number': '082-520321'},
    {'city': 'Baglung', 'number': '068-521222'},
  ];

  final Map<String, String> importantNumbers = {
    'Ambulance': '102',
    'Traffic Police': '104',
    'Fire Brigade': '101',
    'Women\'s Helpline': '1145',
    'Child Helpline': '1098',
    'Tourist Police': '1420',
  };

  void _makePhoneCall(String phoneNumber) async {
    
    String cleanNumber = phoneNumber.split(' ')[0];
    final Uri url = Uri(scheme: 'tel', path: cleanNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  IconData _getIconForEmergency(String key) {
    switch (key) {
      case 'Ambulance':
        return Icons.local_hospital;
      case 'Traffic Police':
        return Icons.traffic;
      case 'Fire Brigade':
        return Icons.local_fire_department;
      case 'Women\'s Helpline':
        return Icons.female;
      case 'Child Helpline':
        return Icons.child_care;
      case 'Tourist Police':
        return Icons.flight;
      default:
        return Icons.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Important Emergency Numbers',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003893),
              ),
            ),
            const SizedBox(height: 12),
            ...importantNumbers.entries.map(
              (entry) => Card(
                color: Colors.lightBlueAccent[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Icon(
                    _getIconForEmergency(entry.key),
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Emergency Number: ${entry.value}'),
                  trailing: const Icon(Icons.call, color: Color.fromARGB(255, 7, 148, 11)),
                  onTap: () {
                    _makePhoneCall(entry.value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Police Stations',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003893),
              ),
            ),
            const SizedBox(height: 12),
            ...policeStations.map(
              (station) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.local_police, color: Color.fromARGB(255, 7, 148, 11)),
                  title: Text(
                    station['city']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('Police Number: ${station['number']}'),
                  trailing: const Icon(Icons.call_outlined, color: Color.fromARGB(255, 7, 148, 11)),
                  onTap: () {
                    _makePhoneCall(station['number']!);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
