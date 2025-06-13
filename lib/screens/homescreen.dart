import 'dart:async';
import 'package:flutter/material.dart';
import 'information.dart'; 
import '../widget/topbar.dart'; 
//import 'reporting1.dart';
class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003893),
        title: Row(
          children: [
            Image.asset(
              'assets/twoflag.png',
              height: 40,
            ),
            const SizedBox(width: 40),
            const Text(
              'BhrastaSprasta',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Text(
                'Navigation',
                style: TextStyle(color: Color(0xFF003893), fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Color(0xFF003893)),
              title: Text('Section 1'),
            ),
            ListTile(
              leading: Icon(Icons.info, color: Color(0xFF003893)),
              title: Text('Section 2'),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF003893)),
              title: Text('Section 3'),
            ),
            ListTile(
              leading: Icon(Icons.contact_mail, color: Color(0xFF003893)),
              title: Text('Section 4'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: SizedBox(
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
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyWidget(),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF003893),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Test',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}