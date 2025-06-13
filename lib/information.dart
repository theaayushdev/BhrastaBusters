import 'package:flutter/material.dart';

class emergency extends StatelessWidget 


{
  final List<Map<String, String>> policeStations = 
  [
    {'city': 'Kathmandu', 'number': '100 or 01-4200600'},
    {'city': 'Pokhara', 'number': '061-520000'},
    {'city': 'Biratnagar', 'number': '021-523243'},
    {'city': 'Butwal', 'number': '071-520000'},
    {'city': 'Nepalgunj', 'number': '081-520000'},
  ];

  final Map<String, String> importantNumbers = 
  {
    'Ambulance': '102',
    'Traffic Police': '104',
    'Fire Brigade': '101',
    'Women\'s Helpline': '1145',
    'Child Helpline': '1098',
    'Tourist Police': '1420',
  };


@override
  Widget build(BuildContext context) 
  
  {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Nepal Emergency Info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Important Emergency Numbers',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
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
                  trailing: const Icon(Icons.call, color: Colors.lightBlueAccent),
                  onTap: () {
                    
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Police Stations',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue
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
                  leading: Icon(Icons.local_police, color: Colors.lightBlue[700]),
                  title: Text(
                    station['city']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('Police Number: ${station['number']}'),
                  trailing: const Icon(Icons.call_outlined, color: Colors.lightBlue),
                  onTap: () {
                   
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  IconData _getIconForEmergency(String key) 
  
  
  {
    switch (key) 
    {
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
}
