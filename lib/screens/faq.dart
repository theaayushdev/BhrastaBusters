import 'package:flutter/material.dart';
import '../widget/topbar.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  final List<Map<String, String>> faqs = const [
    {
      'question': 'Is my identity kept secret?',
      'answer':
          'Yes. BhrastaBusters ensures complete anonymity. We do not collect any personal information.',
    },
    {
      'question': 'How does BhrastaBusters work?',
      'answer':
          'Users can report corruption anonymously. The report is sent to proper authorities for review.',
    },
    {
      'question': 'Do I need to sign up or log in?',
      'answer':
          'No login or sign-up is required. Just open the app and report.',
    },
    {
      'question': 'Can someone trace my report back to me?',
      'answer':
          'No. We don’t collect device info, location, or identity  your report is 100% untraceable.',
    },
    {
      'question': 'Is this app free to use?',
      'answer':
          'Yes. BhrastaBusters is completely free and made for the public good.',
    },
    {
      'question': 'Can I upload images or documents?',
      'answer': 'Yes, you can add photo evidence while submitting your report.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
         
            Center(
              child: Column(
                children: const [
                  Text(
                    'Frequently Asked Questions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: 200,
                    child: Divider(color: Colors.deepPurple, thickness: 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // FAQ List
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        faq['question']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(faq['answer']!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
