import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bhrastabusters/screens/secondpage.dart';
import '../screens/information.dart';
import '../screens/faq.dart';
import '../screens/report.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _imagePaths = [
    'assets/pic1.jpeg',
    'assets/pic2.jpg',
    'assets/pic3.jpeg',
    'assets/pic4.jpeg',
    'assets/pic5.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchTokenAndNavigate() async {
    try {
      final response = await http.get(
Uri.parse('http://172.16.3.155:5000/GenerateToken')
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondWidget(token: token), 
          ),
        );
      } else {
        print("Failed to fetch token. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching token: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003893),
        title: Row(
          children: [
            Image.asset('assets/twoflag.png', height: 40),
            const SizedBox(width: 40),
            const Text(
              'BhrastaSprasta',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Text(
                'Navigation',
                style: TextStyle(color: Color(0xFF003893), fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF003893)),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Color(0xFF003893)),
              title: const Text('Emergency Info'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => Emergency()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer, color: Color(0xFF003893)),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => FAQPage()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.info, color: Color(0xFF003893)),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportPage()),
                );
              },
            ),
          

          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _imagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _fetchTokenAndNavigate,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF003893),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Emergency', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
