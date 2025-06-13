import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widget/topbar.dart';

class AwarenessPage extends StatelessWidget {
  void _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // If you want, show a snackbar or alert
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCard(
            title: 'What is corruption?',
            content: 'Corruption is when someone uses their power for personal benefit.',
          ),
          _buildCard(
            title: 'How to identify bribery?',
            content: 'Bribery is giving or receiving something of value to influence a decision.',
          ),
          _buildCard(
            title: 'Your rights under the law',
            content: 'You have the right to access information and report corruption.',
          ),
          SizedBox(height: 20),
          Text('Useful Links', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ListTile(
            title: Text('National Vigilance Centre'),
            subtitle: Text('https://nvc.gov.np'),
            onTap: () => _openLink('https://nvc.gov.np'),
          ),
          ListTile(
            title: Text('CIAA (Akhtiyar)'),
            subtitle: Text('https://ciaa.gov.np'),
            onTap: () => _openLink('https://ciaa.gov.np'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required String content}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
