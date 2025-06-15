import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widget/topbar.dart';

class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  final List<Map<String, String>> policeStations = [
    {'city': 'Kathmandu', 'number': '01-4261945'},
    {'city': 'Pokhara', 'number': '061-462500'},
    {'city': 'Biratnagar', 'number': '021-462158'},
    {'city': 'Butwal', 'number': '071-438111'},
    {'city': 'Nepalgunj', 'number': '081-520193'},
    {'city': 'Dhangadhi', 'number': '091-527111'},
    {'city': 'Janakpur', 'number': '041-520123'},
    {'city': 'Hetauda', 'number': '057-521499'},
    {'city': 'Dharan', 'number': '025-520274'},
    {'city': 'Bharatpur', 'number': '056-520197'},
    {'city': 'Gaur', 'number': '055-520040'},
    {'city': 'Ilam', 'number': '027-520115'},
    {'city': 'Lahan', 'number': '033-560470'},
    {'city': 'Tulsipur', 'number': '082-560106'},
    {'city': 'Baglung', 'number': '068-520199'},
  ];

  final Map<String, String> importantNumbers = {
    'Ambulance': '102',
    'Traffic Police': '104',
    'Fire Brigade': '101',
    'Women\'s Helpline': '1145',
    'Child Helpline': '1098',
    'Tourist Police': '1420',
  };

  String searchQuery = '';

  void _makePhoneCall(String phoneNumber) async {
    String cleanNumber = phoneNumber.split(' ')[0];
    final Uri url = Uri(scheme: 'tel', path: cleanNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  IconData _getIconFor(String label) {
    switch (label) {
      case 'Ambulance':
        return Icons.local_hospital_outlined;
      case 'Traffic Police':
        return Icons.traffic;
      case 'Fire Brigade':
        return Icons.local_fire_department_outlined;
      case 'Women\'s Helpline':
        return Icons.support_agent;
      case 'Child Helpline':
        return Icons.child_care_outlined;
      case 'Tourist Police':
        return Icons.airplane_ticket_outlined;
      default:
        return Icons.phone;
    }
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B396A),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: color ?? const Color(0xFF1B396A).withOpacity(0.1),
          child: Icon(icon, color: const Color(0xFF1B396A)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          onPressed: onTap,
        ),
      ),
    );
  }

  // Filtered lists based on search
  List<Map<String, String>> get filteredPoliceStations {
    if (searchQuery.isEmpty) return policeStations;
    return policeStations
        .where((station) =>
            station['city']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  Map<String, String> get filteredImportantNumbers {
    if (searchQuery.isEmpty) return importantNumbers;
    return Map.fromEntries(
      importantNumbers.entries.where((entry) =>
          entry.key.toLowerCase().contains(searchQuery.toLowerCase())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: const Color(0xFFF6F8FB),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search emergency or police station',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                if (filteredImportantNumbers.isNotEmpty) ...[
                  _buildSectionTitle("Emergency Numbers"),
                  ...filteredImportantNumbers.entries.map(
                    (entry) => _buildCard(
                      icon: _getIconFor(entry.key),
                      title: entry.key,
                      subtitle: 'Dial: ${entry.value}',
                      onTap: () => _makePhoneCall(entry.value),
                    ),
                  ),
                ],
                if (filteredPoliceStations.isNotEmpty) ...[
                  _buildSectionTitle("Police Stations"),
                  ...filteredPoliceStations.map(
                    (station) => _buildCard(
                      icon: Icons.local_police_outlined,
                      title: station['city']!,
                      subtitle: 'Dial: ${station['number']}',
                      onTap: () => _makePhoneCall(station['number']!),
                      color: Colors.green.withOpacity(0.1),
                    ),
                  ),
                ],
                if (filteredImportantNumbers.isEmpty && filteredPoliceStations.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        'No results found',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
