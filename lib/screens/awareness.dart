import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widget/topbar.dart';

class AwarenessPage extends StatelessWidget {
  void _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Know Your Rights',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF003893)),
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.info,
            title: 'What is Corruption?',
            content: 'Corruption is the abuse of entrusted power for private gain. It undermines trust, hampers development, and hurts democracy.',
          ),
          _buildCard(
            icon: Icons.money_off_csred_outlined,
            title: 'What is Bribery?',
            content: 'Bribery involves giving or receiving money or favors to influence a decision or gain unfair advantage.',
          ),
          _buildCard(
            icon: Icons.gavel,
            title: 'Your Legal Rights',
            content: 'Every citizen has the right to access government information, file complaints, and demand transparency.',
          ),
          _buildCard(
            icon: Icons.shield,
            title: 'Whistleblower Protection',
            content: 'Those who report corruption are protected by law. You can report anonymously too.',
          ),
          const SizedBox(height: 24),
          const Text(
            'Useful Links',
             textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF003893)),
          ),
          const SizedBox(height: 12),
          _buildLinkTile(
            icon: FontAwesomeIcons.shieldHalved,
            title: 'National Vigilance Centre',
            url: 'https://nvc.gov.np',
          ),
          _buildLinkTile(
            icon: FontAwesomeIcons.scaleBalanced,
            title: 'CIAA (Akhtiyar)',
            url: 'https://ciaa.gov.np',
          ),
          
        ],
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, required String content}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.blue.shade800),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(content, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required String url,
  }) {
    return ListTile(
      onTap: () => _openLink(url),
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: Text(url, style: const TextStyle(color: Colors.blue)),
      trailing: const Icon(Icons.open_in_new),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _quoteCard({required String quote, required String author}) {
    return Card(
      elevation: 3,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              quote,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              author,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
